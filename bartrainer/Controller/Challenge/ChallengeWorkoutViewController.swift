//
//  ChallengeWorkoutViewController.swift
//  bartrainer
//
//  Created by Methira Denthongchai on 15/2/2562 BE.
//  Copyright © 2562 Methira Denthongchai. All rights reserved.
//


import UIKit
import Vision
import CoreMedia
import Alamofire
import AlamofireImage


class ChallengeWorkoutViewController: UIViewController, VideoCaptureDelegate {
    
    public typealias BodyPoint = (point: CGPoint, confidence: Double)
    public typealias DetectObjectsCompletion = ([BodyPoint?]?, Error?) -> Void
    
    // MARK: - UI 프로퍼티
    @IBOutlet weak var videoPreview: UIView!
    @IBOutlet weak var poseView: PoseView!
    @IBOutlet weak var gifExercise: UIImageView!
    
    
    @IBOutlet weak var tryLabel: UILabel!
    @IBOutlet weak var timer: UILabel!
    
    var timerr:Timer!
    var countdown:Int = 10
    
    
    private var tableData: [BodyPoint?] = []
    
    private var moveCalculate: movePoint = movePoint()
    var scoreCal = 0

    
    var challengeGroup: [Challenge] = []
    var selectedChallengeGroup: ChallengeName?
    var selectedChallenge: Challenge?
    
    var id_ex:Int = 0
    var id_ch:Int = 0
    var reps:Int = 0
    
    
    
    @IBAction func squatButton(_ sender: UIButton) {
        self.videoCapture.stop()
    }
    
    // MARK - 성능 측정 프러퍼티
    private let 👨‍🔧 = 📏()
    
    
    
    
    // MARK - Core ML model
    //    typealias EstimationModel = model_40500
    typealias EstimationModel = model_cpm
    var coremlModel: EstimationModel? = nil
    // mv2_cpm_1_three
    
    
    
    
    // MARK: - Vision 프로퍼티
    
    var request: VNCoreMLRequest!
    var visionModel: VNCoreMLModel! {
        didSet {
            request = VNCoreMLRequest(model: visionModel, completionHandler: visionRequestDidComplete)
            request.imageCropAndScaleOption = .scaleFill
        }
    }
    
    
    // MARK: - AV 프로퍼티
    
    var videoCapture: VideoCapture!
    let semaphore = DispatchSemaphore(value: 2)
    
    
    
    // MARK: - 라이프사이클 메소드
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "bg.png")!)
        if selectedChallenge!.id_exercise == "1"{
            gifExercise.loadGif(name: "squatGIF")
        }else if selectedChallenge!.id_exercise == "2"{
            gifExercise.loadGif(name: " ")
        }else if selectedChallenge!.id_exercise == "3"{
            gifExercise.loadGif(name: "hightkneeGIF")
        }else if selectedChallenge!.id_exercise == "4"{
            gifExercise.loadGif(name: "legraiseGIF")
        }else if selectedChallenge!.id_exercise == "5"{
            gifExercise.loadGif(name: "legswingGIF")
        }else{
            gifExercise.loadGif(name: " ")
        }
        
        id_ex = Int((selectedChallenge?.id_exercise)!) ?? 5
        id_ch = Int((selectedChallengeGroup?.id)!) ?? 5
        reps = Int((selectedChallenge?.reps)!) ?? 5
        
        visionModel = try? VNCoreMLModel(for: EstimationModel().model)
        setUpCamera()
        poseView.setUpOutputComponent()
        //            self.view.backgroundColor = UIColor(patternImage: UIImage(named: "bg.png")!)
        self.title = selectedChallengeGroup!.name
        
        
        Alamofire.request("http://tssnp.com/ws_bartrainer/challenge_detail.php?id_challenge=\(selectedChallenge!.id)").responseData { response in
            if let data = response.result.value {
                
                do {
                    let decoder = JSONDecoder()
                    
                    self.challengeGroup = try decoder.decode([Challenge].self, from: data)
                    
                } catch {
                    print(error.localizedDescription)
                }
            } else {
                print("error")
            }
        }
        
        
    }
    @objc func countdownAction(){
        countdown -= 1
        
        if countdown == 0 {
            timerr.invalidate()
            timer.text = "0"
            challengeWorkout(id_challenge: id_ch ,id_user: 1,id_exercise: id_ex,reps: scoreCal,cal: 10)
//            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Main")
//            UIApplication.shared.keyWindow?.rootViewController = vc
            self.videoCapture.stop()
               performSegue(withIdentifier: "workoutFinish", sender: self)
            
            
        }else if countdown <= 5 {
            timer.text = "\(countdown)"
        }else  {
            timer.text = " "
        }
    }
    func  countdownStart() {
        timerr = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(countdownAction), userInfo: nil, repeats: true)
    }
    
    func countdownStop(){
        timerr.invalidate()
        countdown = 10

        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "workoutFinish" {
            let vc = segue.destination as! ChallengeFinishViewController
            vc.selectedChallengeGroup = selectedChallengeGroup
            vc.selectedChallenge = selectedChallenge
            vc.scoreCal = scoreCal
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    // MARK: - 초기 세팅
    
    func setUpCamera() {
        videoCapture = VideoCapture()
        videoCapture.delegate = self
        videoCapture.fps = 30
        videoCapture.setUp(sessionPreset: .vga640x480) { success in
            
            if success {
                // UI에 비디오 미리보기 뷰 넣기
                if let previewLayer = self.videoCapture.previewLayer {
                    self.videoPreview.layer.addSublayer(previewLayer)
                    self.resizePreviewLayer()
                }
                
                // 초기설정이 끝나면 라이브 비디오를 시작할 수 있음
                self.videoCapture.start()
            }
        }
    }
    
    func resizePreviewLayer() {
        videoCapture.previewLayer?.frame = videoPreview.bounds
    }
    
    
    
    // MARK: - 추론하기
    
    func predictUsingVision(pixelBuffer: CVPixelBuffer) {
        // Vision이 입력이미지를 자동으로 크기조정을 해줄 것임.
        let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer)
        try? handler.perform([request])
    }
    
    func visionRequestDidComplete(request: VNRequest, error: Error?) {
        self.👨‍🔧.🏷(with: "endInference")
        if let observations = request.results as? [VNCoreMLFeatureValueObservation],
            let heatmap = observations.first?.featureValue.multiArrayValue {
            
            // convert heatmap to [keypoint]
            let n_kpoints = convert(heatmap: heatmap)
            _ = moveCalculate.addKeypoints(keypoints: n_kpoints,nameEx: selectedChallengeGroup!.name)
            var timerCount: Int = 0
            
            if selectedChallenge!.id_exercise == "1"{
                timerCount = self.moveCalculate.calSquat()
            }else if selectedChallenge!.id_exercise == "2"{
                timerCount = self.moveCalculate.calLunge()
                
            }else if selectedChallenge!.id_exercise == "3"{
                timerCount = self.moveCalculate.calHightknee()
            }else if selectedChallenge!.id_exercise == "4"{
                timerCount = self.moveCalculate.calLegraiseSide()
            }else if selectedChallenge!.id_exercise == "5"{
                timerCount = self.moveCalculate.calLegSwing()
            }
            
            
            
            
            
            
            DispatchQueue.main.sync {
                
                
                
                
                if timerCount == 1 {
                    if timerr != nil{
                        countdownStop()
                        countdownStart()
                    }else {
                        countdownStart()
                    }
                    scoreCal += timerCount
                }
                if scoreCal == reps {
                    challengeWorkout(id_challenge: id_ch ,id_user: 1,id_exercise: id_ex,reps: scoreCal,cal: 10)
                    countdownStop()
                    performSegue(withIdentifier: "workoutFinish", sender: self)
                    self.videoCapture.stop()
          
//                    let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Main")
//                    UIApplication.shared.keyWindow?.rootViewController = vc
                }
               
                
                self.poseView.bodyPoints = n_kpoints
                
                if scoreCal != 0 {
                    self.tryLabel.text = "\(scoreCal) \r\n/ \(reps) "
                }else {
                    self.tryLabel.text = " 0 / \(reps) "
                }
                
            
                
                // end of measure
                self.👨‍🔧.🎬🤚()
                
                
            }
        }
    }
    
    func challengeWorkout(id_challenge: Int,id_user: Int,id_exercise: Int,reps: Int,cal: Int) {
        
        let param: Parameters = [
            "id_challenge": id_challenge,
            "id_user": id_user,
            "id_exercise": id_exercise,
            "reps": reps,
            "cal": cal
            
            
        ]
        
        Alamofire.request("http://tssnp.com/ws_bartrainer/challengeWorkout.php", method: .post, parameters: param, encoding: URLEncoding.default, headers: nil).responseData { response in
            if let data = response.result.value {
                let decoder = JSONDecoder()
                
                do {
                    let result = try decoder.decode(APIresponse.self, from: data)
                    
                    print(result)
                    
                    if result.message == "success" {
                        
                    } else {
                        if result.error == "23000" {
                            Alert.showAlert(vc: self, title: "Error", message: "email หรือ รหัสบัตรประชนมีในระบบแล้ว", action: nil)
                        } else {
                            Alert.showAlert(vc: self, title: "Error", message: "server ผิดพลาด", action: nil)
                        }
                    }
                    
                } catch {
                    Alert.showAlert(vc: self, title: "Error", message: error.localizedDescription, action: nil)
                }
            } else {
                Alert.showAlert(vc: self, title: "Error", message: "กรุณาลองใหม่อีกครั้ง", action: nil)
            }
        }
    }
    
    
    
    
    func convert(heatmap: MLMultiArray) -> [BodyPoint?] {
        guard heatmap.shape.count >= 3 else {
            print("heatmap's shape is invalid. \(heatmap.shape)")
            return []
        }
        let keypoint_number = heatmap.shape[0].intValue
        let heatmap_w = heatmap.shape[1].intValue
        let heatmap_h = heatmap.shape[2].intValue
        
        var n_kpoints = (0..<keypoint_number).map { _ -> BodyPoint? in
            return nil
        }
        
        
        for k in 0..<keypoint_number {
            for i in 0..<heatmap_w {
                for j in 0..<heatmap_h {
                    let index = k*(heatmap_w*heatmap_h) + i*(heatmap_h) + j
                    let confidence = heatmap[index].doubleValue
                    guard confidence > 0 else { continue }
                    if n_kpoints[k] == nil ||
                        (n_kpoints[k] != nil && n_kpoints[k]!.confidence < confidence) {
                        n_kpoints[k] = (CGPoint(x: CGFloat(j), y: CGFloat(i)), confidence)
                    }
                }
            }
        }
        
        // transpose to (1.0, 1.0)
        n_kpoints = n_kpoints.map { kpoint -> BodyPoint? in
            if let kp = kpoint {
                return (CGPoint(x: 1 - kp.point.x/CGFloat(heatmap_w),
                                y: kp.point.y/CGFloat(heatmap_h)),
                        kp.confidence)
                
            } else {
                return nil
            }
        }
        
        
        return n_kpoints
    }
    
    // MARK: - VideoCaptureDelegate
    
    func videoCapture(_ capture: VideoCapture, didCaptureVideoFrame pixelBuffer: CVPixelBuffer?, timestamp: CMTime) {
        // 카메라에서 캡쳐된 화면은 pixelBuffer에 담김.
        // Vision 프레임워크에서는 이미지 대신 pixelBuffer를 바로 사용 가능
        if let pixelBuffer = pixelBuffer {
            // start of measure
            self.👨‍🔧.🎬👏()
            
            // predict!
            self.predictUsingVision(pixelBuffer: pixelBuffer)
        }
    }
    
    
}


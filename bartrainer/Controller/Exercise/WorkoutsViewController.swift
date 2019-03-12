//
//  WorkoutsViewController.swift
//  bartrainer
//
//  Created by Methira Denthongchai on 13/2/2562 BE.
//  Copyright © 2562 Methira Denthongchai. All rights reserved.
//


import UIKit
import Vision
import CoreMedia
import Alamofire
import AlamofireImage
import CountdownView


class WorkoutsViewController: UIViewController , VideoCaptureDelegate {
    
    public typealias BodyPoint = (point: CGPoint, confidence: Double)
    public typealias DetectObjectsCompletion = ([BodyPoint?]?, Error?) -> Void
    
    @IBOutlet weak var nameExercise: UILabel!
    // MARK: - UI 프로퍼티
    @IBOutlet weak var videoPreview: UIView!
    @IBOutlet weak var poseView: PoseView!
    @IBOutlet weak var gifExercise: UIImageView!
    
    @IBOutlet weak var exerciseName: UILabel!
    
    @IBOutlet weak var tryLabel: UILabel!
    @IBOutlet weak var timer: UILabel!
    @IBOutlet weak var reps: UILabel!
    
    var timerr:Timer!
    var countdown:Int = 0
    var countdownExercise:Int = 0
    var timerExercise:Int = 0

    var index:Int = 0
    
    var id_ex:Int = 0
    var loadGIF:Int = 0
    
    //timer
    var spin = true
    var autohide = false
    var appearingAnimation = CountdownView.Animation.zoomIn
    var disappearingAnimation = CountdownView.Animation.zoomOut
    
    
    private var tableData: [BodyPoint?] = []
    
    private var moveCalculate: movePoint = movePoint()
    var scoreCal = 0
    var exerciseloop: Int = 0
    
    var scoreExercise:[Int] = []
 
    
    var selectedCategoryGroup: Category?
    var ExerciseList: [Exercise] = []
    var levelExercise: Level?
    
    
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

        //timer
        CountdownView.shared.backgroundViewColor = UIColor.red.withAlphaComponent(0.3)
        CountdownView.shared.spinnerStartColor = UIColor(red:1, green:0, blue:0, alpha:0.8).cgColor
        CountdownView.shared.spinnerEndColor = UIColor(red:1, green:0, blue:0, alpha:0.8).cgColor
        
        visionModel = try? VNCoreMLModel(for: EstimationModel().model)
        setUpCamera()
        poseView.setUpOutputComponent()
        //            self.view.backgroundColor = UIColor(patternImage: UIImage(named: "bg.png")!)
        

       Alamofire.request("http://tssnp.com/ws_bartrainer/exercise_category.php?group_id=\(selectedCategoryGroup!.id)").responseData { response in
            if let data = response.result.value {
                
                do {
                    let decoder = JSONDecoder()
                    
                    self.ExerciseList = try decoder.decode([Exercise].self, from: data)
        
                } catch {
                    print(error.localizedDescription)
                }
            } else {
                print("error")
            }
        }
        


        countdown = Int((levelExercise?.rest)!) ?? 0
        countdownExercise = Int((levelExercise?.timer)!) ?? 0
        timerExercise = Int((levelExercise?.timer)!) ?? 0
        print(countdownExercise)
                 self.countdownExerciseStart()
    
     
        
        
        
    }
    @objc func countdownAction(){
        countdown -= 1
        
        if countdown == 0 {
            timerr.invalidate()
            timer.text = ""
            self.tryLabel.text = "0"
             CountdownView.hide(animation: disappearingAnimation, options: (duration: 0.5, delay: 0.2), completion: nil)
//            self.videoCapture.stop()
             self.videoCapture.start()
              countdownExercise = Int((levelExercise?.timer)!) ?? 0
            countdownExerciseStart()
            
 
        }else  {
            CountdownView.show(countdownFrom: Double(countdown), spin: spin, animation: appearingAnimation, autoHide: autohide,
                               completion: nil)

        }
    }
    func  countdownStart() {
        timerr = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(countdownAction), userInfo: nil, repeats: true)
        self.videoCapture.stop()
    }
    
    func countdownStop(){
        timerr.invalidate()
         countdown = Int((levelExercise?.rest)!) ?? 0
        
    }
    @objc func countdownExerciseAction(){
        countdownExercise -= 1
        
        if countdownExercise == 0 {
             timerr.invalidate()
            nextExercise()
            timer.text = ""

            
        }else {
            timer.text = "\(countdownExercise)"
        }
        
    }
    func  countdownExerciseStart() {
     timerr = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(countdownExerciseAction), userInfo: nil, repeats: true)
        
    }
    func nextExercise()  {
        
        print("nextlevel")
        countdownExercise = Int((levelExercise?.timer)!) ?? 0
        if (countdown == 0){
            countdown = Int((levelExercise?.rest)!) ?? 0
            
        }
        countdownStart()
        if(exerciseloop<ExerciseList.count){
            
            
            exerciseloop+=1
            scoreCal=0
            exerciseWorkout(id_user: 1, id_exercise: id_ex, id_category: Int((selectedCategoryGroup?.id)!) ?? 0,category: selectedCategoryGroup?.name ?? "aa", level: Int((levelExercise?.level)!) ?? 0, reps: scoreCal, cal: 10)
            
            
        }
        if(exerciseloop == ExerciseList.count){
            
            loadGIF = 0
            countdownStop()
            performSegue(withIdentifier: "WorkoutFinish", sender: self)
            self.videoCapture.stop()
            
            
        }
        
    }
    

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "WorkoutFinish" {
            let vc = segue.destination as! ExerciseFinishViewController
            vc.selectedCategoryGroup = selectedCategoryGroup
            
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
            _ = moveCalculate.addKeypoints(keypoints: n_kpoints)
            var timerCount: Int = 0
            
            let indexPath = NSIndexPath(row: exerciseloop, section: 0)
            let model = ExerciseList[indexPath.row]
            timerCount = moveCalculate.callExercise(idEx: Int(model.id_exercise) ?? 1)
            id_ex = Int((model.id_exercise)) ?? 5
            
        

            DispatchQueue.main.sync {
                
                if (loadGIF == 0){
                    if model.name == "Squat"{
                        gifExercise.loadGif(name: "squatGIF")
                        
                    }else if model.name == "Lunges"{
                        gifExercise.loadGif(name: " ")
                    }else if model.name == "Hight knee"{
                        gifExercise.loadGif(name: "hightkneeGIF")
                    }else if model.name == "Side Leg raise"{
                        gifExercise.loadGif(name: "legraiseGIF")
                    }else if model.name == "Leg swing"{
                        gifExercise.loadGif(name: "legswingGIF")
                    }else if model.name == "Shoulder press"{
                        gifExercise.loadGif(name: "ShoulderPressGIF")
                    }else{
                        gifExercise.loadGif(name: " ")
                    }
                    
                    loadGIF += 1
                }
             
                
                nameExercise.text = model.name
                
                if timerCount == 1 {
                    
                    scoreCal += timerCount
                }
                if scoreCal != 0{
                       self.tryLabel.text = "\(scoreCal)"
                }
                
     
                let repsExercise =  timerExercise/Int(model.persec)!
                self.reps.text = "/\(repsExercise)"
                if scoreCal == repsExercise {
                            print("scoreCal")
                    nextExercise()
              
                

                }
                
       
                
                self.poseView.bodyPoints = n_kpoints
                
              
            
                // end of measure
                self.👨‍🔧.🎬🤚()
                
                
         
                
            }
        }
        
    
    }
    
    
    func exerciseWorkout( id_user: Int, id_exercise: Int,id_category: Int, category: String, level: Int, reps: Int, cal: Int) {
        
        let param: Parameters = [
            "id_user": id_user,
            "id_exercise": id_exercise,
            "id_category": id_category,
            "category": category,
             "level": level,
            "reps": reps,
            "cal": cal
            
            
        ]
        
        Alamofire.request("http://tssnp.com/ws_bartrainer/exercise_workout.php", method: .post, parameters: param, encoding: URLEncoding.default, headers: nil).responseData { response in
            if let data = response.result.value {
                let decoder = JSONDecoder()
                
                do {
                    let result = try decoder.decode(APIresponse.self, from: data)
                    
                    print(result)
                
                    
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





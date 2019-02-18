//
//  BattleExerciseViewController.swift
//  bartrainer
//
//  Created by Methira Denthongchai on 22/1/2562 BE.
//  Copyright © 2562 Methira Denthongchai. All rights reserved.
//

import UIKit
import Vision
import CoreMedia
import Alamofire
import AlamofireImage


class BattleExerciseViewController: UIViewController, VideoCaptureDelegate {
        
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
    
        var selectedExercise: Exercise?
        var ExerciseList: [Exercise] = []

    
        
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
            if selectedExercise!.name == "Squat"{
                gifExercise.loadGif(name: "squatGIF")
            }else if selectedExercise!.name == "Lunges"{
                  gifExercise.loadGif(name: " ")
            }else if selectedExercise!.name == "Hight knee"{
                    gifExercise.loadGif(name: "hightkneeGIF")
            }else if selectedExercise!.name == "Side Leg raise"{
                    gifExercise.loadGif(name: "legraiseGIF")
            }else if selectedExercise!.name == "Leg swing"{
                    gifExercise.loadGif(name: "legswingGIF")
            }else{
                  gifExercise.loadGif(name: " ")
            }
            
         
            visionModel = try? VNCoreMLModel(for: EstimationModel().model)
            setUpCamera()
            poseView.setUpOutputComponent()
//            self.view.backgroundColor = UIColor(patternImage: UIImage(named: "bg.png")!)
            self.title = selectedExercise!.name
            
            
            Alamofire.request("http://tssnp.com/ws_bartrainer/exercise.php").responseData { response in
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
            
  
    }
    @objc func countdownAction(){
        countdown -= 1
        
        if countdown == 0 {
            timerr.invalidate()
            timer.text = "0"
            performSegue(withIdentifier: "battle_done", sender: self)
                     self.videoCapture.stop()
            

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
        if segue.identifier == "battle_done" {
            let vc = segue.destination as! BattleFinishViewController
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
                _ = moveCalculate.addKeypoints(keypoints: n_kpoints,nameEx: selectedExercise!.name)
                var timerCount: Int = 0
                
                if selectedExercise!.name == "Squat"{
                        timerCount = self.moveCalculate.calSquat()
                }else if selectedExercise!.name == "Lunges"{
                      timerCount = self.moveCalculate.calLunge()

                }else if selectedExercise!.name == "Hight knee"{
                    timerCount = self.moveCalculate.calHightknee()
                }else if selectedExercise!.name == "Side Leg raise"{
                    timerCount = self.moveCalculate.calLegraiseSide()
                }else if selectedExercise!.name == "Leg swing"{
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

                    self.poseView.bodyPoints = n_kpoints
                
                    if scoreCal != 0 {
                        self.tryLabel.text = "\(scoreCal)"
                    }


                    
                  

                    
                    
                    
                    // end of measure
                    self.👨‍🔧.🎬🤚()
                    
                    
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

class  battleEX: movePoint {
    
    
    
    func squatBT() -> Int {
        return 0
    }
    
}
//
//class timer{
//    
//    var countdownTimer: Timer!
//    var totalTime = 5
//    
//    func startTimer() {
//        countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
//    }
//    
//    func updateTime() {
////        timerLabel.text = "\(timeFormatted(totalTime))"
//        
//        if totalTime != 0 {
//            totalTime -= 1
//        } else {
//            endTimer()
//        }
//    }
//    
//    func endTimer() {
//        countdownTimer.invalidate()
//    }
//    
//    func timeFormatted(_ totalSeconds: Int) -> String {
//        let seconds: Int = totalSeconds % 60
//        let minutes: Int = (totalSeconds / 60) % 60
//        //     let hours: Int = totalSeconds / 3600
//        return String(format: "%02d:%02d", minutes, seconds)
//    }
//
//}
//    
//

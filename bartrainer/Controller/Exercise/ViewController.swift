//
//  ViewController.swift
//  PoseEstimation-CoreML
//
//  Created by GwakDoyoung on 05/07/2018.
//  Copyright © 2018 tucan9389. All rights reserved.
//

import UIKit
import Vision
import CoreMedia

class ViewController: UIViewController, VideoCaptureDelegate {
    
    public typealias BodyPoint = (point: CGPoint, confidence: Double)
    public typealias DetectObjectsCompletion = ([BodyPoint?]?, Error?) -> Void
    
    // MARK: - UI 프로퍼티
    @IBOutlet weak var videoPreview: UIView!
    @IBOutlet weak var poseView: PoseView!
    
    @IBOutlet weak var tryLabel: UILabel!
    

    
    private var tableData: [BodyPoint?] = []
    
    private var moveCalculate: movePoint = movePoint()
    private var scoreCal = 0

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
        
        //        self.title = "lsp chk 370000"
        
        // MobileNet 클래스는 `MobileNet.mlmodel`를 프로젝트에 넣고, 빌드시키면 자동으로 생성된 랩퍼 클래스
        // MobileNet에서 만든 model: MLModel 객체로 (Vision에서 사용할) VNCoreMLModel 객체를 생성
        // Vision은 모델의 입력 크기(이미지 크기)에 따라 자동으로 조정해 줌
        visionModel = try? VNCoreMLModel(for: EstimationModel().model)
        
        // 카메라 세팅
        setUpCamera()
        
        // 레이블 테이블 세팅
      
        
        // 레이블 점 세팅
        poseView.setUpOutputComponent()
        
        // 성능측정용 델리게이트 설정
//         👨‍🔧.delegate = self
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
            let scoreSquat: Int = self.moveCalculate.addKeypoints(keypoints: n_kpoints)
//            let scoreSquat: Int = self.moveCalculate.calSquat()

     
            
            DispatchQueue.main.sync {
             
                self.poseView.bodyPoints = n_kpoints
                if scoreSquat != 0{
                      self.tryLabel.text = "\(scoreSquat)"
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
    
    func squatCalculate(with n_kpoints: [BodyPoint?]) {
    
          self.tableData = n_kpoints
        
        //            tryLabel.text = "(\(pointText))"
        //              print(pointText)
        
//        if let body_point = tableData[0] {
//            let pointText: String = "\(String(format: "%.3f", body_point.point.y))"
//
//
//
//        }
//        if let body_point = tableData[6] {
//            let pointText2: String = "\(String(format: "%.3f", body_point.point.y))"
//
//
//        }
        
      
        
    
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







// #MARK: - 상수

struct Constant {
    static let pointLabels = [
        "top\t\t\t", //0
        "neck\t\t", //1
        
        "R shoulder\t", //2
        "R elbow\t\t", //3
        "R wrist\t\t", //4
        "L shoulder\t", //5
        "L elbow\t\t", //6
        "L wrist\t\t", //7
        
        "R hip\t\t", //8
        "R knee\t\t", //9
        "R ankle\t\t", //10
        "L hip\t\t", //11
        "L knee\t\t", //12
        "L ankle\t\t", //13
    ]
    
    static let connectingPointIndexs: [(Int, Int)] = [
        (0, 1), // top-neck
        
        (1, 2), // neck-rshoulder
        (2, 3), // rshoulder-relbow
        (3, 4), // relbow-rwrist
        (1, 8), // neck-rhip
        (8, 9), // rhip-rknee
        (9, 10), // rknee-rankle
        
        (1, 5), // neck-lshoulder
        (5, 6), // lshoulder-lelbow
        (6, 7), // lelbow-lwrist
        (1, 11), // neck-lhip
        (11, 12), // lhip-lknee
        (12, 13), // lknee-lankle
    ]
    static let jointLineColor: UIColor = UIColor(displayP3Red: 87.0/255.0,
                                                 green: 255.0/255.0,
                                                 blue: 211.0/255.0,
                                                 alpha: 0.5)
    
    static let colors: [UIColor] = [
        .red,
        .green,
        .blue,
        .cyan,
        .yellow,
        .magenta,
        .orange,
        .purple,
        .brown,
        .black,
        .darkGray,
        .lightGray,
        .white,
        .gray,
        ]
}

class  movePoint{
   
    typealias BodyPoint = ViewController.BodyPoint
    var score = 0
    var scoreCal = 0
    let countPoint: Int = 20
    var keypointsArray: [[BodyPoint?]] = []
    
    var timerr:Timer!
    var countdown:Int = 10
    
    func addKeypoints(keypoints: [BodyPoint?])-> Int {
        keypointsArray.append(keypoints)
        if keypointsArray.count > countPoint {
            keypointsArray.remove(at: 0)
          
            
        }
        
        return 0
        
    }
    
    func callExercise(idEx: Int) -> Int {
        
        var score: Int = 0
        if(idEx==1){
            score = calSquat()
        }else   if(idEx==2){
            score = calLunge()
        }else   if(idEx==3){
            score = calHightknee()
        }else   if(idEx==4){
            score = calLegraiseSide()
        }else   if(idEx==5){
            score = calLegraiseSide()
        }
        
        return score
    }
    

    
    func calPointX(_ mark: Int,_ point1: Int,_ point2: Int) -> CGFloat {
        let p1: CGFloat = (keypointsArray[point1][mark]?.point.x ?? 0)
        let p2: CGFloat = (keypointsArray[point2][mark]?.point.x ?? 0)
        let pointcal = CGFloat(p1-p2)
        return pointcal
    }
    func calPointY(_ mark: Int,_ point1: Int,_ point2: Int) -> CGFloat {
        let p1: CGFloat = (keypointsArray[point1][mark]?.point.y ?? 0)
        let p2: CGFloat = (keypointsArray[point2][mark]?.point.y ?? 0)
        let pointcal = CGFloat(p1-p2)
        return pointcal
    }
    
    func calSquat()-> Int{
        if keypointsArray.count > 18 {
                let headX = calPointX(1,8,18)
                let headY = calPointY(1,8,18)
                let shoulder = calPointY(5,8,18)
                let leg = calPointY(11,8,18)
                let foot = calPointX(13,8,18)

//          print("\(String(format: "%.3f",headX)), \(String(format: "%.3f",headY)), \(String(format: "%.3f",shoulder)), \(String(format: "%.3f",leg)), \(String(format: "%.3f",foot))")
        if (headY>0.120&&headY<0.220&&shoulder>0.120&&shoulder<0.220&&leg>0.00&&leg<0.120&&foot<=0&&headX>=0&&headX<=0.5){
        print("Yeahhhhhhhhhh")
            keypointsArray.removeAll()

        return 1
//            return 1
        }else {return 0}
            
        }
        
        return 0
    
    }
    

    
    func calLunge()-> Int{
        if keypointsArray.count > 18 {
            let headY = calPointY(1,1,18)
            let headX = calPointY(1,1,18)
            let RkneeY = calPointY(12,1,18)
            let LkneeY = calPointY(9,1,18)
            
            
            print("\(String(format: "%.3f",LkneeY)) , \(String(format: "%.3f",RkneeY))")
            if (headY < 0.60 && headY > -0.60
                && RkneeY < 0.00 && RkneeY > -0.100
                && LkneeY < -0.100 && LkneeY > -0.300
                && headX == 0 ){
                
                print("LLLL")
                keypointsArray.removeAll()
                
                return 1
          
            } else if (headY < 0.60 && headY > -0.60
                && LkneeY < 0.00 && LkneeY > -0.100
                && RkneeY < -0.100 && RkneeY > -0.300
                && headX == 0 ){
                
                print("RRR")
                keypointsArray.removeAll()
                
                return 1}else {return 0}
            
        }
        
        return 0
    }
    
    
    
    func calHightknee()-> Int{
        if keypointsArray.count > 5 {

            let headX = calPointY(1,1,5)
            let RkneeY = calPointY(12,1,5)
            let RfootY = calPointY(13,1,5)
            let LkneeY = calPointY(9,1,5)
            let LfootY = calPointY(10,1,5)
            
            print("\(String(format: "%.3f",headX)),\(String(format: "%.3f",RkneeY)),\(String(format: "%.3f",RfootY)),\(String(format: "%.3f",LkneeY)),\(String(format: "%.3f",LfootY))")
            if (LkneeY > 0 && LkneeY  < 0.200
                && LfootY > 0  && LfootY < 0.100
                && RkneeY > -0.060 && RkneeY < 0.060
                && RfootY > -0.060 && RfootY < 0.060
                && headX == 0){
                
                print("LLL")
                keypointsArray.removeAll()

                return 1
                //            return 1
            }
            else  if (RkneeY > 0 && RkneeY  < 0.200
                && RfootY > 0  && RfootY < 0.100
                && LkneeY > -0.060 && LkneeY < 0.060
                && LfootY  > -0.060 && LfootY < 0.060
                && headX == 0 ){
                print("RRR")
                keypointsArray.removeAll()

                return 1
                //            return 1
            }
            else {return 0}
            
        }
        
        return 0
    }
    
    func calLegraiseSide()-> Int{
        if keypointsArray.count > 15 {
            
//            let headX = calPointY(1,10,15)
            let LfootX = calPointX(13,10,15)
            let LfootY = calPointY(13,10,15)
            let RfootX = calPointX(10,10,15)
            let RfootY = calPointY(10,10,15)
            
            print("\(String(format: "%.3f",LfootX)),\(String(format: "%.3f",LfootY)),\(String(format: "%.3f",RfootX)),\(String(format: "%.3f",RfootY))")
            if (RfootX < -0.000 && RfootX > -0.250 && RfootY > -0.250 && RfootY < -0.040
                && LfootX  == 0 && LfootY  == 0
                ){

                print("RRRRR")
                keypointsArray.removeAll()

                return 1
                //            return 1
            }else  if (LfootX < -0.000 && LfootX > -0.250 && LfootY > -0.250 && LfootY < -0.040
               && RfootX  == 0 && RfootY  == 0
                ){
                
                print("LLLLLL")
                keypointsArray.removeAll()
                
                return 1
                //            return 1
            }else  {return 0}
        }
        
        return 0
    }
    
    func calLegSwing()-> Int{
        if keypointsArray.count > 15 {
            
            //            let headX = calPointY(1,10,15)
            let LfootX = calPointX(13,10,15)
            let LfootY = calPointY(13,10,15)
            let RfootX = calPointX(10,10,15)
            let RfootY = calPointY(10,10,15)
            
            print("\(String(format: "%.3f",LfootX)),\(String(format: "%.3f",LfootY)),\(String(format: "%.3f",RfootX)),\(String(format: "%.3f",RfootY))")
            if (RfootX < -0.150 && RfootX > -0.300
                && LfootX  == 0 && LfootY  == 0
                ){

                print("RRRRR")
                keypointsArray.removeAll()

                return 1
                //            return 1
            }else if (LfootX < -0.100 && LfootX > -0.250
//               && LfootY > 0.050 && LfootY < 0.150
                && RfootX  == 0 && RfootY  == 0
                ){
                
                print("LLLL")
                keypointsArray.removeAll()
                
                return 1
                //            return 1
            }else  {return 0}
        }
        
        return 0
    }
    
    

    

}

extension Double {
    static func changeTypePoint(p1: CGPoint) -> Double {
        let point1: Double = Double(p1.y);

        return point1;
    }

}

class  tryaaa: movePoint {

}


//
//  WorkoutNoARViewController.swift
//  bartrainer
//
//  Created by Methira Denthongchai on 31/3/2562 BE.
//  Copyright © 2562 Methira Denthongchai. All rights reserved.
//

import UIKit
import Vision
import CoreMedia
import Alamofire
import AlamofireImage
import CountdownView
import AVFoundation


class WorkoutNoARViewController: UIViewController {
    

    
    @IBOutlet weak var nameExercise: UILabel!
    @IBOutlet weak var gifExercise: UIImageView!
    
    @IBOutlet weak var exerciseName: UILabel!
    @IBOutlet weak var timer: UILabel!

    
    var timerr:Timer!
    var countdown:Int = 0
    var countdownExercise:Int = 0
    var timerExercise:Int = 0
    var repsExercise:Int = 0
    
    var index:Int = 0
    
    var id_ex:Int = 0
    var loadGIF:Int = 0
    
    //timer
    var spin = true
    var autohide = false
    var appearingAnimation = CountdownView.Animation.zoomIn
    var disappearingAnimation = CountdownView.Animation.zoomOut
    

    var scoreCal = 0
    var exerciseloop: Int = 0
    var calSum: Int = 0
    var calExercise: Int = 0
    
    var startExercise: Int = 0
    
    var scoreExercise:[Int] = []
    
    
    var selectedCategoryGroup: Category?
    var ExerciseList: [Exercise] = []
    var levelExercise: Level?
    
    var audioPlayer: AVAudioPlayer?
    var audioPlayerTrainer: AVAudioPlayer?
    


               
            
                override func viewDidLoad() {
                    
                    super.viewDidLoad()
            
                    
                    backgroundMusic.shared.audioPlayer?.pause()
                    startExercise = 3
                    
                    timerr = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(countdownStartAction), userInfo: nil, repeats: true)
                    
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: {
                        self.soundTrainer(nameSound: "readygo")
                    })

                    navigationItem.hidesBackButton = true
                    
                    //timer
                    CountdownView.shared.backgroundViewColor = UIColor.red.withAlphaComponent(0.3)
                    CountdownView.shared.spinnerStartColor = UIColor(red:1, green:0, blue:0, alpha:0.8).cgColor
                    CountdownView.shared.spinnerEndColor = UIColor(red:1, green:0, blue:0, alpha:0.8).cgColor
                    
                    
            
                    Alamofire.request("http://tssnp.com/ws_bartrainer/exercise_category.php?group_id=\(selectedCategoryGroup!.id)").responseData { response in
                        if let data = response.result.value {
                            
                            do {
                                let decoder = JSONDecoder()
                                
                                self.ExerciseList = try decoder.decode([Exercise].self, from: data)
                                print(self.ExerciseList)
                                
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
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: {
                        self.countdownExerciseStart()
                    })
                    
                    
                }
                
                override func viewDidDisappear(_ animated: Bool) {
                    audioPlayerTrainer?.stop()
                    self.audioPlayer?.stop()
                    
                    
                    
                }
                
                override func viewWillAppear(_ animated: Bool) {
                    do {
                        
                        if let fileURL = Bundle.main.path(forResource: "level1", ofType: "m4a") {
                            audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: fileURL))
                            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
                            try AVAudioSession.sharedInstance().setActive(true)
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
                                self.audioPlayer?.prepareToPlay()
                                self.audioPlayer?.play()
                                self.audioPlayer?.numberOfLoops = -1
                            })
                            
                        } else {
                            print("No file with specified name exists")
                        }
                    } catch let error {
                        print("Can't play the audio file failed with an error \(error.localizedDescription)")
                    }
                }
                
                func soundTrainer(nameSound:String)  {
                    do {
                        if let fileURL = Bundle.main.path(forResource: nameSound, ofType: "m4a") {
                            audioPlayerTrainer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: fileURL))
                            
                            audioPlayerTrainer?.setVolume(10, fadeDuration: 0)
                            audioPlayerTrainer?.play()
                            
                        } else {
                            print("No file with specified name exists")
                        }
                    } catch let error {
                        print("Can't play the audio file failed with an error \(error.localizedDescription)")
                    }
                    
                }
                @objc func countdownStartAction(){
                    if startExercise > 0{
                        startExercise -= 1
                    }
                    
                    
                    
                    if startExercise == 0 {
                        timerr.invalidate()
                        //            CountdownView.hide(animation: disappearingAnimation, options: (duration: 0.5, delay: 0.2), completion: nil)
                        
                    }else {
                        //            CountdownView.show(countdownFrom: Double(startExercise), spin: spin, animation: appearingAnimation, autoHide: autohide,
                        //                               completion: nil)
                        
                    }
                    
                    
                }
                @objc func countdownAction(){
                    countdown -= 1
                    
                    if countdown == 0 {
                        loadGIF = 0
                        timerr.invalidate()
                        timer.text = ""
                      
                        CountdownView.hide(animation: disappearingAnimation, options: (duration: 0.5, delay: 0.2), completion: nil)
                        //            self.videoCapture.stop()
                        
         
                        countdownExercise = Int((levelExercise?.timer)!) ?? 0
                        countdownExerciseStart()
                        
                    }else  {
                        CountdownView.show(countdownFrom: Double(countdown), spin: spin, animation: appearingAnimation, autoHide: autohide,
                                           completion: nil)
                        
                    }
                    
                    if countdown == 3{
                        soundTrainer(nameSound: "321")
                    }else   if countdown == 0{
                        soundTrainer(nameSound: "go")
                    }
                }
                func  countdownStart() {
                    timerr = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(countdownAction), userInfo: nil, repeats: true)
   
                }
                
                func countdownStop(){
                    timerr.invalidate()
                    countdown = Int((levelExercise?.rest)!) ?? 0
                    
                }
                @objc func countdownExerciseAction(){
                    countdownExercise -= 1
                    
                    if countdownExercise == 0 {
                        
                        timerr.invalidate()
                        print("nextlevel timer")
                        nextExercise()
                        timer.text = ""
                        
                        
                    }else {
                        timer.text = "\(countdownExercise)"
                    }
                    
                    
                    if countdownExercise == 1{
                        soundTrainer(nameSound: "rest")
                    }else if countdownExercise == 3{
                        soundTrainer(nameSound: "last")
                    }else if countdownExercise == 6{
                        soundTrainer(nameSound: "closer")
                    }else  if countdownExercise == 10{
                        soundTrainer(nameSound: "again")
                    }
                    
                }
                func  countdownExerciseStart() {
                    timerr = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(countdownExerciseAction), userInfo: nil, repeats: true)
                    
                }
                func nextExercise()  {
                    
                    if(exerciseloop<ExerciseList.count){
                        if( countdownExercise != 0 ){
                            timerr.invalidate()
                        }
                        if (countdown == 0){
                            countdown = Int((levelExercise?.rest)!) ?? 0
                        }
                        countdownStart()
                        countdownExercise = Int((levelExercise?.timer)!) ?? 0
                        
                        
                        calSum = calExercise*repsExercise
                        
                        print(scoreCal)
                        
                        exerciseWorkout(id_user: Int(User.currentUser!.id_user) ?? 0, id_exercise: id_ex, id_category: Int((selectedCategoryGroup?.id)!) ?? 0,category: selectedCategoryGroup?.name ?? "aa", level: Int((levelExercise?.level)!) ?? 0, reps: repsExercise,repsexercise: repsExercise, cal: calSum)
                        
                        scoreCal=0
                        exerciseloop+=1
                        
                        
                        
                    }
                    if(exerciseloop == ExerciseList.count){
                        
                        
                        if( countdown != 0 ){
                            countdownStop()
                        }
                        timerr.invalidate()
                        performSegue(withIdentifier: "WorkoutFinish", sender: self)

                    }
                }
                
                
                
                override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
                    if segue.identifier == "WorkoutFinish" {
                        let vc = segue.destination as! ExerciseFinishViewController
                        vc.selectedCategoryGroup = selectedCategoryGroup
                        
                    }
                }
            
            
            
            
            func exerciseWorkout( id_user: Int, id_exercise: Int,id_category: Int, category: String, level: Int, reps: Int,repsexercise: Int, cal: Int) {
                
                let param: Parameters = [
                    "id_user": id_user,
                    "id_exercise": id_exercise,
                    "id_category": id_category,
                    "category": category,
                    "level": level,
                    "reps": reps,
                    "repsexercise": repsexercise,
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
                        //                Alert.showAlert(vc: self, title: "Error", message: "กรุณาลองใหม่อีกครั้ง", action: nil)
                    }
                }
            }

}
            
            






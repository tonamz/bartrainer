//
//  WorkoutViewController.swift
//  bartrainer
//
//  Created by Methira Denthongchai on 12/2/2562 BE.
//  Copyright © 2562 Methira Denthongchai. All rights reserved.
//

import Alamofire
import UIKit

class WorkoutViewController: UIViewController {
    
    
    @IBOutlet weak var exerciseName: UILabel!
    @IBOutlet weak var timeText: UILabel!
    @IBOutlet weak var scoreText: UILabel!
    var selectedCategoryGroup: Category?
        var ExerciseList: [Exercise] = []
        private var moveCalculate: movePoint = movePoint()
        var scoreWorkout:[Int] = []
    
       var timerr:Timer!
        var countdown:Int = 30
    
         var scorePass: Int = 0
    
    @IBAction func addScore(_ sender: Any) {
    scorePass = scorePass + 1
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        Alamofire.request("http://tssnp.com/ws_bartrainer/exercise_category.php?group_id=\(selectedCategoryGroup!.id)").responseData { response in
            if let data = response.result.value {
                
                do {
                    let decoder = JSONDecoder()
                    
                    self.ExerciseList = try decoder.decode([Exercise].self, from: data)
                    print("\(self.ExerciseList.count)")
                    if self.ExerciseList.count == 5
                    {
                        var index = 0
                        while index < self.ExerciseList.count {
                            self.Workout(exercise: self.ExerciseList, atRow: index)
                        }
               
                    }

                } catch {
                    print(error.localizedDescription)
                }
            } else {
                print("error")
            }
        }
       

        

    }
    

    func Workout(exercise: [Exercise?], atRow: Int) -> Int {
   
            let  indexPath = IndexPath(row: atRow, section: 0)
            let model = ExerciseList[indexPath.row]
        
   

            DispatchQueue.main.sync{
                            self.exerciseName.text = "\(model.name)"
                           print("\(model.id_exercise)")
                
                
            }
        
        return 0

    
        
  
    }
    func findExercise(id_ex: String) -> Int {
        
        if id_ex == "1" {

     
        }
        
        return 0
        
    }
    
    @objc func countdownAction(){
        countdown -= 1
        if countdown == 0 {
            timerr.invalidate()
        }
        timeText.text = "\(countdown)"
    }
    func  countdownStart() {
        timerr = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(countdownAction), userInfo: nil, repeats: true)
    }
    
    func countdownStop(){
        timerr.invalidate()
        countdown = 10
        
    }
    
    
  
    

}

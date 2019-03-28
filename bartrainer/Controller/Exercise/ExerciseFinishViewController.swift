//
//  ExerciseFinishViewController.swift
//  bartrainer
//
//  Created by Methira Denthongchai on 22/2/2562 BE.
//  Copyright © 2562 Methira Denthongchai. All rights reserved.
//

import UIKit
import Alamofire

class ExerciseFinishViewController: UIViewController ,UITableViewDataSource, UITableViewDelegate{

    
    var selectedCategoryGroup: Category?
    var exerciseworkout: [ExerciseWorkout] = []
    var ExerciseList: [Exercise] = []
    @IBOutlet weak var calLabel: UILabel!
    
    var calSum: Int = 0
    


    @IBOutlet weak var comfirmBTN: UIButton!
    

    @IBOutlet weak var categoryName: UILabel!
         @IBOutlet weak var buttonOutlet: UIButton!
    
    @IBOutlet weak var exerciseFinishTableView: UITableView!

    override func viewDidLoad() {
    
        super.viewDidLoad()
                self.view.backgroundColor = UIColor(patternImage: UIImage(named: "bg.png")!)
        comfirmBTN.layer.cornerRadius = 10
   
//
//     backgroundMusic.shared.audioPlayer?.play()
        
        categoryName.text = selectedCategoryGroup?.name
             buttonOutlet.layer.cornerRadius = 10
        
        self.exerciseFinishTableView.dataSource = self
        self.exerciseFinishTableView.delegate = self

        Alamofire.request("http://tssnp.com/ws_bartrainer/exercise_workout_user.php?id_user=1").responseData { response in
            if let data = response.result.value {
                
                do {
                    let decoder = JSONDecoder()
                    
                    self.exerciseworkout = try decoder.decode([ExerciseWorkout].self, from: data)

                    Alamofire.request("http://tssnp.com/ws_bartrainer/exercise_category.php?group_id=\(self.selectedCategoryGroup!.id)").responseData { response in
                        if let data = response.result.value {
                            
                            do {
                                let decoder = JSONDecoder()
                                
                                self.ExerciseList = try decoder.decode([Exercise].self, from: data)
                                self.exerciseFinishTableView.reloadData()
                                
                            } catch {
                                print(error.localizedDescription)
                            }
                        } else {
                            print("error")
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
    
    override func viewDidDisappear(_ animated: Bool) {
        backgroundMusic.shared.audioPlayer?.pause()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ExerciseList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExerciseFinishTableViewCell", for: indexPath) as! ExerciseFinishTableViewCell
        let model = ExerciseList[indexPath.row]
        
         cell.exerciseLabel.text = model.name
            var i = 0
        while ( i < exerciseworkout.count ) {
            let indexPath = NSIndexPath(row: i, section: 0)
           let model2 = exerciseworkout[indexPath.row]
            if(model2.id_exercise == model.id_exercise){
                cell.repsLabel.text = model2.reps
                calSum += Int(model2.cal)!
                calLabel.text = "Cal : \(calSum)"
                cell.repsexLabel.text = "/ \(model2.repsexercise)"

            }

            i+=1
        }
        
          cell.isUserInteractionEnabled = false
        
        
        return cell
    }
    
    

}

//
//  ExerciseListViewController.swift
//  bartrainer
//
//  Created by Methira Denthongchai on 18/1/2562 BE.
//  Copyright © 2562 Methira Denthongchai. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import AVFoundation

class ExerciseListViewController: UIViewController,UITableViewDataSource, UITableViewDelegate{
  
    
     var audioPlayer: AVAudioPlayer?
    
    @IBOutlet weak var levelCountText: UILabel!
    @IBOutlet weak var levelText: UILabel!
    @IBOutlet weak var levelProgress: UIProgressView!
    
    
    @IBOutlet weak var exerciseListTableView: UITableView!
     @IBOutlet weak var buttonOutlet: UIButton!
    
    
    var selectedCategoryGroup: Category?
    var ExerciseList: [Exercise] = []
    var ExerciseLevel: [Level] = []
    var LevelCountList: [LevelCount] = []
    
//    var levelExercise: [Level] = []
      var levelExercise: Level?
    
    var leveldo: Double = 0
    var levelnext: Double = 0
    
    var i: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        
        print(User.currentUser?.id_user as Any)
        buttonOutlet.layer.cornerRadius = 10
        title = selectedCategoryGroup!.name
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "bg.png")!)
//        self.exercisListTableView.backgroundColor = UIColor(white: 1, alpha: 0)
        
        
        self.exerciseListTableView.dataSource = self
        self.exerciseListTableView.delegate = self
        
        Alamofire.request("http://tssnp.com/ws_bartrainer/exercise_category.php?group_id=\(selectedCategoryGroup!.id)").responseData { response in
            if let data = response.result.value {
                
                do {
                    let decoder = JSONDecoder()
                    
                    self.ExerciseList = try decoder.decode([Exercise].self, from: data)
                    self.exerciseListTableView.reloadData()
                    
                } catch {
                    print(error.localizedDescription)
                }
            } else {
                print("error")
            }
        }
        
        Alamofire.request("http://tssnp.com/ws_bartrainer/exercise_level.php").responseData { response in
            if let data = response.result.value {
                
                do {
                    let decoder = JSONDecoder()
                    
                    self.ExerciseLevel = try decoder.decode([Level].self, from: data)
            
                    
                    Alamofire.request("http://tssnp.com/ws_bartrainer/exercise_level_count.php?id_user=1&id_category=\(self.selectedCategoryGroup!.id)").responseData { response in
                        if let data = response.result.value {
                            
                            do {
                                let decoder = JSONDecoder()
                                
                                self.LevelCountList = try decoder.decode([LevelCount].self, from: data)
                                if(self.LevelCountList.count>0 && self.ExerciseLevel.count>0){
                                    self.levelExercise = self.findLevel()
                                }else{
                                    self.levelExercise = self.setLevelstart()
                                }
                                
                                
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
    
    func findLevel() -> Level{

        let indexPathh = NSIndexPath(row: 0, section: 0)
        let level_ex = LevelCountList[indexPathh.row]
        let ex_level =  ExerciseLevel[indexPathh.row]

            for i in 0..<ExerciseLevel.count {
                let indexPathh = NSIndexPath(row: i, section: 0)
                var ex_level =  ExerciseLevel[indexPathh.row]

                if(level_ex.level == ex_level.level){
                    if(level_ex.level_count < ex_level.next_level)
                    {
                        leveldo = Double(level_ex.level_count)!
                        levelnext = Double(ex_level.next_level)!
                        levelCountText.text = (" \(Int(leveldo) )/\(ex_level.next_level) ")
                        levelText.text = ("Level\(ex_level.level)")
                   

                        levelProgress.progress = Float(leveldo/levelnext)

                        return ex_level
                    }else{
                        ex_level =  ExerciseLevel[indexPathh.row+1]
                        levelCountText.text = ("0/\(ex_level.next_level) ")
                        levelText.text = ("Level\(ex_level.level)")

                        levelProgress.progress = 0
                        
                        return ex_level

                    }

                }

            }//for

            
            return ex_level


    }
    
    func setLevelstart() -> Level? {
        let indexPathh = NSIndexPath(row: 0, section: 0)
        let ex_level =  ExerciseLevel[indexPathh.row]
        levelText.text = ("Level1")
        levelCountText.text = ("0/\(ex_level.next_level) ")
        levelProgress.progress = 0
        
         return ex_level
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Workout" {
            let vc = segue.destination as! WorkoutsViewController
            vc.selectedCategoryGroup = selectedCategoryGroup
            vc.levelExercise = levelExercise
            
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ExerciseList.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExerciseListTableViewCell", for: indexPath) as! ExerciseListTableViewCell
        
        let model = ExerciseList[indexPath.row]
        
      
    
        if (model.id_exercise == "1" ){
               cell.iconImageView.image = UIImage(named: "ex01")
        }else  if (model.id_exercise == "2" ){
            cell.iconImageView.image = UIImage(named: "ex02")
        }else  if (model.id_exercise == "3" ){
            cell.iconImageView.image = UIImage(named: "ex03")
        }else  if (model.id_exercise == "4" ){
            cell.iconImageView.image = UIImage(named: "ex04")
        }else  if (model.id_exercise == "5" ){
            cell.iconImageView.image = UIImage(named: "ex05")
        }
        else{
             cell.iconImageView.image = UIImage(named: "ex02")
        }
//         cell.iconImageView.image = UIImage(named: "Arms")
        cell.exerciseLabel.text = model.name
        
          i+=1
        
        return cell
    }
    

}

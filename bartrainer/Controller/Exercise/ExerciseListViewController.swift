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

class ExerciseListViewController: UIViewController,UITableViewDataSource, UITableViewDelegate{
  
    

    
    @IBOutlet weak var exerciseListTableView: UITableView!
     @IBOutlet weak var buttonOutlet: UIButton!
    
    
    var selectedCategoryGroup: Category?
    var ExerciseList: [Exercise] = []
    var ExerciseLevel: [Level] = []
    var LevelCountList: [LevelCount] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
          print(User.currentUser?.id_user)
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
    
                    
                } catch {
                    print(error.localizedDescription)
                }
            } else {
                print("error")
            }
        }
        
        Alamofire.request("http://tssnp.com/ws_bartrainer/exercise_level_count.php?id_user=1").responseData { response in
            if let data = response.result.value {
                
                do {
                    let decoder = JSONDecoder()
                    
                      self.LevelCountList = try decoder.decode([LevelCount].self, from: data)
                    
                    
                } catch {
                    print(error.localizedDescription)
                }
            } else {
                print("error")
            }
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Workout" {
            let vc = segue.destination as! WorkoutsViewController
            vc.selectedCategoryGroup = selectedCategoryGroup
            
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ExerciseList.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExerciseListTableViewCell", for: indexPath) as! ExerciseListTableViewCell
        
        let model = ExerciseList[indexPath.row]
        cell.iconImageView.image = UIImage(named: "Arms")
        cell.exerciseLabel.text = model.name
        
        return cell
    }
    

}

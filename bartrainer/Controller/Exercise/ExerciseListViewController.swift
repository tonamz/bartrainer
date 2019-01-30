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
  
    

    
    @IBOutlet weak var exercisListTableView: UITableView!
    
    var selectedCategoryGroup: Category?
    var ExerciseList: [Exercise] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = selectedCategoryGroup!.name
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "bg.png")!)
//        self.exercisListTableView.backgroundColor = UIColor(white: 1, alpha: 0)
        
        
        self.exercisListTableView.dataSource = self
        self.exercisListTableView.delegate = self
        
        Alamofire.request("http://tssnp.com/ws_bartrainer/exercise_category.php?group_id=\(selectedCategoryGroup!.id)").responseData { response in
            if let data = response.result.value {
                
                do {
                    let decoder = JSONDecoder()
                    
                    self.ExerciseList = try decoder.decode([Exercise].self, from: data)
                    
                    
                    self.exercisListTableView.reloadData()
                    
                } catch {
                    print(error.localizedDescription)
                }
            } else {
                print("error")
            }
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
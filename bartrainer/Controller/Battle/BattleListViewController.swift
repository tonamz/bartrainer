//
//  BattleListViewController.swift
//  bartrainer
//
//  Created by Methira Denthongchai on 19/1/2562 BE.
//  Copyright © 2562 Methira Denthongchai. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class BattleListViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {


        @IBOutlet weak var exerciseCollection: UICollectionView!
        
        var ExerciseList: [Exercise] = []
        var selectedExercise: Exercise?
        
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            title = "Battle"
            self.view.backgroundColor = UIColor(patternImage: UIImage(named: "bg.png")!)
            self.exerciseCollection.backgroundColor = UIColor(white: 1, alpha: 0)
            
            
            
            self.exerciseCollection.dataSource = self
            self.exerciseCollection.delegate = self
            
            
            Alamofire.request("http://tssnp.com/ws_bartrainer/exercise.php").responseData { response in
                if let data = response.result.value {
                    
                    do {
                        let decoder = JSONDecoder()
                        
                        self.ExerciseList = try decoder.decode([Exercise].self, from: data)
                        
                        self.exerciseCollection.reloadData()
                        
                    } catch {
                        print(error.localizedDescription)
                    }
                } else {
                    print("error")
                }
            }
            
        }
    
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "toBattle" {
                let vc = segue.destination as! BattleExerciseViewController
                vc.selectedExercise = selectedExercise
                
            }
        }
        

        
         func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return ExerciseList.count
        }
        
         func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "exercise_collection", for: indexPath) as! BattleListCollectionViewCell
            let model = ExerciseList[indexPath.row]
            cell.headerLabel.text = model.name
            if (Int(model.id_exercise) ?? 0 < 6 ){
                cell.iconImageView.image = UIImage(named: "ex0\(model.id_exercise)")
            }else{
                cell.iconImageView.image = UIImage(named: "ex02")
            }
            
            return cell
        }
    
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            selectedExercise = ExerciseList[indexPath.row]
            performSegue(withIdentifier: "toBattle", sender: self)
            
            
        }


}

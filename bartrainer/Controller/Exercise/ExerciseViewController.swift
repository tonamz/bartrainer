//
//  ExerciseViewController.swift
//  bartrainer
//
//  Created by Methira Denthongchai on 16/12/2561 BE.
//  Copyright © 2561 Methira Denthongchai. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class ExerciseViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    

    @IBOutlet weak var exerciseCollection: UICollectionView!
        var images = ["Arms","Legs","Abs","Butt"]
    
    @IBOutlet var gifImage: UIImageView!
    
    var categoryGroup: [Category] = []
    var selectedCategoryGroup: Category?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "bg.png")!)
        self.exerciseCollection.backgroundColor = UIColor(white: 1, alpha: 0)
        self.gifImage.loadGif(name: "hightkneeGIF")
        
        self.exerciseCollection.dataSource = self
        self.exerciseCollection.delegate = self
        
        Alamofire.request("http://tssnp.com/ws_bartrainer/category.php").responseData { response in
            if let data = response.result.value {
                
                do {
                    let decoder = JSONDecoder()
                    
                    self.categoryGroup = try decoder.decode([Category].self, from: data)
                    
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
        if segue.identifier == "ExList" {
            let vc = segue.destination as! ExerciseListViewController
            vc.selectedCategoryGroup = selectedCategoryGroup
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoryGroup.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "exercise_collection", for: indexPath) as! ExerciseCollectionViewCell
            let model = categoryGroup[indexPath.row]
        cell.iconImageView.image = UIImage(named: model.name)
          cell.headerLabel.text = model.name
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedCategoryGroup = categoryGroup[indexPath.row]
        performSegue(withIdentifier: "ExList", sender: self)
        
        
    }
    
    
    


}

//
//  ChallengeViewController.swift
//  bartrainer
//
//  Created by Methira Denthongchai on 30/1/2562 BE.
//  Copyright © 2562 Methira Denthongchai. All rights reserved.
//

import UIKit
import Alamofire

class ChallengeViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var challengeCollection: UICollectionView!
    
    var challengeGroup: [ChallengeName] = []
    var selectedChallengeGroup: ChallengeName?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "bg.png")!)
    self.challengeCollection.backgroundColor = UIColor(white: 1, alpha: 0)
        
        self.challengeCollection.dataSource = self
        self.challengeCollection.delegate = self
        
        Alamofire.request("http://tssnp.com/ws_bartrainer/challenge_name.php").responseData { response in
            if let data = response.result.value {
                
                do {
                    let decoder = JSONDecoder()
                    
                    self.challengeGroup = try decoder.decode([ChallengeName].self, from: data)
                    
                    self.challengeCollection.reloadData()
                    
                } catch {
                    print(error.localizedDescription)
                }
            } else {
                print("error")
            }
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Challenge_day" {
            let vc = segue.destination as! ChallengeDayViewController
            vc.selectedChallengeGroup = selectedChallengeGroup
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return challengeGroup.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "challenge_collection", for: indexPath) as! ChallengeCollectionViewCell
        let model = challengeGroup[indexPath.row]
        cell.headerLabel.text = model.name
        if model.id_exercise == "1" {
            cell.iconImageView.image = UIImage(named: "ex\(model.id_exercise)")
            
        }else  if model.id_exercise == "2" {
            cell.iconImageView.image = UIImage(named: "ex\(model.id_exercise)")
            
        }else{
              cell.iconImageView.image = UIImage(named: "ex19")
        }
      
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedChallengeGroup = challengeGroup[indexPath.row]
        performSegue(withIdentifier: "Challenge_day", sender: self)
        
        
    }

}


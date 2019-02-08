//
//  ChallengeDaylViewController.swift
//  bartrainer
//
//  Created by Methira Denthongchai on 30/1/2562 BE.
//  Copyright © 2562 Methira Denthongchai. All rights reserved.
//

import UIKit
import Alamofire

class ChallengeDayViewController: UIViewController , UICollectionViewDataSource, UICollectionViewDelegate{
   
    @IBOutlet weak var challengeDayCollection: UICollectionView!
    
    var challengeGroup: [Challenge] = []
    var selectedChallengeGroup: ChallengeName?
    var selectedChallenge: Challenge?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "bg.png")!)
        
        self.challengeDayCollection.dataSource = self
        self.challengeDayCollection.delegate = self
        
        Alamofire.request("http://tssnp.com/ws_bartrainer/challenge_day.php?id_ex=\(selectedChallengeGroup!.id_exercise)").responseData { response in
            if let data = response.result.value {
                
                do {
                    let decoder = JSONDecoder()
                    
                    self.challengeGroup = try decoder.decode([Challenge].self, from: data)
                    
                    self.challengeDayCollection.reloadData()
                    
                } catch {
                    print(error.localizedDescription)
                }
            } else {
                print("error")
            }
        }
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Challenge_detail" {
            let vc = segue.destination as! ChallengeDetailViewController
            vc.selectedChallengeGroup = selectedChallengeGroup
            vc.selectedChallenge = selectedChallenge
            
        }
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return challengeGroup.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "challenge_day_collection", for: indexPath) as! ChallengeDayCollectionViewCell
        let model = challengeGroup[indexPath.row]
        cell.headerLabel.text = model.day
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedChallenge = challengeGroup[indexPath.row]
        performSegue(withIdentifier: "Challenge_detail", sender: self)
        
        
    }

}
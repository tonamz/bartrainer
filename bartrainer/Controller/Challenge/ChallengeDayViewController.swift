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
    var challengeCount: [ChallengeCount] = []
    var selectedChallengeGroup: ChallengeName?
    var selectedChallenge: Challenge?
    


    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "bg.png")!)
        
        self.challengeDayCollection.dataSource = self
        self.challengeDayCollection.delegate = self
        

        
        Alamofire.request("http://tssnp.com/ws_bartrainer/challenge_day_count.php?id_challenge=\(selectedChallengeGroup!.id)&&id_user=1").responseData { response in
            if let data = response.result.value {
                
                do {
                    
                    
                    
                    let decoder = JSONDecoder()
                    
                    self.challengeCount = try decoder.decode([ChallengeCount].self, from: data)
                    
                    
                    Alamofire.request("http://tssnp.com/ws_bartrainer/challenge_day.php?id_ex=\(self.selectedChallengeGroup!.id_exercise)").responseData { response in
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
        cell.dayLabel.text = model.day
        
//        var clCount: Int = challengeCount.count
       
        if indexPath.row < challengeCount.count{
            
            let model2 = challengeGroup[indexPath.row]
            if model.day == model2.day{
                cell.bgView.backgroundColor = UIColor(red:0.99, green:0.50, blue:0.25, alpha:1.0)
                cell.dayLabel.textColor = UIColor.white
            }
            
        }else if (indexPath.row > challengeCount.count){
            cell.isUserInteractionEnabled = false
            cell.bgView.layer.borderColor = UIColor.gray.withAlphaComponent(0.20).cgColor
            cell.dayLabel.textColor = UIColor.gray.withAlphaComponent(0.20)
            
        
        }
        
  
        
//        for i in 0...challengeCount.count{
//
//            let indexPath2 = NSIndexPath(row: 1, section: 0)
//            print(challengeCount[indexPath2.row])
////            print(challengeCount[indexPath.row])
//        }
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedChallenge = challengeGroup[indexPath.row]
        performSegue(withIdentifier: "Challenge_detail", sender: self)
        
        
    }

}

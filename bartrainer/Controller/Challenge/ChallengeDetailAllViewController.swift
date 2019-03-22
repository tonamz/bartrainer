//
//  ChallengeDetailAllViewController.swift
//  bartrainer
//
//  Created by Methira Denthongchai on 22/3/2562 BE.
//  Copyright © 2562 Methira Denthongchai. All rights reserved.
//

import UIKit
import Alamofire

class ChallengeDetailAllViewController: UIViewController,UITableViewDataSource, UITableViewDelegate {
 
    
    @IBOutlet weak var challengeDetailAllTableView: UITableView!
    
    @IBOutlet weak var headLabel: UILabel!

    
    var challengeGroup: [Challenge] = []
    var challengeCount: [ChallengeCount] = []
    var selectedChallengeGroup: ChallengeName?
    var selectedChallenge: Challenge?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "bg.png")!)

        self.challengeDetailAllTableView.dataSource = self
        self.challengeDetailAllTableView.delegate = self
        
        let clName: String = selectedChallengeGroup?.name ?? "aa"
        headLabel.text = "\(clName)"
        
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
                                
                                self.challengeDetailAllTableView.reloadData()
                                
                                
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
    
    
    
  

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return challengeGroup.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChallengeDetailAllTableViewCell", for: indexPath) as! ChallengeDetailAllTableViewCell
        let model = challengeGroup[indexPath.row]
        cell.dayLabel.text = model.day
        if (model.reps != "0"){
             cell.DetailLabel.text = "\(model.reps) reps"
        }else{
             cell.DetailLabel.text = "Rest"
        }
       
     
        
        return cell
        
    }

}

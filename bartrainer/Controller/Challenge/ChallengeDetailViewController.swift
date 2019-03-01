//
//  ChallengeDetailViewController.swift
//  bartrainer
//
//  Created by Methira Denthongchai on 9/2/2562 BE.
//  Copyright © 2562 Methira Denthongchai. All rights reserved.
//

import UIKit
import Alamofire

class ChallengeDetailViewController: UIViewController {

    @IBOutlet weak var ChallengeName: UILabel!
    @IBOutlet weak var ChallengeDay: UILabel!
    @IBOutlet weak var ChallengeRep: UILabel!
    @IBOutlet weak var detailView: UIView!
    var challengeGroup: [Challenge] = []
    var selectedChallengeGroup: ChallengeName?
    var selectedChallenge: Challenge?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "bg.png")!)
        detailView.layer.cornerRadius = 100
        
        Alamofire.request("http://tssnp.com/ws_bartrainer/challenge_detail.php?id_challenge=\(selectedChallenge!.id)").responseData { response in
            if let data = response.result.value {
                
                do {
                    let decoder = JSONDecoder()
                    
                    self.challengeGroup = try decoder.decode([Challenge].self, from: data)
                    
                } catch {
                    print(error.localizedDescription)
                }
            } else {
                print("error")
            }
        }
        
        ChallengeName.text = selectedChallengeGroup?.name
        ChallengeDay.text = selectedChallenge?.day
        ChallengeRep.text = "Reps : \(selectedChallenge?.reps ?? "aa" )"
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Challenge_workout" {
            let vc = segue.destination as! ChallengeWorkoutViewController
            vc.selectedChallengeGroup = selectedChallengeGroup
            vc.selectedChallenge = selectedChallenge
            
        }
    }
    


}

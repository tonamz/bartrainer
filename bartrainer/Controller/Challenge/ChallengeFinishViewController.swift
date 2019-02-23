//
//  ChallengeFinishViewController.swift
//  bartrainer
//
//  Created by Methira Denthongchai on 21/2/2562 BE.
//  Copyright © 2562 Methira Denthongchai. All rights reserved.
//

import UIKit
import Alamofire

class ChallengeFinishViewController: UIViewController {

 
    @IBOutlet weak var ChallengeName: UILabel!
    @IBOutlet weak var ChallengeDay: UILabel!
    @IBOutlet weak var ChallengeRep: UILabel!
    @IBOutlet weak var ChallengeFinish: UILabel!
     @IBOutlet weak var completeLabel: UILabel!
    @IBOutlet weak var detailView: UIView!
    var challengeGroup: [Challenge] = []
    var selectedChallengeGroup: ChallengeName?
    var selectedChallenge: Challenge?
    
    var scoreCal = 0
    var reps: Int = 0
    
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
        
        reps = Int(selectedChallenge!.reps) ?? 1
        
        ChallengeName.text = selectedChallengeGroup?.name
        ChallengeDay.text = "Day \(selectedChallenge?.day ?? "aa")"
        ChallengeRep.text = "\(scoreCal) / \(selectedChallenge?.reps ?? "aa")"
        
        if(scoreCal < reps){
            completeLabel.text = "Try Again"
        }else{
             completeLabel.text = "Complete"
        }
        
    }
    

    
    @IBAction func confirmButton(_ sender: Any) {
            let vc = UIStoryboard(name: "ChallengeDay", bundle: nil).instantiateViewController(withIdentifier: "ChallengeDay")
            UIApplication.shared.keyWindow?.rootViewController = vc
        
     
    }
    
}

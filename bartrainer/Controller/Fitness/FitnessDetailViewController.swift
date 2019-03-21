//
//  FitnessDetailViewController.swift
//  bartrainer
//
//  Created by Methira Denthongchai on 25/1/2562 BE.
//  Copyright © 2562 Methira Denthongchai. All rights reserved.
//

import UIKit
import Alamofire

class FitnessDetailViewController: UIViewController {
    

    @IBOutlet weak var fitnessLabel: UILabel!
    @IBOutlet weak var branchLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var fitnessImageView: UIImageView!
     @IBOutlet weak var getcodeBT: UIButton!
    @IBOutlet weak var regisfitnessBT: UIButton!
    
    
    var selectedfitness: Fitness?
    var FitnessDetail: [Fitness] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
              getcodeBT.layer.cornerRadius = 10
        regisfitnessBT.layer.cornerRadius = 10

        title = selectedfitness!.name_brand
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "bg.png")!)
        //        self.exercisListTableView.backgroundColor = UIColor(white: 1, alpha: 0)
        

        Alamofire.request("http://tssnp.com/ws_bartrainer/fitness.php").responseData { response in
            if let data = response.result.value {
                
                do {
                    let decoder = JSONDecoder()
                    
                    self.FitnessDetail = try decoder.decode([Fitness].self, from: data)
                    
                    
                } catch {
                    print(error.localizedDescription)
                }
            } else {
                print("error")
            }
        }
        
        
        fitnessLabel.text = selectedfitness!.name_brand
        branchLabel.text = selectedfitness!.name_branch
        detailLabel.text = selectedfitness!.detail
        
        

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "fitnessCode"  {
            let vc = segue.destination as! FitnessGetCodeViewController
            vc.fitnessName = selectedfitness!.name_brand
            vc.fitnessBranch = selectedfitness!.name_branch
        

        }else if segue.identifier == "fitnessRegis" {
            let vc2 = segue.destination as! FitnessRegisterViewController
            vc2.fitnessName = selectedfitness!.name_brand
            vc2.fitnessBranch = selectedfitness!.name_branch
            vc2.fitnessid = selectedfitness!.id_fitness
            
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

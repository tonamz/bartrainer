//
//  BattleFinishViewController.swift
//  bartrainer
//
//  Created by Methira Denthongchai on 23/1/2562 BE.
//  Copyright © 2562 Methira Denthongchai. All rights reserved.
//

import UIKit

class BattleFinishViewController: UIViewController {
    @IBAction func confirmBTAction(_ sender: Any) {
//        self.dismiss(animated: false, completion: {});
//        self.navigationController?.popViewController(animated: false);

    }
    
    var scoreCal = 0

    @IBOutlet weak var confirmBT: UIButton!
    @IBOutlet weak var scoreText: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "bg.png")!)
        scoreText.layer.cornerRadius = 100
        scoreText.text = "\(scoreCal)"
        confirmBT.layer.cornerRadius = 10
        self.tabBarController?.tabBar.isHidden = false
        
        
        
        
        

        print(scoreCal)
        // Do any additional setup after loading the view.
    }
    

}

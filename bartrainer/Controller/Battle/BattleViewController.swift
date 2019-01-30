//
//  BattleViewController.swift
//  bartrainer
//
//  Created by Methira Denthongchai on 19/1/2562 BE.
//  Copyright © 2562 Methira Denthongchai. All rights reserved.
//

import UIKit

class BattleViewController: UIViewController {
    
    
    @IBAction func startBattleBT(_ sender: Any) {
    }
    @IBOutlet weak var buttonOutlet: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "bg.png")!)
        buttonOutlet.layer.cornerRadius = 10
        
  
        

   
    }
    

}

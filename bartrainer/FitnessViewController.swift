//
//  FitnessViewController.swift
//  bartrainer
//
//  Created by Methira Denthongchai on 16/12/2561 BE.
//  Copyright © 2561 Methira Denthongchai. All rights reserved.
//

import UIKit


class FitnessViewController: UIViewController {

    @IBOutlet weak var randomCode: UILabel!
    
    
    @IBAction func getCoupon(_ sender: UIButton) {
        let code = randomString(length: 5)
        randomCode.text = code
        
        
    }
    func randomString(length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0...length-1).map{ _ in letters.randomElement()! })
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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

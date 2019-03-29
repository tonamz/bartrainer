//
//  FitnessViewController.swift
//  bartrainer
//
//  Created by Methira Denthongchai on 16/12/2561 BE.
//  Copyright © 2561 Methira Denthongchai. All rights reserved.
//

import Mailgun_In_Swift
import UIKit



class FitnessGetCodeViewController: UIViewController {
    
    var fitnessName: String = ""
    var fitnessBranch: String = ""
    var code: String = ""
    @IBOutlet weak var getcodeBTN: UIButton!
    
    @IBOutlet weak var randomCode: UILabel!
    
    var selectedfitness: Fitness?
    var selectedcoupon: Coupon?
    
    
    @IBAction func getCoupon(_ sender: UIButton) {
        code = randomString(length: 5)
        randomCode.text = code
        sendEmail()
 
        }
        
    
    func randomString(length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0...length-1).map{ _ in letters.randomElement()! })
    }
    
    func sendEmail(){
        let mailgun = MailgunAPI(apiKey: "efcafbfeee1abb8d0b2427afeea0c515-2d27312c-5fad6eff", clientDomain: "tssnp.com")
        
        mailgun.sendEmail(to: "denthongchai_m@silpakorn.edu",
                          from: "Bartrainer <postmaster@tssnp.com>",
                          subject: "\(fitnessName) at \(fitnessBranch)",
        bodyHTML: "<b>\(fitnessName) at \(fitnessBranch)<b><br><b>You have customer redeem coupon<b><br><b>Code is : \(code) <b> ") { mailgunResult in
            
            if mailgunResult.success{
                print("Email was sent")
            }
            
        }
    }


    
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
               getcodeBTN.layer.cornerRadius = 10
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "bg-code.png")!)
        print("aaaaaaaa:\(fitnessBranch)")

        // Do any additional setup after loading the view.
    }




}

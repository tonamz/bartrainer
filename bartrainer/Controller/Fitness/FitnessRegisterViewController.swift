//
//  FitnessRegisterViewController.swift
//  bartrainer
//
//  Created by Methira Denthongchai on 23/2/2562 BE.
//  Copyright © 2562 Methira Denthongchai. All rights reserved.
//


import UIKit
import Alamofire
import Mailgun_In_Swift

class FitnessRegisterViewController: UIViewController {
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var telephoneField: UITextField!
    var fitnessName: String = ""
    var fitnessBranch: String = ""
    var fitnessid: String = ""
    
    var id_fitness: Int = 0
    
    @IBOutlet weak var registerHead: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        id_fitness = Int((fitnessid)) ?? 5
        registerHead.text = "Register at \(fitnessName) \(fitnessBranch) "
        // Do any additional setup after loading the view.
    }
    
    @IBAction func FitnessRegisterButton(_ sender: Any) {
        
        if  ( nameField != nil && emailField != nil && telephoneField != nil){
            sendFitnessRegister(id_fitness: id_fitness,id_user: 1 ,name: nameField.text!, email: emailField.text!, telephone: telephoneField.text!)
//            sendEmailRegister()
//            Alert.showAlert(vc: self, title: "Complete", message: "สมัครเรียบร้อยแล้วค่ะ", action: nil)
//            performSegue(withIdentifier: "fitnessRegisFinish", sender: self)
            
            
        }else{
            Alert.showAlert(vc: self, title: "Error", message: "กรุณากรอกข้อมูลให้ครบถ้วน", action: nil)
        }
        
    }
    
    func sendFitnessRegister(id_fitness: Int,id_user: Int , name: String, email: String, telephone: String) {
        
        let param: Parameters = ["id_fitness": id_fitness,
                                 "id_user": id_user,
                                "name": name,
                                 "email": email,
                                 "telephone": telephone
        ]
        
        Alamofire.request("http://tssnp.com/ws_bartrainer/register_fitness.php", method: .post, parameters: param, encoding: URLEncoding.default, headers: nil).responseData { response in
            if let data = response.result.value {
                let decoder = JSONDecoder()
                
                do {
                    let result = try decoder.decode(APIresponse.self, from: data)
                    
                    print(result)
                    
                    if result.message == "success" {
                        Alert.showAlert(vc: self, title: "ลงทะเบียนสำเร็จ", message: nil, action: {
                            //                            self.navigationController?.popViewController(animated: true)
                        })
                    } else {
                        if result.error == "23000" {
                            Alert.showAlert(vc: self, title: "Error", message: "email หรือ รหัสบัตรประชนมีในระบบแล้ว", action: nil)
                        } else {
                            Alert.showAlert(vc: self, title: "Error", message: "server ผิดพลาด", action: nil)
                        }
                    }
                    
                } catch {
                    Alert.showAlert(vc: self, title: "Error", message: error.localizedDescription, action: nil)
                }
            } else {
                Alert.showAlert(vc: self, title: "Error", message: "กรุณาลองใหม่อีกครั้ง", action: nil)
            }
        }
    }
    
    func sendEmailRegister(){
        let mailgun = MailgunAPI(apiKey: "efcafbfeee1abb8d0b2427afeea0c515-2d27312c-5fad6eff", clientDomain: "tssnp.com")
        
        mailgun.sendEmail(to: "denthongchai_m@silpakorn.edu",
                          from: "Bartrainer <postmaster@tssnp.com>",
                          subject: "Register at \(fitnessName) at \(fitnessBranch)",
        bodyHTML: "<b>\(fitnessName) at \(fitnessBranch)<b><br><b>You have customer register<b><br><br><br><b>Name : \(nameField.text!) <b><br><b>Email : \(emailField.text!) <b><br><b>Telephone : \(telephoneField.text!) <b><br><br><br> <b> Thankyou from Bartrainer</b> ") { mailgunResult in
            
            if mailgunResult.success{
                print("Email was sent")
            }
            
        }
    }
}

//
//  RegisterViewController.swift
//  bartrainer
//
//  Created by Methira Denthongchai on 17/2/2562 BE.
//  Copyright © 2562 Methira Denthongchai. All rights reserved.
//

import UIKit
import Alamofire

class RegisterViewController: UIViewController {

    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var passwordconfirmField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func registerButton(_ sender: Any) {
        
        sendRegister(username: usernameField.text!, password: passwordField.text!, email: emailField.text!)
    }
    
    func sendRegister(username: String, password: String, email: String) {
        
        let param: Parameters = ["username": username,
                                 "password": password,
                                 "email": email
                                ]
        
        Alamofire.request("http://tssnp.com/ws_bartrainer/register.php", method: .post, parameters: param, encoding: URLEncoding.default, headers: nil).responseData { response in
            if let data = response.result.value {
                let decoder = JSONDecoder()
                
                do {
//                    let result = try decoder.decode(APIResponse.self, from: data)
//                    
//                    print(result)
//                    
//                    if result.message == "success" {
////                        Alert.showAlert(vc: self, title: "ลงทะเบียนสำเร็จ", message: nil, action: {
////                            self.navigationController?.popViewController(animated: true)
////                        })
//                    } else {
//                        if result.error == "23000" {
////                            Alert.showAlert(vc: self, title: "Error", message: "email หรือ รหัสบัตรประชนมีในระบบแล้ว", action: nil)
//                        } else {
////                            Alert.showAlert(vc: self, title: "Error", message: "server ผิดพลาด", action: nil)
//                        }
//                    }
                    
                } catch {
//                    Alert.showAlert(vc: self, title: "Error", message: error.localizedDescription, action: nil)
                }
            } else {
//                Alert.showAlert(vc: self, title: "Error", message: "กรุณาลองใหม่อีกครั้ง", action: nil)
            }
        }
    }
}

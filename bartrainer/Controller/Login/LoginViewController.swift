//
//  LoginViewController.swift
//  bartrainer
//
//  Created by Methira Denthongchai on 18/2/2562 BE.
//  Copyright © 2562 Methira Denthongchai. All rights reserved.
//

import UIKit
import Alamofire

class LoginViewController: UIViewController {

    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        do {
            try User.load()
            if User.currentUser != nil {
                print(User.currentUser?.id_user)
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Main")
                UIApplication.shared.keyWindow?.rootViewController = vc
            }
        } catch {
            print(error)
        }
    }
    
    @IBAction func loginButton(_ sender: Any) {
        if usernameField.text == "" {
            Alert.showAlert(vc: self, title: "กรุณากรอก", message: nil, action: nil)
            return
        }
        
        if passwordField.text == "" {
            Alert.showAlert(vc: self, title: "กรุณากรอก", message: nil, action: nil)
            return
        }
        
    
        login(username: usernameField.text!, password: passwordField.text!)
    }
    
    func login(username: String, password: String) {
        let param: Parameters = ["username": username,
                                 "password": password]
        
        Alamofire.request("http://tssnp.com/ws_bartrainer/login.php", method: .post, parameters: param, encoding: URLEncoding.default, headers: nil).responseData { response in
            if let data = response.result.value {
                let decoder = JSONDecoder()
                
                do {
                    let user = try decoder.decode([User].self, from: data).first
                    
                    if let user = user {
                        User.currentUser = user
                           print("loginn") 
                        try User.save()
                        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Main")
                        UIApplication.shared.keyWindow?.rootViewController = vc
                       
                    } else {
                        Alert.showAlert(vc: self, title: "Error", message: "username หรือ รหัสผ่านไม่ถูกต้อง", action: nil)
                    }
                } catch {
                    Alert.showAlert(vc: self, title: "Error", message: error.localizedDescription, action: nil)
                    print("hahaha")
                }
            } else {
                Alert.showAlert(vc: self, title: "Error", message: "กรุณาลองใหม่อีกครั้ง", action: nil)
            }
        }
    }
    
    @IBAction func loginWithFacebook(_ sender: Any) {
    }
    

}

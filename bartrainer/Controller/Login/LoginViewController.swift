//
//  LoginViewController.swift
//  bartrainer
//
//  Created by Methira Denthongchai on 24/1/2562 BE.
//  Copyright © 2562 Methira Denthongchai. All rights reserved.
//

import UIKit

import FacebookLogin
import FBSDKLoginKit
import Alamofire

class LoginViewController: UIViewController , FBSDKLoginButtonDelegate{
    
//
//    let loginButton: FBSDKLoginButton = {
//        let button = FBSDKLoginButton()
//        button.readPermissions = ["email"]
//        return button
//    }()
    
        var dict : [String : AnyObject]!
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            //creating button
            let loginButton = LoginButton(readPermissions: [ .publicProfile , .email, .userFriends])
            
            //adding it to view
              view.addSubview(loginButton)
            loginButton.center = view.center
            loginButton.delegate = self as? LoginButtonDelegate
            

            //if the user is already logged in
            
            
//            if FBSDKAccessToken.current() != nil{
//                getFBUserData()
//                toRootview()
//
//
//            }
            
         
        
        }

    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        print("complete login")
        getFBUserData()
        toRootview()
      
    }
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        toRootview()
    }
    func loginButtonWillLogin(_ loginButton: FBSDKLoginButton!) -> Bool {
        toRootview()
        return true
    }
    
    
        //when login button clicked
//    @objc func loginButtonClicked() {
//        let loginManager = LoginManager()
//
//        loginManager.logIn(readPermissions: [.publicProfile, .email], viewController : self) { loginResult in
//            switch loginResult {
//            case .failed(let error):
//                print(error)
//            case .cancelled:
//                print("User cancelled login")
//            case .success(let grantedPermissions, let declinedPermissions, let accessToken):
//              self.getFBUserData()
//
//
//
//
//            }
//        }
//    }
    
        
        //function is fetching the user data
        func getFBUserData(){
            if((FBSDKAccessToken.current()) != nil){
                FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
                    if (error == nil){
                        self.dict = result as? [String : AnyObject]
                        self.loginWithfacebook(result: result! as AnyObject)
                        print("aaaaaaaaaaa")
//                        print(result!)
//                        print(self.dict)
                        
//                        if let email = (result as AnyObject)["email"]! as? String{
//                            print("emaillll:\(email)")
//                                                }

                    }
                })
            }
        }
//
    func toRootview() {
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let homeController =  mainStoryboard.instantiateViewController(withIdentifier: "tabbar") as! UITabBarController
        appDelegate?.window?.rootViewController = homeController
    }
    func loginWithfacebook(result: AnyObject){
        let email = (result as AnyObject)["email"]! as? String
        let id = (result as AnyObject)["id"]! as? String
        let name = (result as AnyObject)["name"]! as? String
        let picture = (result as AnyObject)["picture"]! as? NSDictionary, data = picture?["data"] as? NSDictionary, url = data?["url"] as? String
        
        print("\(String(describing: email)),\(String(describing: id)),\(String(describing: name)),\(String(describing: picture))")
        
//        let param: Parameters = ["email": email,
//                                 "id": id,
//                                 "name": name,
//                                 "picture": picture
//                            ]
//  

        }
    
        
   
        
    }


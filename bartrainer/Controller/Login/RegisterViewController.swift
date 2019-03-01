//
//  RegisterViewController.swift
//  bartrainer
//
//  Created by Methira Denthongchai on 17/2/2562 BE.
//  Copyright © 2562 Methira Denthongchai. All rights reserved.
//

import UIKit
import Alamofire

class RegisterViewController: UIViewController ,UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var passwordconfirmField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    
       let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        
        profileImage.layer.cornerRadius = 59
        profileImage.layer.borderWidth = 2
        profileImage.layer.borderColor = #colorLiteral(red: 1, green: 0.7843137255, blue: 0.4431372549, alpha: 1)


    }
    
    @IBAction func profileimageButton(_ sender: Any){
        let actionSheet = UIAlertController(title: "กรุณาเลือกรูป", message: nil, preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "กล้อง", style: .default) { _ in
            self.imagePicker.sourceType = .camera
            self.imagePicker.allowsEditing = true
            
            self.present(self.imagePicker, animated: true, completion: nil)
        }
        let photoLibraryAction = UIAlertAction(title: "คลังภาพ", style: .default) { _ in
            self.imagePicker.sourceType = .photoLibrary
            self.imagePicker.allowsEditing = true
            
            self.present(self.imagePicker, animated: true, completion: nil)
        }
        let cancelAction = UIAlertAction(title: "ยกเลิก", style: .destructive, handler: nil)
        
        actionSheet.addAction(cameraAction)
        actionSheet.addAction(photoLibraryAction)
        actionSheet.addAction(cancelAction)
        
        present(actionSheet, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            profileImage.image = image
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func registerButton(_ sender: Any) {
        
        if  (passwordField.text! == passwordconfirmField.text!){
                   sendRegister(username: usernameField.text!, password: passwordField.text!, email: emailField.text!,image: profileImage.image!.jpegData(compressionQuality: 1.0)!)
        }else{
               Alert.showAlert(vc: self, title: "Error", message: "รหัสไม่ถูกต้อง", action: nil)
        }
 
    }
    
    func sendRegister(username: String, password: String, email: String,image: Data) {
        
        let param: Parameters = ["username": username,
                                 "password": password,
                                 "email": email
                                ]
        
                
                Alamofire.upload(multipartFormData: { form in
                    for (key, value) in param {
                        form.append((value as! String).data(using: .utf8)!, withName: key)
                    }
                    
                    form.append(image, withName: "image", fileName: "image", mimeType: "image/jpeg")
                }, to: "http://tssnp.com/ws_bartrainer/register.php") { result in
                    switch result {
                    case .success(let upload, _, _):
                        upload.responseData { response in
                            if let data = response.result.value {
                                
                                
                   do {
                                    
                                    let decoder = JSONDecoder()
                                    let result = try decoder.decode(APIresponse.self, from: data)

                    print(result)

                    if result.message == "success" {
                        Alert.showAlert(vc: self, title: "ลงทะเบียนสำเร็จ", message: nil, action: {
//                            self.navigationController?.popViewController(animated: true)
                        })
                        
                        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Main")
                        UIApplication.shared.keyWindow?.rootViewController = vc
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
                    case .failure(let error):
                        print(error)
            }
        }
    }
}

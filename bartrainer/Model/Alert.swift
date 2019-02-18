//
//  Alert.swift
//  bartrainer
//
//  Created by Methira Denthongchai on 18/2/2562 BE.
//  Copyright © 2562 Methira Denthongchai. All rights reserved.
//

import Foundation
import UIKit

class Alert {
    
    public static func showAlert(vc: UIViewController, title: String?, message: String?, action: (() -> Void)?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let doneAction = UIAlertAction(title: "Done", style: .default) { _ in
            if let action = action {
                action()
            }
        }
        alert.addAction(doneAction)
        
        vc.present(alert, animated: true, completion: nil)
    }
    
}

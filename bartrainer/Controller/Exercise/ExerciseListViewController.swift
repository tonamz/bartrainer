//
//  ExerciseListViewController.swift
//  bartrainer
//
//  Created by Methira Denthongchai on 18/1/2562 BE.
//  Copyright © 2562 Methira Denthongchai. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class ExerciseListViewController: UIViewController {

    
   var selectedCategoryGroup: Category?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "bg.png")!)

        
        title = selectedCategoryGroup!.name


    }
    

}

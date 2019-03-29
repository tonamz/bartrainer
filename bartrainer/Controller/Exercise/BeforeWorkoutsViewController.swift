//
//  BeforeWorkoutsViewController.swift
//  bartrainer
//
//  Created by Methira Denthongchai on 29/3/2562 BE.
//  Copyright © 2562 Methira Denthongchai. All rights reserved.
//

import UIKit

class BeforeWorkoutsViewController: UIViewController {

        @IBOutlet weak var beforeGif: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

    beforeGif.loadGif(name: "pre-motion")
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

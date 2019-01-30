//
//  FitnessTableViewCell.swift
//  bartrainer
//
//  Created by Methira Denthongchai on 25/1/2562 BE.
//  Copyright © 2562 Methira Denthongchai. All rights reserved.
//

import UIKit

class FitnessTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var bgView: UITableView!
    @IBOutlet weak var fitnessLabel: UILabel!
    @IBOutlet weak var branchLabel: UILabel!
    @IBOutlet weak var fitnessImageView: UIImageView!

    override func awakeFromNib() {
  
        super.awakeFromNib()
        bgView.layer.cornerRadius = 10
        
        self.bgView.layer.cornerRadius = 10
        self.bgView.layer.borderWidth = 2
        self.bgView.layer.borderColor = UIColor.clear.cgColor
        self.contentView.layer.masksToBounds = true
        //        self.layer.shadowColor = UIColor.lightGray.cgColor
        //        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        //        self.layer.shadowRadius = 8
        //        self.layer.shadowOpacity = 0.5
        self.layer.masksToBounds = false
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.bgView.layer.cornerRadius).cgPath
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}



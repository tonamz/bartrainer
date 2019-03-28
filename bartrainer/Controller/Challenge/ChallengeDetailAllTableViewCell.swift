//
//  ChallengeDetailAllTableViewCell.swift
//  bartrainer
//
//  Created by Methira Denthongchai on 22/3/2562 BE.
//  Copyright © 2562 Methira Denthongchai. All rights reserved.
//

import UIKit

class ChallengeDetailAllTableViewCell: UITableViewCell {

    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var DetailLabel: UILabel!
    @IBOutlet weak var bgView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
      
        bgView.layer.cornerRadius = 60
        
        let myColor : UIColor = UIColor(red:0.99, green:0.50, blue:0.25, alpha:1.0)
        

        self.bgView.layer.cornerRadius = 24
        self.bgView.layer.borderWidth = 2
        self.bgView.layer.borderColor = myColor.cgColor
        self.contentView.layer.masksToBounds = true
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

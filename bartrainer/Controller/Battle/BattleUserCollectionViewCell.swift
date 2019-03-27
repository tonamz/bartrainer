//
//  BattleUserCollectionViewCell.swift
//  bartrainer
//
//  Created by Methira Denthongchai on 26/3/2562 BE.
//  Copyright © 2562 Methira Denthongchai. All rights reserved.
//

import UIKit

class BattleUserCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var nameExLabel: UILabel!
    @IBOutlet weak var repsLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        let myColor : UIColor = UIColor(red:0.99, green:0.50, blue:0.25, alpha:1.0)
      
        self.bgView.layer.cornerRadius = 10
        self.bgView.layer.borderWidth = 2
        self.bgView.layer.borderColor = myColor.cgColor
        self.contentView.layer.masksToBounds = true
        
        
    }
}

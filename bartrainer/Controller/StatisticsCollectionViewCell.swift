//
//  StatisticsCollectionViewCell.swift
//  bartrainer
//
//  Created by Methira Denthongchai on 30/3/2562 BE.
//  Copyright © 2562 Methira Denthongchai. All rights reserved.
//

import UIKit

class StatisticsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var bgView: UIView!
    
    override func awakeFromNib() {
          super.awakeFromNib()
    bgView.layer.cornerRadius = 20
    
    let myColor : UIColor = UIColor(red:0.99, green:0.50, blue:0.25, alpha:1.0)
    
    self.bgView.layer.cornerRadius = 20
    self.bgView.layer.borderWidth = 2
    self.bgView.layer.borderColor = myColor.cgColor
    self.contentView.layer.masksToBounds = true
            
    }
    
}

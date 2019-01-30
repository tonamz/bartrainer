//
//  ChallengeDetailCollectionViewCell.swift
//  bartrainer
//
//  Created by Methira Denthongchai on 30/1/2562 BE.
//  Copyright © 2562 Methira Denthongchai. All rights reserved.
//

import UIKit

class ChallengeDetailCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var headerLabel: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        bgView.layer.cornerRadius = 24
        
        let myColor : UIColor = UIColor(red:0.99, green:0.50, blue:0.25, alpha:1.0)
        
        self.bgView.layer.cornerRadius = 24
        self.bgView.layer.borderWidth = 2
        self.bgView.layer.borderColor = myColor.cgColor
        self.contentView.layer.masksToBounds = true

  
      
        
    }
    
}

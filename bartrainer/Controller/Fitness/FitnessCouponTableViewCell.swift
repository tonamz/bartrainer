//
//  FitnessCouponTableViewCell.swift
//  bartrainer
//
//  Created by Methira Denthongchai on 30/3/2562 BE.
//  Copyright © 2562 Methira Denthongchai. All rights reserved.
//

import UIKit

class FitnessCouponTableViewCell: UITableViewCell {
    
    @IBOutlet weak var headLabel: UILabel!
    @IBOutlet weak var codeBtn: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.codeBtn.layer.cornerRadius = 30
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

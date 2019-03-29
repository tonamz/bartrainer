//
//  BattleGroupTableViewCell.swift
//  bartrainer
//
//  Created by Methira Denthongchai on 19/2/2562 BE.
//  Copyright © 2562 Methira Denthongchai. All rights reserved.
//

import UIKit

class BattleGroupTableViewCell: UITableViewCell {
    
    @IBOutlet weak var rankLabel: UILabel!
    @IBOutlet weak var rankImageview: UIImageView!
    @IBOutlet weak var nameUser: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameEX: UILabel!
    @IBOutlet weak var scoreBattle: UILabel!


    override func awakeFromNib() {
        super.awakeFromNib()
 
        self.contentView.layer.masksToBounds = true
        self.layer.cornerRadius = 10
      profileImageView.layer.cornerRadius = 35
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

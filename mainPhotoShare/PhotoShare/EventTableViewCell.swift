//
//  EventTableViewCell.swift
//  PhotoShare
//
//  Created by ZEmac on 2015/12/03.
//  Copyright © 2015年 ie4a. All rights reserved.
//

import UIKit

class EventTableViewCell: UITableViewCell {

    @IBOutlet weak var event_name: UILabel!
    @IBOutlet weak var qrButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

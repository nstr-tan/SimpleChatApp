//
//  YouMessageTableViewCell.swift
//  SimpleChatApp
//
//  Created by Nestor Angelo Tan on 16/04/2017.
//  Copyright © 2017 NTan. All rights reserved.
//

import UIKit

class YouMessageTableViewCell: UITableViewCell {

    @IBOutlet var messageTextView: UITextView!
    @IBOutlet var usernameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.messageTextView.layer.cornerRadius = 5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

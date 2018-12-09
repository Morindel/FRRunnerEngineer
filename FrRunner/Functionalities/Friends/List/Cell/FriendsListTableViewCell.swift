//
//  FriendsListTableViewCell.swift
//  FrRunner
//
//  Created by Jakub Kołodziej on 03/12/2018.
//  Copyright © 2018 Jakub Kołodziej. All rights reserved.
//

import UIKit

class FriendsRequestListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var friendNameLabel: UILabel!
    @IBOutlet weak var addLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func loadWithFriend(user:User){
        self.friendNameLabel.text = user.username
    }
    
    func hideAddFriendLabel(){
        self.addLabel.isHidden = true
    }
    
}
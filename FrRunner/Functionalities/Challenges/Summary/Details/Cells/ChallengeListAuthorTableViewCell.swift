//
//  ChallengeListAuthorTableViewCell.swift
//  FrRunner
//
//  Created by Jakub Kołodziej on 11/12/2018.
//  Copyright © 2018 Jakub Kołodziej. All rights reserved.
//

import UIKit

class ChallengeListAuthorTableViewCell: ChallengeListBaseTableViewCell {

    @IBOutlet weak var authorLabel: UILabel!
    
    @IBOutlet weak var locationNameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    override func loadWithChallenge(challenge: DateChallenge) {
        self.authorLabel.text = challenge.createdBy
    }
    
}

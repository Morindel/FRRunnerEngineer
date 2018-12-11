//
//  ChallengeListDescriptionTableViewCell.swift
//  FrRunner
//
//  Created by Jakub Kołodziej on 11/12/2018.
//  Copyright © 2018 Jakub Kołodziej. All rights reserved.
//

import UIKit

class ChallengeListDescriptionTableViewCell: ChallengeListBaseTableViewCell {

    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func loadWithChallenge(challenge: DateChallenge) {
        self.descriptionLabel.text = challenge.challengeDescription
    }
    
}

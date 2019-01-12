//
//  ChallengeListTableViewCell.swift
//  FrRunner
//
//  Created by Jakub Kołodziej on 02/01/2019.
//  Copyright © 2019 Jakub Kołodziej. All rights reserved.
//

import UIKit

class ChallengeListTableViewCell: ChallengeListBaseTableViewCell {

    @IBOutlet weak var challengeWinnerLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func loadWithChallenge(challenge: DateChallenge) {
        self.challengeWinnerLabel.text = "The winner is test1"
    }
    
}

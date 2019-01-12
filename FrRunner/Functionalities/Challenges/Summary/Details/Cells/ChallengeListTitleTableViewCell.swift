//
//  ChallengeSummaryTitleTableViewCell.swift
//  FrRunner
//
//  Created by Jakub Kołodziej on 09/12/2018.
//  Copyright © 2018 Jakub Kołodziej. All rights reserved.
//

import UIKit

class ChallengeListTitleTableViewCell: ChallengeListBaseTableViewCell {

    @IBOutlet weak var tileLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var challengeTypeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func loadWithChallenge(challenge: DateChallenge) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
    
        self.tileLabel.text = challenge.title
        if let date = challenge.challengeDate {
               self.dateLabel.text = "Challenge end date \(dateFormatter.string(from: date))"
        }
        
        if challenge.type == "S" {
            self.challengeTypeLabel.text = "One run challenge"
        } else if challenge.type == "L" {
            self.challengeTypeLabel.text = "Long time challenge"
        } 
    }
    
}

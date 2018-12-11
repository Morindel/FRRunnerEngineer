//
//  ChallangeSummaryTableViewCell.swift
//  FrRunner
//
//  Created by Jakub Kołodziej on 09/12/2018.
//  Copyright © 2018 Jakub Kołodziej. All rights reserved.
//

import UIKit

class ChallangeSummaryTableViewCell: ChallengeListBaseTableViewCell {
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func loadWithUserAndChallenge(user: UserModel, challenge: DateChallenge) {
        self.usernameLabel.text = user.username
        
        guard let username = user.username, let createdDate = challenge.createdDate, let dateTo = challenge.createdDate else {
            return
        }
        let progress = ChallengesLocalRepository.getDistanceBetween(username: username, dateFrom: createdDate, dateTo: dateTo)
        
        let distance = Measurement(value: progress, unit: UnitLength.meters)
        
        self.descriptionLabel.text = "Has made \(FormatDisplay.distance(distance)) so far"
    }

    
    
    
}

//
//  EventDetailsDescriptionTableViewCell.swift
//  FrRunner
//
//  Created by Jakub Kołodziej on 27/11/2018.
//  Copyright © 2018 Jakub Kołodziej. All rights reserved.
//

import UIKit

class EventDetailsDescriptionTableViewCell: EventDetailsBaseTableViewCell {

    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func loadWithEvent(event: Event) {
        self.descriptionLabel.text = event.eventDescription
    }
    
}

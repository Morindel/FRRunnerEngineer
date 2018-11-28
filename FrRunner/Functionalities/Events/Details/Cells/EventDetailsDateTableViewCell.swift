//
//  EventDetailsDateTableViewCell.swift
//  FrRunner
//
//  Created by Jakub Kołodziej on 27/11/2018.
//  Copyright © 2018 Jakub Kołodziej. All rights reserved.
//

import UIKit

class EventDetailsDateTableViewCell: EventDetailsBaseTableViewCell {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func loadWithEvent(event: Event) {
        
        guard let eventDate = event.date else {
            return
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        self.dateLabel.text = dateFormatter.string(from: eventDate)
        self.distanceLabel.text = "Distance : \(event.distance) km"
    }
    
}

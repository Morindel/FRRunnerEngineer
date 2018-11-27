//
//  EventDetailsTitleTableViewCell.swift
//  FrRunner
//
//  Created by Jakub Kołodziej on 27/11/2018.
//  Copyright © 2018 Jakub Kołodziej. All rights reserved.
//

import UIKit

class EventDetailsTitleTableViewCell: EventDetailsBaseTableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func loadWithEvent(event: Event){
     
        self.titleLabel.text = event.name
        
    }
}

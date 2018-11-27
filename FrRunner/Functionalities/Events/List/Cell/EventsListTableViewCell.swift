//
//  EventsListTableViewCell.swift
//  FrRunner
//
//  Created by Jakub Kołodziej on 21/11/2018.
//  Copyright © 2018 Jakub Kołodziej. All rights reserved.
//

import UIKit

class EventsListTableViewCell: UITableViewCell {

    @IBOutlet weak var eventNameLabel: UILabel!
    @IBOutlet weak var locationNameLabel: UILabel!
    @IBOutlet weak var eventDistanceLabel: UILabel!
    @IBOutlet weak var eventDateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func loadWithEvent(event:Event){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let dateText = dateFormatter.string(from: event.date ?? Date.init())
        let distanceText = String(format: "%f", Double(round(1000*event.distance)/1000))
        
        self.eventNameLabel.text = "Event name : \(event.name ?? "None")"
        self.eventDateLabel.text = "Event date : \(dateText)"
        self.locationNameLabel.text = "Location name : \(event.locationName ?? "None")"
        self.eventDistanceLabel.text = "Event distance : \(distanceText)"
    }
    
    
    
}

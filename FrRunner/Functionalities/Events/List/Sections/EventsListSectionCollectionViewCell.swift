//
//  EventsListSectionCollectionViewCell.swift
//  FrRunner
//
//  Created by Jakub Kołodziej on 21/11/2018.
//  Copyright © 2018 Jakub Kołodziej. All rights reserved.
//

import UIKit

class EventsListSectionCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var sectionNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override var isSelected: Bool{
        didSet{
            if self.isSelected{
                self.backgroundColor = UIColor(red: 0/255.0, green: 128/255.0, blue: 240/255.0, alpha: 1.0)
            } else {
           
                self.backgroundColor = UIColor(red: 211/255, green: 211/255, blue: 211/255, alpha: 1.0)
            }
        }
    }
    func loadWithSectionName(sectionType: Int){
        switch sectionType {
        case EventListSectionType.EventListSponsoredSection.rawValue:
            self.sectionNameLabel.text = "Official runs"
        case EventListSectionType.EventListYourSection.rawValue:
            self.sectionNameLabel.text = "Your runs"
        case EventListSectionType.EventListOthersSection.rawValue:
            self.sectionNameLabel.text = "Other runs"
        default:
            self.sectionNameLabel.text = "runs"
        }
        
    }

}

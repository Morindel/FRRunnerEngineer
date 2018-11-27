//
//  EventDetailsViewController.swift
//  FrRunner
//
//  Created by Jakub Kołodziej on 26/11/2018.
//  Copyright © 2018 Jakub Kołodziej. All rights reserved.
//

import Foundation
import UIKit

enum EventDetailsSection : Int{
    case EventDetailsLocationSection = 0 , EventDetailsTitleSection, EventDetailsSectionCount
}

class EventDetailsViewController : BaseController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var event : Event?
    
    static func newInstanceWithEvent
        (event: Event) -> UIViewController{
        let storyboard = UIStoryboard(name: "EventDetails", bundle: nil)
        
        guard let viewController = storyboard.instantiateViewController(withIdentifier: "EventDetailsViewController") as? EventDetailsViewController else {
            return UIViewController()
        }
        
        viewController.event = event
        
        return viewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.registerCells()
    }
    
    
    
    //MARK: - TableView
    
    func registerCells(){
        tableView.register(UINib.init(nibName: "EventDetailsLocationTableViewCell", bundle: nil), forCellReuseIdentifier: "EventDetailsLocationTableViewCell")
        tableView.register(UINib.init(nibName: "EventDetailsTitleTableViewCell", bundle: nil), forCellReuseIdentifier: "EventDetailsTitleTableViewCell")
        
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return EventDetailsSection.EventDetailsSectionCount.rawValue
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell : EventDetailsBaseTableViewCell?
        
        switch indexPath.section {
        case EventDetailsSection.EventDetailsLocationSection.rawValue :
            cell = tableView.dequeueReusableCell(withIdentifier: "EventDetailsLocationTableViewCell", for: indexPath) as! EventDetailsLocationTableViewCell
            break
            
        case EventDetailsSection.EventDetailsTitleSection.rawValue :
                        cell = tableView.dequeueReusableCell(withIdentifier: "EventDetailsTitleTableViewCell", for: indexPath) as! EventDetailsTitleTableViewCell
            break
            
        default:
            cell = EventDetailsBaseTableViewCell.init()
            break
            
        }
  
        
        guard let event = event else {
            return UITableViewCell.init()
        }
        
        guard let eventCell = cell else {
            return UITableViewCell.init()
        }
        
        eventCell.loadWithEvent(event: event)
        
        return eventCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(indexPath.section == 0){
            return 230
        } else {
            return UITableView.automaticDimension
        }
    }
    
}

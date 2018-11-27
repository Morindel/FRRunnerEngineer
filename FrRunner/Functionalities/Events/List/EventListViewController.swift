//
//  EventListViewController.swift
//  FrRunner
//
//  Created by Jakub Kołodziej on 20/11/2018.
//  Copyright © 2018 Jakub Kołodziej. All rights reserved.
//

import Foundation
import UIKit
import CoreData

enum EventListSectionType : Int{
    case EventListSponsoredSection = 0 , EventListYourSection, EventListOthersSection, EventListSectionCount
}

class EventListViewController : UIViewController,UITableViewDelegate,UITableViewDataSource,NSFetchedResultsControllerDelegate {
    
    var type : EventListSectionType?
    
    var fetchedResultsController: NSFetchedResultsController<NSManagedObject>!
    
    @IBOutlet weak var tableView: UITableView!

    //MARK: - LifeCycle
    
    static func newInstanceWithEventListType(withType type:EventListSectionType) -> UIViewController{
        let storyboard = UIStoryboard(name: "EventList", bundle: nil)
        
        guard let viewController = storyboard.instantiateViewController(withIdentifier: "EventListViewController") as? EventListViewController else {
            return UIViewController()
        }
        
        viewController.type = type
        
        return viewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loadData()
        
        self.registerCells()
        self.tableView.reloadData()
    }
    
    //MARK: - LoadData
    
    func loadData(){
        self.initializeFetchedResultsController()
        fetchData()
    }
    
    //MARK: - Fetched result controller
    
    func initializeFetchedResultsController() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Event")
        let dateSort = NSSortDescriptor(key: "date", ascending: true)
        request.sortDescriptors = [dateSort]
        
        var predicate : NSPredicate?
        
        switch self.type?.rawValue {
        case EventListSectionType.EventListSponsoredSection.rawValue:
            predicate = NSPredicate(format: "eventStatus == %@", "S")
        case EventListSectionType.EventListYourSection.rawValue :
            predicate = NSPredicate(format: "createdBy == %@", UserDefaults.standard.string(forKey: "username") ?? "user")
        case EventListSectionType.EventListOthersSection.rawValue :
            predicate = NSPredicate(format: "eventStatus == %@", "N")
        default:
            predicate = NSPredicate.init()
        }
        
        request.predicate = predicate
        
        let moc = CoreDataStack.context
        fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: moc, sectionNameKeyPath: nil, cacheName: nil) as? NSFetchedResultsController<NSManagedObject>
        fetchedResultsController.delegate = self
        
    }
    
    func fetchData() {
        do {
            try fetchedResultsController.performFetch()
            self.tableView.reloadData()
        } catch {
            fatalError("Failed to initialize FetchedResultsController: \(error)")
        }
    }
    
    //MARK: - TableView
    
    func registerCells(){
        tableView.register(UINib.init(nibName: "EventsListTableViewCell", bundle: nil), forCellReuseIdentifier: "EventsListTableViewCell")
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.fetchedResultsController.fetchedObjects?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let event = self.fetchedResultsController.fetchedObjects?[indexPath.row] as? Event
        
        let cell : EventsListTableViewCell = tableView.dequeueReusableCell(withIdentifier: "EventsListTableViewCell", for: indexPath) as! EventsListTableViewCell
        if let noNilEvent = event{
            cell.loadWithEvent(event: noNilEvent)
            return cell
        }
        
        
        return UITableViewCell.init()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: false)
        
        guard let event = self.fetchedResultsController.fetchedObjects?[indexPath.row] as? Event else {
            return
        }
        
        guard let vc = EventDetailsViewController.newInstanceWithEvent(event: event) as? EventDetailsViewController else {
            return
        }
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

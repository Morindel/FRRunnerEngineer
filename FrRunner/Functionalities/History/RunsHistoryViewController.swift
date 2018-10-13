//
//  RunsHistoryViewController.swift
//  FrRunner
//
//  Created by Jakub Kołodziej on 14.08.2018.
//  Copyright © 2018 Jakub Kołodziej. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class RunsHistoryViewController : UITableViewController {
    
    override func loadView() {
        super.loadView()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getRuns().count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : RunsHistoryTableViewCell = tableView.dequeueReusableCell(withIdentifier: "runsHistory", for: indexPath) as! RunsHistoryTableViewCell;
        cell.setRun(run: getRuns()[indexPath.row])
        return cell
    }
    
    private func getRuns() -> [Run]{
        let fetchRequest: NSFetchRequest<Run> = Run.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: #keyPath(Run.timeStamp), ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        do {
            return try CoreDataStack.context.fetch(fetchRequest)
        } catch {
            return []
        }
    }
        
    
}


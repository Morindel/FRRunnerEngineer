//
//  AccountNetworkManager.swift
//  FrRunner
//
//  Created by Jakub Kołodziej on 08/12/2018.
//  Copyright © 2018 Jakub Kołodziej. All rights reserved.
//

import Foundation
import CoreData

class AccountNetworkManager {
    
    static func deleteAllData(_ entity:String) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let results = try CoreDataStack.context.fetch(fetchRequest)
            
            for object in results {
                guard let objectData = object as? NSManagedObject else {continue}
                
                CoreDataStack.context.delete(objectData)
            }
        } catch let error {
            print("Detele all data in \(entity) error :", error)
        }
    }
}

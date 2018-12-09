//
//  ChallengesLocalRepository.swift
//  FrRunner
//
//  Created by Jakub Kołodziej on 09/12/2018.
//  Copyright © 2018 Jakub Kołodziej. All rights reserved.
//

import Foundation
import CoreData

class ChallengesLocalRepository{
    
    static func getDateChallenges() -> [DateChallenge]{
        let fetchRequest: NSFetchRequest<DateChallenge> = DateChallenge.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: #keyPath(DateChallenge.challengeDate), ascending: true)
        
        guard let username = UserDefaults.standard.string(forKey: "username") else {
            return[]
        }
        
        let predicate = NSPredicate.init(format:"ANY users.username == %@", username)
        
        fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = [sortDescriptor]
        do {
            return try CoreDataStack.context.fetch(fetchRequest)
        } catch {
            return []
        }
    }
    
    static func getDistanceBetween(username: String , dateFrom:Date, dateTo:Date) -> Double {
        let fetchRequest: NSFetchRequest<Run> = Run.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: #keyPath(Run.timeStamp), ascending: true)
        
        var summaryDistance = 0.0
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
            dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        let stringstartDate = dateFormatter.string(from: dateFrom)
        let stringendDate = dateFormatter.string(from: dateTo)
        
        let startDate:NSDate = dateFormatter.date(from: stringstartDate)! as NSDate
        let endDate:NSDate = dateFormatter.date(from: stringendDate)! as NSDate
        
        let predicate = NSPredicate.init(format:"username == %@ AND (timeStamp >= %@) AND (timeStamp <= %@, username)", username, startDate, endDate)
    
        fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do{
        let runs = try CoreDataStack.context.fetch(fetchRequest) as [Run]
            for run in runs{
                summaryDistance += run.distance
            }
        } catch(let error){
            print(error)
        }
        
        return summaryDistance
    }
}

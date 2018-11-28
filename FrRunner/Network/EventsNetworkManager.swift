//
//  EventsNetworkManager.swift
//  FrRunner
//
//  Created by Jakub Kołodziej on 04/11/2018.
//  Copyright © 2018 Jakub Kołodziej. All rights reserved.
//

import Foundation
import Alamofire
import CoreData

class EventsNetworkManager
{
    
    let headers: HTTPHeaders = [
        "Authorization": "Token 9a136bc8c172cc4a7137343309bb43a9899f10e2",
        "Accept": "application/json"
    ]
    
    static func getAllEvents(completion: @escaping (Bool) ->Void) {
        
        guard let token = UserDefaults.standard.string(forKey: "token") else {
            print("Token error");
            return
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        DispatchQueue.global().async {
            
            
            Alamofire.request(API_HOST+"/events/", method: .get, parameters: nil, encoding: JSONEncoding.default, headers:[
                "Authorization": "Token \(token)",
                "Accept": "application/json"
                ]).responseJSON(completionHandler: { response in
                
                if let json = response.result.value as? [[String : AnyObject]] {
                    
                    for data in json{
                        guard let eventId = data["id"] as? Int32 else {
                            return
                        }
                        
                       let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Event")
                        let predicate = NSPredicate.init(format: "eventId == \(eventId)")
                        
                        fetchRequest.predicate = predicate
                    
                        do{
                        let fetchResults = try CoreDataStack.context.fetch(fetchRequest) as? [NSManagedObject]
                            if(fetchResults!.count == 0){
                            let newEvent = Event(context: CoreDataStack.context)
                            newEvent.eventId = eventId
                            newEvent.createdBy = data["createdBy"] as? String
                            newEvent.name =  data["title"] as? String
                            newEvent.locationName = data["locationName"] as? String
                                
                            let dateString = dateFormatter.date(from: data["date"] as? String ?? "")
                            
                            newEvent.date = dateString
                            newEvent.latitude = data["latitude"] as? Double ?? 0.0
                            newEvent.longitude = data["longitude"] as? Double ?? 0.0
                            newEvent.distance = data["distance"] as? Double ?? 0.0
                            newEvent.eventStatus = data["eventStatus"] as? String
                            newEvent.eventDescription = data["eventDescription"] as? String
                            
                            CoreDataStack.saveContext()
                            } }
                        catch{
                            return
                        }
                    }
                }
                
                DispatchQueue.main.async {
                    completion(response.result.isSuccess)
                }
                
            })
            
        }
    }
    
    static func createEvent(parameters:Parameters,completion: @escaping (Bool) -> Void) {
        
        guard let token = UserDefaults.standard.string(forKey: "token") else {
            print("Token error");
            return
        }
        
        DispatchQueue.global().async {
           
            Alamofire.request(API_HOST+"/events/", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers:[
                "Authorization": "Token \(token)",
                "Accept": "application/json"
                ]).responseString{ response in
                switch response.result {
                case .success:
                    print(response)
                    completion(true)
                    break
                    
                case .failure:
                    completion(false)
                }
                
            }
        }
    }
    
}


extension Date {
    /**
     Formats a Date
     
     - parameters format: (String) for eg dd-MM-yyyy hh-mm-ss
     */
    func format(format:String = "dd-MM-yyyy hh-mm-ss") -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        let dateString = dateFormatter.string(from: self)
        if let newDate = dateFormatter.date(from: dateString) {
            return newDate
        } else {
            return self
        }
    }
}

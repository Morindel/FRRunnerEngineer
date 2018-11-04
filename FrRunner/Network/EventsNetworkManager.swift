//
//  EventsNetworkManager.swift
//  FrRunner
//
//  Created by Jakub Kołodziej on 04/11/2018.
//  Copyright © 2018 Jakub Kołodziej. All rights reserved.
//

import Foundation
import Alamofire

class EventsNetworkManager
{
    
    
    static func getAllEvents(completion: @escaping (Bool) ->Void) {
        
        DispatchQueue.global().async {
            
            Alamofire.request(API_HOST+"/events").responseJSON(completionHandler: { response in
                
                if let json = response.result.value as? [[String : AnyObject]] {
                    
                    for data in json{
                       let newEvent = Event(context: CoreDataStack.context)
                        
                        newEvent.name = data["code"] as? String
                        
                        CoreDataStack.saveContext()
                    }
                }
                
                DispatchQueue.main.async {
                    completion(response.result.isSuccess)
                }
                
            })
            
        }
    }
    
}

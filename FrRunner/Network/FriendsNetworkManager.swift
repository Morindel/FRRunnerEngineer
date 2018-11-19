//
//  FriendsNetworkManager.swift
//  FrRunner
//
//  Created by Jakub Kołodziej on 17/11/2018.
//  Copyright © 2018 Jakub Kołodziej. All rights reserved.
//

import Foundation
import Alamofire

class FriendsNetworkManager {
    
    static func createEvent(username:String, completion: @escaping (Bool) -> Void) {
        Alamofire.request(API_HOST+"/friend/add/\(username)",method:.get,parameters:nil).responseData
            { response in switch response.result {
            case .success(let data):
                switch response.response?.statusCode ?? -1 {
                case 200:
                    print(response.result)
                    completion(true)
                case 401:
                    print(response.result)
                    completion(false)
                default:
                    print(response.result)
                    completion(false)
                }
            case .failure(let error):
                print(error)
                completion(false)
                }
        }
    }
    
    static func getFriends(completion: @escaping (Bool) -> Void) {
        
        DispatchQueue.global().async {
            
            Alamofire.request(API_HOST+"/friends/admin/").responseJSON(completionHandler: { response in
                
                if let json = response.result.value as? [[String : AnyObject]] {
                    
                    for data in json{
//                        let newEvent = Event(context: CoreDataStack.context)
//
//                        newEvent.name = data["code"] as? String
//
//                        CoreDataStack.saveContext()
                        print(data)
                    }
                }
                
                DispatchQueue.main.async {
                    completion(response.result.isSuccess)
                }
                
            })
            
        }
    }
    
}

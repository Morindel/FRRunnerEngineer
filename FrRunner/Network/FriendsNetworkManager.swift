//
//  FriendsNetworkManager.swift
//  FrRunner
//
//  Created by Jakub Kołodziej on 17/11/2018.
//  Copyright © 2018 Jakub Kołodziej. All rights reserved.
//

import CoreData

struct Friendship : Decodable{
    let model : String?
    let pk : Int32
    let fields : FriendshipField?
}

struct FriendshipField : Decodable {
    let from_user : Int32
    let to_user : Int32
    
}

struct UserStruct : Decodable {
    let pk : Int?
    let username : String?
}

import Foundation
import Alamofire

class FriendsNetworkManager {
    
    static func makeFriend(parameters:Parameters, completion: @escaping (Bool) -> Void) {
        
        guard let token = UserDefaults.standard.string(forKey: "token") else {
            print("Token error");
            return
        }
        
        DispatchQueue.global().async {
            
            Alamofire.request(API_HOST+"/friends/", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers:[
                "Authorization": "Token \(token)",
                "Accept": "application/json"
                ]).responseJSON{ response in
                    switch response.result {
                    case .success:
                        print(response)
                        completion(true)
                        break
                        
                    case .failure:
                        completion(false)
                        break
                    }
                    
            }
        }
    }
    
    static func acceptFriendRequest(parameters:Parameters, completion: @escaping (Bool) -> Void) {
        
        guard let token = UserDefaults.standard.string(forKey: "token") else {
            print("Token error");
            return
        }
        
        DispatchQueue.global().async {
            
            Alamofire.request(API_HOST+"/friendAdd/", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers:[
                "Authorization": "Token \(token)",
                "Accept": "application/json"
                ]).responseJSON{ response in
                    
//                    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "FriendRequest")
//                    let predicate = NSPredicate.init(format: "fromUserCode == \(parameters["fromUser"]) AND toUserCode == \")
//
//                    fetchRequest.predicate = predicate
//
//                    do{
//                        let fetchResults = try CoreDataStack.context.fetch(fetchRequest) as? [NSManagedObject]
//                        if(fetchResults!.count == 0){
//                            let newFriendRequest = FriendRequest(context: CoreDataStack.context)
//                            newFriendRequest.id = Int32(friendRequest.pk)
//                            newFriendRequest.fromUserCode = field.from_user
//                            newFriendRequest.toUserCode = field.to_user
//                            newFriendRequest.accepted = false
//
//                            CoreDataStack.saveContext()
//
//                        }
//                    completion(true)
//                    }
                    
            }
        }
    }
    
    static func getFriends(completion: @escaping (Bool) -> Void) {
        
        guard let token = UserDefaults.standard.string(forKey: "token") else {
            print("Token error");
            return
        }
        
        DispatchQueue.global().async {
            
            
            Alamofire.request(API_HOST+"/friends/", method: .get, parameters: nil, encoding: JSONEncoding.default, headers:[
                "Authorization": "Token \(token)",
                "Accept": "application/json"
                ]).responseJSON(completionHandler: { response in
                    
                    
                    
                    guard let data = response.data else {
                        return
                    }
                    
                    DispatchQueue.main.async {
                        completion(response.result.isSuccess)
                    }
                    
                })
            
        }
    }
    
    static func getFriendsRequest(completion: @escaping (Bool) -> Void) {
        
        guard let token = UserDefaults.standard.string(forKey: "token") else {
            print("Token error");
            return
        }
        
        DispatchQueue.global().async {
            
            
            Alamofire.request(API_HOST+"/friendsRequest/", method: .get, parameters: nil, encoding: JSONEncoding.default, headers:[
                "Authorization": "Token \(token)",
                "Accept": "application/json"
                ]).responseJSON(completionHandler: { response in switch response.result {
                case .success:
                    
                    guard let stringData = response.result.value as? String else {
                        return
                    }
  
                    guard let jsonData = stringData.data(using: .utf8) else {
                        return
                    }
                    
                    do{
                        let friendListRequest = try JSONDecoder().decode([Friendship].self, from: jsonData)
                        
                        self.saveDataForFriendRequest(friendRequests: friendListRequest)
                    }
                    catch(let error){
                        print(error)
                    }
                    
                    DispatchQueue.main.async {
                        completion(response.result.isSuccess)
                    }
                    
                case .failure(let error):
                    print("Request failed with error: \(error)")
                    }
                    
                })
            
        }
    }
    
    static func getUsers(completion: @escaping (Bool) -> Void) {
        
        guard let token = UserDefaults.standard.string(forKey: "token") else {
            print("Token error");
            return
        }
        
        DispatchQueue.global().async {
            
            
            Alamofire.request(API_HOST+"/all_users", method: .get, parameters: nil, encoding: JSONEncoding.default, headers:[
                "Authorization": "Token \(token)",
                "Accept": "application/json"
                ]).responseJSON(completionHandler: { response in
                    
                    guard let data = response.data else {
                        return
                    }
                    
                    do {
                        let users =  try JSONDecoder().decode([User].self, from: data)
                        
                        saveDataForUsers(users: users)
                    } catch (let error){
                        print(error)
                    }
                    
                    
                    DispatchQueue.main.async {
                        completion(response.result.isSuccess)
                    }
                    
                })
            
        }
    }
    
    static func saveDataForUsers(users:[User]){
        for user in users {
            
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "UserModel")
            let predicate = NSPredicate.init(format: "id == \(user.id)")
            
            fetchRequest.predicate = predicate
            
            do{
                let fetchResults = try CoreDataStack.context.fetch(fetchRequest) as? [NSManagedObject]
                if(fetchResults!.count == 0){
                    let newUser = UserModel(context: CoreDataStack.context)
                    newUser.id = Int32(user.id)
                    newUser.username = user.username
                    
                    CoreDataStack.saveContext()
                    
                }
            } catch(let error) {
                print(error)
            }
            
        }
    }
    
    static func saveDataForFriendRequest(friendRequests:[Friendship]) {
        for friendRequest in friendRequests {
            
            guard let field = friendRequest.fields else {
                continue
            }
            
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "FriendRequest")
            let predicate = NSPredicate.init(format: "id == \(friendRequest.pk)")
            
            fetchRequest.predicate = predicate
            
            do{
                let fetchResults = try CoreDataStack.context.fetch(fetchRequest) as? [NSManagedObject]
                if(fetchResults!.count == 0){
                    let newFriendRequest = FriendRequest(context: CoreDataStack.context)
                    newFriendRequest.id = Int32(friendRequest.pk)
                    newFriendRequest.fromUserCode = field.from_user
                    newFriendRequest.toUserCode = field.to_user
                    newFriendRequest.accepted = false
                    
                    CoreDataStack.saveContext()
                    
                }
            } catch(let error) {
                print(error)
            }
            
        }
    }
    
    static func getFriendsRequestForUser() -> [User]? {
        
        var usersArray = [User].init()
        
        let username = "test3"
//            UserDefaults.standard.string(forKey: "username") else {
//            return usersArray
//        }

        let userId = FriendsNetworkManager.getUserId(username: username)

        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "FriendRequest")
        let predicate = NSPredicate.init(format: "toUserCode == \(userId)")
        
        fetchRequest.predicate = predicate
        
        do{
            let fetchResults = try CoreDataStack.context.fetch(fetchRequest)
            
            for data in fetchResults as! [NSManagedObject]{
                let friendUserId = data.value(forKey: "id") as! Int32
                let fromUsername = FriendsNetworkManager.getUserName(userId: friendUserId)
                let user = User.init(id: Int(friendUserId), username: fromUsername)
                usersArray.append(user)
            }
            
        } catch(let error){
            print(error)
        }
        
        return usersArray
    }
    
    
    static func getUserId(username:String) -> Int32 {
      
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "UserModel")
        let predicate = NSPredicate.init(format: "username == %@",username)
        
        fetchRequest.predicate = predicate
        
        var userId = Int32.init(0)
        
        do{
            let fetchResults = try CoreDataStack.context.fetch(fetchRequest)
            
            for data in fetchResults as! [NSManagedObject]{
                userId = data.value(forKey: "id") as! Int32
            }
            
        } catch(let error){
            print(error)
        }
        
        return userId
    }
    
    static func getUserName(userId:Int32) -> String {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "UserModel")
        let predicate = NSPredicate.init(format: "id == \(userId)")
        
        fetchRequest.predicate = predicate
        
        var username
            = ""
        
        do{
            let fetchResults = try CoreDataStack.context.fetch(fetchRequest)
            
            for data in fetchResults as! [NSManagedObject]{
                username = data.value(forKey: "username") as! String
            }
            
        } catch(let error){
            print(error)
        }
        
        return username
    }
    
    
}

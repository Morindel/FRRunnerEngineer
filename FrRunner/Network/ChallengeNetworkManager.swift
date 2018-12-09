//
//  ChallengeNetworkManager.swift
//  FrRunner
//
//  Created by Jakub Kołodziej on 09/12/2018.
//  Copyright © 2018 Jakub Kołodziej. All rights reserved.
//

import Foundation
import CoreData
import Alamofire

class ChallengeNetworkManager {
    
    static func makeChallenge(parameters:Parameters, completion: @escaping (Bool) -> Void) {
        
        guard let token = UserDefaults.standard.string(forKey: "token") else {
            print("Token error");
            return
        }
        
        DispatchQueue.global().async {
            
            Alamofire.request(API_HOST+"/dateChallenges/", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers:[
                "Authorization": "Token \(token)",
                "Accept": "application/json"
                ]).responseJSON{ response in
                    switch response.result {
                    case .success:
                        print(response)
                        completion(true)
                        break
                        
                    case .failure:
                        print(response)
                        completion(false)
                        break
                    }
                    
            }
        }
    }
    
}

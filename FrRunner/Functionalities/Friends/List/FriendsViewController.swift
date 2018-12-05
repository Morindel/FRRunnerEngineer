//
//  FriendsViewController.swift
//  FrRunner
//
//  Created by Jakub Kołodziej on 30/11/2018.
//  Copyright © 2018 Jakub Kołodziej. All rights reserved.
//

import UIKit

class FriendsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
        let parameters = [
            "username":"admin"] as [String : AnyObject]
        
        FriendsNetworkManager.makeFriend(parameters: parameters) { (Bool) in
            print("make friend")
        }
        
        FriendsNetworkManager.getFriendsRequest { (Bool) in
            print("get friend request")
        }
        
        let parameterss = [
            "fromUser":1,
            "toUser":3] as [String : AnyObject]
        
        FriendsNetworkManager.acceptFriendRequest(parameters: parameterss) { (Bool) in
            
            
        }
        
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

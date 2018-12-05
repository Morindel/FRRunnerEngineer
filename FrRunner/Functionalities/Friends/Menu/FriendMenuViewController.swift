//
//  FriendMenuViewController.swift
//  FrRunner
//
//  Created by Jakub Kołodziej on 03/12/2018.
//  Copyright © 2018 Jakub Kołodziej. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class FriendMenuViewController: BaseController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func sendFriendRequestButtonClicked(_ sender: Any) {
        
        let alertController = UIAlertController(title: "Add New Name", message: "", preferredStyle: .alert)
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Enter username"
        }
        let saveAction = UIAlertAction(title: "Send an invitation", style: .default, handler: { alert -> Void in
          
            guard let textField = alertController.textFields?.first else {
                print("error")
                return
            }
            
            guard let username = textField.text else{
                print("no username")
                return
            }
            
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "UserModel")
            let predicate = NSPredicate.init(format: "username == %@",username)
            
            fetchRequest.predicate = predicate
            
            
            do{
                let fetchResults = try CoreDataStack.context.fetch(fetchRequest)
                
                var userId : Int32 = Int32.init(0)
                
                for data in fetchResults as! [NSManagedObject]{
                    userId = data.value(forKey: "id") as! Int32
                }
                
                let parameters = [
                    "pk":userId]
                
            self.showLoadingView()
            FriendsNetworkManager.makeFriend(parameters: parameters, completion: { (Bool) in
                
                Helper.showAlert(viewController: self, title: "Accepted", message: "Friend request sent")
                
                self.hideLoadingView()
            })
                
            } catch{
                  Helper.showAlert(viewController: self, title:"Not accepted", message: "Friend request can't be sent")
            }
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: { (action : UIAlertAction!) -> Void in })
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
}

//
//  FriendsListViewController.swift
//  FrRunner
//
//  Created by Jakub Kołodziej on 03/12/2018.
//  Copyright © 2018 Jakub Kołodziej. All rights reserved.
//

import Foundation
import UIKit
import CoreData

enum FriendsListSectionType : Int{
    case FriendsListSection = 0 , FriendsRequestSection, FriendsListSectionCount
}

class FriendsListViewController : BaseController,UITableViewDelegate,UITableViewDataSource, NSFetchedResultsControllerDelegate {
    
    var type : FriendsListSectionType?
    
    var friendsList : [User]?
    @IBOutlet weak var tableView: UITableView!
    
    static func newInstanceWithFriendsListType(withType type:FriendsListSectionType) -> UIViewController{
        let storyboard = UIStoryboard(name: "FriendsList", bundle: nil)
        
        guard let viewController = storyboard.instantiateViewController(withIdentifier: "FriendsListViewController") as? FriendsListViewController else {
            return UIViewController()
        }
        
        viewController.type = type
        
        return viewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerCells()
        self.loadData()
        
        self.tableView.tableFooterView = UIView()
    }
    
    func loadData() {
        self.showLoadingView()
        
        switch type?.rawValue {
        case FriendsListSectionType.FriendsRequestSection.rawValue:
            FriendsNetworkManager.getFriendsRequest { (Bool) in
                self.friendsList = FriendsNetworkManager.getFriendsRequestForUser()
                self.tableView.reloadData()
                self.hideLoadingView()
            }
            break
        default:
            self.hideLoadingView()
            break
        }
    }
    
    //MARK: - TableView
    
    func registerCells(){
        tableView.register(UINib.init(nibName: "FriendsRequestListTableViewCell", bundle: nil), forCellReuseIdentifier: "FriendsRequestListTableViewCell")
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendsList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let friendsList = self.friendsList else {
            return UITableViewCell.init()
        }
        
        let friend = friendsList[indexPath.row]
        
        
        let cell : FriendsRequestListTableViewCell = tableView.dequeueReusableCell(withIdentifier: "FriendsRequestListTableViewCell", for: indexPath) as! FriendsRequestListTableViewCell
        
        cell.loadWithFriend(user: friend)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let friendsList = self.friendsList else {
            return
        }
        
        let friend = friendsList[indexPath.row]

        Helper.showAlertWithBoolCompletion(viewController: self, title: "Add Friend", message: "Do you want to add \(friend.username) as a Friend?") { (Bool) in
            if (Bool){
                let parameters = [
                    "fromUser":friend.id] as [String : AnyObject]
                
                FriendsNetworkManager.acceptFriendRequest(parameters: parameters) { (Bool) in
                    
                }
            }
        }
        
        
    }
    
}

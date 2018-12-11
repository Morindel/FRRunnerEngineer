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
    var isSelection : Bool?
    var selectedSet : Set<User>?
    
    var delegate  : FriendsListViewControllerDelegate?
    
    @IBOutlet weak var addButtonConstraintHeight: NSLayoutConstraint!
    
    var friendsList : [User]?
    @IBOutlet weak var tableView: UITableView!
    
    static func newInstanceWithFriendsListType(withType type:FriendsListSectionType) -> UIViewController{
        let storyboard = UIStoryboard(name: "FriendsList", bundle: nil)
        
        guard let viewController = storyboard.instantiateViewController(withIdentifier: "FriendsListViewController") as? FriendsListViewController else {
            return UIViewController()
        }
        
        viewController.type = type
        viewController.isSelection = false
        return viewController
    }
    
    static func newInstanceWithSelectFriends() -> UIViewController{
        let storyboard = UIStoryboard(name: "FriendsList", bundle: nil)
        
        guard let viewController = storyboard.instantiateViewController(withIdentifier: "FriendsListViewController") as? FriendsListViewController else {
            return UIViewController()
        }
        
        viewController.type = FriendsListSectionType.FriendsListSection
        viewController.isSelection = true
        
        
        return viewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.friendsList = [User].init()
        self.registerCells()
        self.loadData()
        
        if(isSelection ?? false){
            self.tableView.allowsMultipleSelection = true
            self.selectedSet = Set.init()
        } else {
            self.addButtonConstraintHeight.constant = 0
        }
        
        self.tableView.tableFooterView = UIView()
        
        FriendsNetworkManager.getFriends { (Bool) in
            print("Sds")
        }
    }
    
    func loadData() {
        self.showLoadingView()
        
        switch type?.rawValue {
        case FriendsListSectionType.FriendsListSection.rawValue:
                FriendsNetworkManager.getFriends { (Bool) in
                    self.friendsList = FriendsNetworkManager.getFriendsForUser()
                    self.tableView.reloadData()
                    self.hideLoadingView()
                }
            
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
        
        if self.type?.rawValue == FriendsListSectionType.FriendsListSection.rawValue {
            cell.hideAddFriendLabel()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        if self.type?.rawValue == FriendsListSectionType.FriendsListSection.rawValue && self.isSelection == false {
            return
        }
        
        guard let friendsList = self.friendsList else {
            return
        }
        
        let friend = friendsList[indexPath.row]
        
        if (self.isSelection ?? false){
            self.selectedSet?.insert(friend)
            return
        }
        
        
        self.showLoadingView()
        Helper.showAlertWithBoolCompletion(viewController: self, title: "Add Friend", message: "Do you want to add \(friend.username) as a Friend?") { (Bool) in
            if (Bool){
                let parameters = [
                    "fromUser":friend.pk] as [String : AnyObject]
                
                FriendsNetworkManager.acceptFriendRequest(parameters: parameters) { (Bool) in
                    self.tableView.reloadData()
                    self.hideLoadingView()
                }
            }
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        guard let friendsList = self.friendsList else {
            return
        }
        
        let friend = friendsList[indexPath.row]
        
        if (self.isSelection ?? false){
            self.selectedSet?.remove(friend)
            return
        }
    }
    
    @IBAction func addFriendToChallenge(_ sender: Any) {
        
        self.delegate?.returnWithUsers(users: self.selectedSet)
        self.navigationController?.popViewController(animated: true)
    }
    
    
}

protocol FriendsListViewControllerDelegate : class {
    func returnWithUsers(users : Set<User>?)
}

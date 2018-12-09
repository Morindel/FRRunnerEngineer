//
//  DistanceChallengeViewController.swift
//  FrRunner
//
//  Created by Jakub Kołodziej on 02/12/2018.
//  Copyright © 2018 Jakub Kołodziej. All rights reserved.
//

import UIKit
import CoreData

class DistanceChallengeViewController: BaseController, FriendsListViewControllerDelegate {
    
    @IBOutlet weak var dateTextField: UITextField!
    
    @IBOutlet weak var friendsListTextField: UITextField!
    
    private var datePicker : UIDatePicker?
    
    private let dateFormatter = DateFormatter()
    
    private var date : Date?
    
    private var usersSet : Set<User>?
    
    private var friendDic : [String:Any]?
    
    private var userArray = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        self.date = Date.init()
        
        self.usersSet = Set.init()
        
        self.setupDatePicker()
        self.setupTextField()
    }
    
    
    func setupDatePicker(){
        self.datePicker = UIDatePicker()
        self.datePicker?.datePickerMode = .date
        self.datePicker?.addTarget(self, action: #selector(self.dateChanged(datePicker:)), for: .valueChanged)
        
        self.datePicker?.minimumDate = Date.init()
    }
    
    func setupTextField(){
        self.dateTextField.inputView = datePicker
        self.dateTextField.text = dateFormatter.string(from: Date.init())

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.viewTapped(gestureRecognizer:)))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func viewTapped(gestureRecognizer : UITapGestureRecognizer){
        view.endEditing(true)
    }
    
    @objc func dateChanged(datePicker: UIDatePicker){
        
        self.dateTextField.text = dateFormatter.string(from: datePicker.date)
        self.date = datePicker.date
        
    }
    
    @IBAction func AddFriendToRunButtonClicked(_ sender: Any) {
        
        let vc : FriendsListViewController = FriendsListViewController.newInstanceWithSelectFriends() as! FriendsListViewController
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func returnWithUsers(users: Set<User>?) {
        
        self.userArray.removeAll()
        
        guard let users = users else {
            return
        }
        
        self.usersSet = users
        var usernameArray = [String]()
        for user in users{
            userArray.append(user)
            usernameArray.append(user.username)
        }
        
        self.friendsListTextField.text = usernameArray.joined(separator: ", ")
        
        self.friendDic = [String:Any].init()
        
        self.friendDic = Dictionary(grouping: userArray,
                                                                                    by: { item in item.username })
        
    }
    
    @IBAction func createEventButtonClicked(_ sender: Any) {
        let newChallenge = DateChallenge(context: CoreDataStack.context)
        newChallenge.distance = 10.0
        newChallenge.challengeDate = Date.init()
        
        for user in userArray {
            
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "UserModel")
            let predicate = NSPredicate.init(format: "username == %@", user.username)
            
            fetchRequest.predicate = predicate
            
            do{
                let fetchResults = try CoreDataStack.context.fetch(fetchRequest) as? [NSManagedObject]
                let newUser = fetchResults?.first as! UserModel
                
                newChallenge.addToUsers(newUser)
                
            }catch (let error){
                    print(error)
                }
        }
        
        CoreDataStack.saveContext()
        
        Helper.showAlertWithCompletionController(viewController: self, title: "Created", message: "Challenge created")
        
        self.navigationController?.popToViewController(self, animated: true)
    }
    
    
    

    
}

//
//  OneRunChallengeViewController.swift
//  FrRunner
//
//  Created by Jakub Kołodziej on 11/12/2018.
//  Copyright © 2018 Jakub Kołodziej. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import MapKit

class OneRunChallengeViewController : BaseController, FriendsListViewControllerDelegate, ChooseLocationViewControllerDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var friendsListTextField: UITextField!
    @IBOutlet weak var tittleTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    
    @IBOutlet weak var descriptionTextView: UITextView!
    
    private var datePicker : UIDatePicker?
    private let dateFormatter = DateFormatter()
    private var date : Date?
    
    private var usersSet : Set<User>?
    private var friendDic : [String:Any]?
    private var userArray = [User]()
    
    private var latitude : Double?
    private var longitude : Double?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:UIResponder.keyboardWillHideNotification, object: nil)
        
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        self.date = Date.init()
        
        self.usersSet = Set.init()
        
        self.setupDatePicker()
        self.setupTextField()
    }
    
    //MARK : Setup
    
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
    
    //MARK : Button actions
    
    
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
    
    @IBAction func selectLocationButtonClicked(_ sender: Any) {
        if let longitude = self.longitude, let latitude = self.latitude{
            let vc = ChooseLocationViewController.newInstanceWithLocation(coordinate: CLLocationCoordinate2D(latitude: latitude , longitude: longitude)) as! ChooseLocationViewController
            vc.delegate = self
            
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            let vc = ChooseLocationViewController.newInstance() as! ChooseLocationViewController
            vc.delegate = self
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    @IBAction func createEventButtonClicked(_ sender: Any) {
        
        if (dateTextField.text == "" || tittleTextField.text == ""){
            Helper.showAlert(viewController: self, title: "No data", message: "Please fill all text fields")
            return
        }
        
        guard let title = tittleTextField.text, let date = dateTextField.text else {
            Helper.showAlert(viewController: self, title: "No title", message: "Type title")
            return
        }
        
        guard let currentUser = UserDefaults.standard.string(forKey: "username") else {
            return
        }
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        
        let challengeDate = dateFormatter.date(from:date)
        
        let newChallenge = DateChallenge(context: CoreDataStack.context)
        newChallenge.challengeDate = challengeDate
        newChallenge.title = title
        newChallenge.type = "S"
        newChallenge.challengeDescription = descriptionTextView.text ?? "No description"
        newChallenge.createdDate = Date.init()
        newChallenge.latitude = self.latitude ?? 0.0
        newChallenge.longitude = self.longitude ?? 0.0
        newChallenge.isEnded = false
        
        if let username = UserDefaults.standard.string(forKey: "username") {
            newChallenge.createdBy = username
            
        }
        
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
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "UserModel")
        let predicate = NSPredicate.init(format: "username == %@", currentUser)
        
        fetchRequest.predicate = predicate
        
        do{
            let fetchResults = try CoreDataStack.context.fetch(fetchRequest) as? [NSManagedObject]
            let newUser = fetchResults?.first as! UserModel
            
            newChallenge.addToUsers(newUser)
            
        }catch (let error){
            print(error)
        }
        
        CoreDataStack.saveContext()
        
        Helper.showAlertWithCompletionController(viewController: self, title: "Created", message: "Challenge created")
        
        self.navigationController?.popToViewController(self, animated: true)
    }
    //MARK: ChooseLocationViewControllerDelegate
    
    func returnWithLocation(placeMark: CLPlacemark?) {
        guard let placeMark = placeMark else {
            return
        }
        
        var locationString = ""
        
        if let locality = placeMark.locality {
            locationString.append("City: \(locality) ")
        }
        if let thoroughfare = placeMark.thoroughfare {
            locationString.append("street: \(thoroughfare) ")
        }
        if let subThoroughfare = placeMark.subThoroughfare {
            locationString.append(subThoroughfare)
        }
        
        locationTextField.text = locationString

        self.longitude = placeMark.location?.coordinate.longitude
        self.latitude = placeMark.location?.coordinate.latitude
    }
    
    //MARK: Keyboard
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc func keyboardWillShow(notification:NSNotification){
        
        var userInfo = notification.userInfo!
        var keyboardFrame:CGRect = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        
        var contentInset:UIEdgeInsets = self.scrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height
        scrollView.contentInset = contentInset
    }
    
    @objc func keyboardWillHide(notification:NSNotification){
        
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        scrollView.contentInset = contentInset
    }
    
    
    
}

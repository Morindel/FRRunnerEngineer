//
//  CreateEventViewController.swift
//  FrRunner
//

//  Created by Jakub Kołodziej on 15.09.2018.
//  Copyright © 2018 Jakub Kołodziej. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import CoreLocation

class CreateEventViewController: UIViewController,UITextFieldDelegate, ChooseLocationViewControllerDelegate{
    
    private var placeMark : CLPlacemark?
    
    @IBOutlet weak var eventNameTextField: UITextField!
    @IBOutlet weak var placeTextField: UITextField!
    @IBOutlet weak var distanceTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    
    @IBOutlet weak var descriptionTextView: UITextView!
    
    private var eventName : String?
    private var distance : Double?
    private var locationName : String?
    private var date : Date?
    private var eventDescription: String?
    
    private var latitude : Double?
    private var longitude : Double?
    
    private var datePicker : UIDatePicker?
    
    private let dateFormatter = DateFormatter()
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    static func newInstanceWithEvent(event:EventModel) -> UIViewController{
        let storyboard = UIStoryboard(name: "CreateEvent", bundle: nil)
        
        guard let viewController = storyboard.instantiateViewController(withIdentifier: "CreateEventViewController") as? CreateEventViewController else {
            return UIViewController()
        }
        
 
        
        viewController.distance = event.distance
        viewController.eventName = event.title
        viewController.date = event.date
        viewController.locationName = event.locationName
        viewController.latitude = event.latitude
        viewController.longitude = event.longitude
        viewController.eventDescription = event.eventDescription
        
        return viewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:UIResponder.keyboardWillHideNotification, object: nil)
        
        self.setupDatePicker()
        self.setupTextField()
        self.setText()
    }
    
    //
    //MARK:SETUP
    //
    
    func setupTextField(){
        self.dateTextField.inputView = datePicker
        self.dateTextField.text = dateFormatter.string(from: Date.init())
        
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        self.distanceTextField.delegate = self
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.viewTapped(gestureRecognizer:)))
        view.addGestureRecognizer(tapGesture)
    }
    
    func setupDatePicker(){
    self.datePicker = UIDatePicker()
    self.datePicker?.datePickerMode = .date
    self.datePicker?.addTarget(self, action: #selector(self.dateChanged(datePicker:)), for: .valueChanged)
    
    }
    
    func setText(){
        self.eventNameTextField.text = self.eventName
        self.distanceTextField.text = String(
            "\(self.distance ?? 0.000)")
        self.placeTextField.text = self.locationName
        
        if let datee = self.date{
            let tempDate = dateFormatter.string(from: datee)
            self.dateTextField.text = tempDate
            
        }
        
        self.descriptionTextView.text = self.eventDescription
    }
   
    //
    //MARK:ACTIONS
    //
    
    @objc func viewTapped(gestureRecognizer : UITapGestureRecognizer){
        view.endEditing(true)
    }
    
    @objc func dateChanged(datePicker: UIDatePicker){
        
        self.dateTextField.text = dateFormatter.string(from: datePicker.date)
        self.date = datePicker.date
    }
    
    func setEventLocation(placeMark: CLPlacemark?) {
        guard let placeMark = placeMark else {
            return
        }
        
        placeTextField.text =
        " \(placeMark.thoroughfare ?? "") \(placeMark.subThoroughfare ?? "")"
        
        self.placeMark = placeMark
        
        self.longitude = placeMark.location?.coordinate.longitude
        self.latitude = placeMark.location?.coordinate.latitude
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
    
    @IBAction func addAnEventButtonClicked(_ sender: Any) {
        guard let title = self.eventNameTextField.text, let distance = self.distanceTextField.text, let stringDate = self.dateTextField.text, let place = placeTextField.text else {
            return
        }

        if title.isEmpty || distance.isEmpty || stringDate.isEmpty || place.isEmpty {
            
            let alertController = UIAlertController(title: "Empty data", message: "Please fill all text fields", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true)
            
            return
        }
        
        guard let username = UserDefaults.standard.string(forKey: "username") else {
            return
        }
        
        let parameters = [
            "title":title,
            "createdBy":username,
            "distance":distance,
            "eventDescription":self.descriptionTextView.text,
            "date":stringDate,
            "locationName":place,
            "longitude":self.longitude ?? 0.0,
            "latitude":self.latitude ?? 0.0] as [String : AnyObject]
        EventsNetworkManager.createEvent(parameters:parameters) { isCreated in
            
            if(isCreated){
                Helper.showAlertWithCompletionController(viewController: self, title: "Event created", message: "Event created successfully")
                
            } else {
                Helper.showAlertWithCompletionController(viewController: self, title: "Event not created", message: "Event couldn't be created")
            }
        }
    }
    
    //MARK : keyboard
    
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

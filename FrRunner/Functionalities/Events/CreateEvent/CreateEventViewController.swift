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
    
    private var eventName : String?
    private var distance : String?
    
    private var locationName : String?
    private var date : Date?
    
    
    private var latitude : Double?
    private var longitude : Double?
    
    private var datePicker : UIDatePicker?
    
    private let dateFormatter = DateFormatter()
    
    static func newInstanceWithEvent(event:Event) -> UIViewController{
        let storyboard = UIStoryboard(name: "CreateEvent", bundle: nil)
        
        guard let viewController = storyboard.instantiateViewController(withIdentifier: "CreateEventViewController") as? CreateEventViewController else {
            return UIViewController()
        }
        
        viewController.eventName = event.name
        viewController.distance = event.distance
        viewController.date = event.date
        viewController.locationName = event.locationName
        viewController.latitude = event.latitude
        viewController.longitude = event.longitude
        
        return viewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
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
        self.distanceTextField.text = self.distance
        self.placeTextField.text = self.locationName
        
        if let datee = self.date{
            let tempDate = dateFormatter.string(from: datee)
            self.dateTextField.text = tempDate
            
        }
    }
   
    //
    //MARK:ACTIONS
    //
    
    @objc func viewTapped(gestureRecognizer : UITapGestureRecognizer){
        view.endEditing(true)
    }
    
    @objc func dateChanged(datePicker: UIDatePicker){
        
        self.dateTextField.text = dateFormatter.string(from: datePicker.date)
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
        let vc = UIStoryboard.init(name: "ChooseLocation", bundle: Bundle.main).instantiateViewController(withIdentifier: "ChooseLocationViewController") as! ChooseLocationViewController
        
        vc.delegate = self
        
        self.navigationController?.pushViewController(vc, animated: true)
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
        
        let parameters = [
            "title":title,
            "distance":distance,
            "date":stringDate,
            "locationName":place,
            "longitude":self.longitude ?? 0.0,
            "latitude":self.latitude ?? 0.0] as [String : AnyObject]
        EventsNetworkManager.createEvent(parameters:parameters) { (Bool) in
            self.navigationController?.popViewController(animated: true)
        }
    }
    
}

extension DateFormatter {
    func convertDateFormater(_ date: String) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss z"
        let date = dateFormatter.date(from: date)
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return  dateFormatter.string(from: date!)
        
    }
}

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

class CreateEventViewController: UIViewController,UITextFieldDelegate, ChooseLocationViewControllerDelegate{
    
    private var placeMark : CLPlacemark?
    
    @IBOutlet weak var eventNameTextField: UITextField!
    @IBOutlet weak var placeTextField: UITextField!
    @IBOutlet weak var distanceTextField: UITextField!
    
    var latitude : Double?
    var longitude : Double?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        distanceTextField.delegate = self;
        
        self.distanceTextField.keyboardType = UIKeyboardType.decimalPad
//        distanceTextField.addTarget(self, action: NSSelectorFromString("textFieldChanged:"), for: UIControl.Event.editingChanged)
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
    
    @IBAction func chooseLocationButtonClicked(_ sender: Any) {
        let vc = UIStoryboard.init(name: "BaseView", bundle: Bundle.main).instantiateViewController(withIdentifier: "ChooseLocationViewController") as! ChooseLocationViewController
        
        vc.delegate = self
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        if textField == distanceTextField {
            let allowedCharacters = CharacterSet.decimalDigits 
            let characterSet = CharacterSet(charactersIn: string)
            return allowedCharacters.isSuperset(of: characterSet)
        }
        
        return true;
    }
    
    @IBAction func addAnEventButtonClicked(_ sender: Any) {
//        if let url = URL(string: "https://www.facebook.com/events/611308399288386/") {
//            do {
//                let contents = try String(contentsOf: url)
//                print(contents)
//            } catch {
//                // contents could not be loaded
//            }
//        } else {
//            // the URL was bad!
//        }
        
        
        let parameters = ["code":eventNameTextField.text ?? "",
            "title":"test",
            "longitude":self.longitude ?? 0.0,
            "latitude":self.latitude ?? 0.0] as [String : AnyObject]
        EventsNetworkManager.createEvent(parameters:parameters) { (Bool) in
            print("ok")
        }
    }
    
}

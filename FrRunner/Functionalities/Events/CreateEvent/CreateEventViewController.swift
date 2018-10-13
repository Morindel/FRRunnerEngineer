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
    
    @IBOutlet weak var placeTextField: UITextField!
    @IBOutlet weak var distanceTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        distanceTextField.delegate = self;
//        distanceTextField.addTarget(self, action: NSSelectorFromString("textFieldChanged:"), for: UIControl.Event.editingChanged)
    }
    
    func setEventLocation(placeMark: CLPlacemark?) {
        guard let placeMark = placeMark else {
            return
        }
        
        placeTextField.text =
        " \(placeMark.thoroughfare ?? "") \(placeMark.subThoroughfare ?? "")"
        
        self.placeMark = placeMark
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
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        if textField == distanceTextField {
         textField.text = " \(textField.text ?? "") km"
        }
    }

    func textFieldChanged(textField: UITextField) {
        
        if textField.text != "" {
            textField.text = " LBS"
        }
    }
}

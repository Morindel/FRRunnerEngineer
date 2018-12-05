//
//  DistanceChallengeViewController.swift
//  FrRunner
//
//  Created by Jakub Kołodziej on 02/12/2018.
//  Copyright © 2018 Jakub Kołodziej. All rights reserved.
//

import UIKit

class DistanceChallengeViewController: BaseController {
    
    
    @IBOutlet weak var dateTextField: UITextField!
    
    
    private var datePicker : UIDatePicker?
    
    private let dateFormatter = DateFormatter()
    
    private var date : Date?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        self.date = Date.init()
        
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
    
}

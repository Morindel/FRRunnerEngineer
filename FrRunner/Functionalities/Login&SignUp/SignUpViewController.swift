//
//  SignUpViewController.swift
//  FrRunner
//
//  Created by Jakub Kołodziej on 16.08.2018.
//  Copyright © 2018 Jakub Kołodziej. All rights reserved.
//


import Foundation
import UIKit
import Firebase
class SignUpViewController: UIViewController {
    
    
    @IBOutlet weak var email: UITextField!
    
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var confirmPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:Actions
    
    
    @IBAction func signUpButtonClicked(_ sender: Any) {
        
        if password.text != confirmPassword.text{
            let alertController = UIAlertController(title: "Password Incorrect", message: "Please re-type password", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
        }
        else {
            
        }
    }
}

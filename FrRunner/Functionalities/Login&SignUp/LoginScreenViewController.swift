//
//  LoginScreenViewController.swift
//  FrRunner
//
//  Created by Jakub Kołodziej on 16.07.2018.
//  Copyright © 2018 Jakub Kołodziej. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth

class LoginScreenViewController: UIViewController {

    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    override func viewWillAppear(_ animated: Bool) {
//        if Auth.auth().currentUser != nil {
//            let mainStoryboard : UIStoryboard = UIStoryboard(name: "BaseView", bundle: nil)
//            let vc : UIViewController = mainStoryboard.instantiateViewController(withIdentifier: "BaseView")
//            self.present(vc, animated: true, completion: nil);
//        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
 
    @IBAction func showBaseViewController(_ sender: Any) {
        
        Auth.auth().signIn(withEmail: email.text!, password: password.text!) { (user, error) in
            if error == nil{
                let mainStoryboard : UIStoryboard = UIStoryboard(name: "BaseView", bundle: nil)
                let vc : UIViewController = mainStoryboard.instantiateViewController(withIdentifier: "BaseView")
                self.present(vc, animated: true, completion: nil);
            }
            else{
                let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                
                alertController.addAction(defaultAction)
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
}

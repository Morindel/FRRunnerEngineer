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
import Alamofire

class LoginScreenViewController: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    override func viewWillAppear(_ animated: Bool) {
        //        if Auth.auth().currentUser != nil {
        //            let mainStoryboard : UIStoryboard = UIStoryboard(name: "BaseView", bundle: nil)
        //            let vc : UIViewController = mainStoryboard.instantiateViewController(withIdentifier: "BaseView")
        //            self.present(vc, animated: true, completion: nil);
        //        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        usernameTextField.delegate = self
        passwordTextField.delegate = self
        
        if let data = UserDefaults.standard.data(forKey: "user") {
            didLogin(userData: data)
        }  
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //    @IBAction func showBaseViewController(_ sender: Any) {
    //
    //        Auth.auth().signIn(withEmail: email.text!, password: password.text!) { (user, error) in
    //            if error == nil{
    //                let mainStoryboard : UIStoryboard = UIStoryboard(name: "BaseView", bundle: nil)
    //                let vc : UIViewController = mainStoryboard.instantiateViewController(withIdentifier: "BaseView")
    //                self.present(vc, animated: true, completion: nil);
    //            }
    //            else{
    //                let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
    //                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
    //
    //                alertController.addAction(defaultAction)
    //                self.present(alertController, animated: true, completion: nil)
    //            }
    //        }
    //    }
    /*Perform actions when the return key is pressed*/
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == usernameTextField {
            //change cursor from username to password textfield
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
            //attempt to login when we press enter on password field
            login(username: self.usernameTextField.text!, password: self.passwordTextField.text!)
        }
        return true
    }
    
    /*Login with username and password*/
    func login(username:String,password:String) {
        let params = ["username":username,"password":password] as [String:Any]
        Alamofire.request(API_HOST+"/auth/login",method:.post,parameters:params).responseData
            { response in switch response.result {
            case .success(let data):
                switch response.response?.statusCode ?? -1 {
                case 200:
                    self.didLogin(userData: data)
                case 401:
                    Helper.showAlert(viewController: self, title: "Oops", message: "Username or Password Incorrect")
                default:
                    Helper.showAlert(viewController: self, title: "Oops", message: "Unexpected Error")
                }
            case .failure(let error):
                Helper.showAlert(viewController: self,title: "Oops!",message: error.localizedDescription)
                }
        }
    }
    
    /*User login was successful
     - we segue to inbox and initialize User.current*/
    func didLogin(userData:Data) {
        do {
            //decode data into user object
            User.current = try JSONDecoder().decode(User.self, from: userData)
            usernameTextField.text = ""
            passwordTextField.text = ""
            self.view.endEditing(false)
            let mainStoryboard : UIStoryboard = UIStoryboard(name: "BaseView", bundle: nil)
            let vc : UIViewController = mainStoryboard.instantiateViewController(withIdentifier: "BaseView")
            self.present(vc, animated: true, completion: nil);
            
        } catch {
            Helper.showAlert(viewController: self,title: "Oops!",message: error.localizedDescription)
        }
    }
}

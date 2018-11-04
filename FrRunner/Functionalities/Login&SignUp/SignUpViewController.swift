//
//  SignUpViewController.swift
//  FrRunner
//
//  Created by Jakub Kołodziej on 16.08.2018.
//  Copyright © 2018 Jakub Kołodziej. All rights reserved.
//


import Foundation
import UIKit
import FirebaseAuth
import Alamofire
class SignUpViewController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var email: UITextField!
    
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var confirmPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        email.delegate = self
        password.delegate = self
        confirmPassword.delegate = self
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:Actions
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == email {
            confirmPassword.becomeFirstResponder()
        } else if textField == confirmPassword {
            if password.text != confirmPassword.text{
                let alertController = UIAlertController(title: "Password Incorrect", message: "Please re-type password", preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                
                alertController.addAction(defaultAction)
                self.present(alertController, animated: true, completion: nil)
            } else {
                signUp(username: email.text!, password: confirmPassword.text!)
            }
        }
        return true
    }
    
    /*Signup with username and password*/
    func signUp(username:String,password:String) {
        let params = ["username":username,"password":password] as [String:Any]
        Alamofire.request(API_HOST+"auth/signup",method:.post,parameters:params).responseData
            { response in switch response.result {
            case .success(let data):
                switch response.response?.statusCode ?? -1 {
                case 200:
                    do {
                        User.current = try JSONDecoder().decode(User.self, from: data)
                        self.email.text = ""
                        self.confirmPassword.text = ""
                        let mainStoryboard : UIStoryboard = UIStoryboard(name: "BaseView", bundle: nil)
                        let vc : UIViewController = mainStoryboard.instantiateViewController(withIdentifier: "BaseView")
                        self.present(vc, animated: true, completion: nil);
                    } catch {
                        Helper.showAlert(viewController: self,title: "Oops!",message: error.localizedDescription)
                    }
                case 401:
                    Helper.showAlert(viewController: self, title: "Oops", message: "Username Taken")
                default:
                    Helper.showAlert(viewController: self, title: "Oops", message: "Unexpected Error")
                }
            case .failure(let error):
                Helper.showAlert(viewController: self,title: "Oops!",message: error.localizedDescription)
                }
        }
    }
    
}


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
    
    
    //    override func viewWillAppear(_ animated: Bool) {
    //                if isLoggedIn(){
    //                    let mainStoryboard : UIStoryboard = UIStoryboard(name: "BaseView", bundle: nil)
    //                    let vc : UIViewController = mainStoryboard.instantiateViewController(withIdentifier: "BaseView")
    //                    self.present(vc, animated: true, completion: nil);
    //                }
    //    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        usernameTextField.delegate = self
        passwordTextField.delegate = self
        
                 if isLoggedIn() {
                    didLogin()
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
        print(params)
        Alamofire.request(API_HOST+"/login",method:.post,parameters:params).responseJSON
            { response in switch response.result {
            case .success:
                switch response.response?.statusCode ?? -1 {
                case 200:
                    guard let data = response.data else {
                        return
                    }
                    print(response.value)
                    
                    do{
                        UserDefaults.standard.set(username,forKey:"username")
                    } catch(let error){
                        print(error)
                    }
                    
//                    print(UserDefaults.standard.g)
                    
                    LoginScreenViewController.getToken(params: params)
                    
                    self.didLogin()
                    
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
    
    func didLogin() {

            usernameTextField.text = ""
            passwordTextField.text = ""
            
            UserDefaults.standard.set(true, forKey: "isLoggedIn")
            UserDefaults.standard.synchronize()
            
            self.view.endEditing(false)
            let mainStoryboard : UIStoryboard = UIStoryboard(name: "BaseView", bundle: nil)
            let vc : UIViewController = mainStoryboard.instantiateViewController(withIdentifier: "BaseView")
            self.present(vc, animated: true, completion: nil)
//            self.dismiss(animated: false, completion: nil)
        
    }
    
    static func getToken(params:[String:Any]) {
        Alamofire.request(API_HOST+"/api-token-auth/",method:.post,parameters:params).responseJSON(completionHandler: { response in
            
            guard let data = response.data else{
                return
            }
            
            guard let token = try? JSONDecoder().decode(Token.self, from: data) else{
                print("No token")
                return
            }
            
            UserDefaults.standard.set(token.token, forKey: "token")
            
        })
        
    }
    
    private func isLoggedIn() -> Bool {
        return UserDefaults.standard.bool(forKey: "isLoggedIn")
    }
}

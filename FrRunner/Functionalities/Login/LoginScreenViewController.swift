//
//  LoginScreenViewController.swift
//  FrRunner
//
//  Created by Jakub Kołodziej on 16.07.2018.
//  Copyright © 2018 Jakub Kołodziej. All rights reserved.
//

import Foundation
import UIKit

class LoginScreenViewController: UIViewController {
    @IBOutlet weak var usernameTextLabel: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
 
    @IBAction func showBaseViewController(_ sender: Any) {
        
        let mainStoryboard : UIStoryboard = UIStoryboard(name: "BaseView", bundle: nil)
        let vc : UIViewController = mainStoryboard.instantiateViewController(withIdentifier: "BaseView")
        self.present(vc, animated: true, completion: nil);
       
    }
}

//
//  BaseViewController.swift
//  FrRunner
//
//  Created by Jakub Kołodziej on 17.07.2018.
//  Copyright © 2018 Jakub Kołodziej. All rights reserved.
//

import Foundation
import UIKit

class BaseViewController: UITabBarController {

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    
//        FriendsNetworkManager.getUsers { (Bool) in
//            print("done")
//        }
        print("test")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

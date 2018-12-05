//
//  Helper.swift
//  FrRunner
//
//  Created by Jakub Kołodziej on 03/11/2018.
//  Copyright © 2018 Jakub Kołodziej. All rights reserved.
//

import Foundation
import UIKit

class Helper {
    static func showAlert(viewController:UIViewController,title:String?,message:String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let dismiss = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(dismiss)
        viewController.present(alert, animated: true, completion: nil)
    }
    
    static func showAlertWithCompletionController(viewController:UIViewController,title:String?,message:String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let dismiss = UIAlertAction(title: "Ok", style: .default) { (UIAlertAction) in
            viewController.navigationController?.popToRootViewController(animated: true)
        }
        alert.addAction(dismiss)
        viewController.present(alert, animated: true, completion: nil)
    }
    
    static func showAlertWithBoolCompletion(viewController:UIViewController,title:String?,message:String?,completion: @escaping (Bool) ->Void) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "No",
                                      style: .cancel,
                                      handler: {Bool in completion(false)}))
        
        alert.addAction(UIAlertAction(title: "Yes",
                                      style: .default,
                                      handler: {Bool in completion(true)}))
        
        viewController.present(alert, animated: true, completion: nil)

    }
}

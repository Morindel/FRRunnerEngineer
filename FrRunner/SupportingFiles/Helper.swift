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
        let dismiss = UIAlertAction(title: "Dismiss", style: .default, handler: nil)
        alert.addAction(dismiss)
        viewController.present(alert, animated: true, completion: nil)
    }
}

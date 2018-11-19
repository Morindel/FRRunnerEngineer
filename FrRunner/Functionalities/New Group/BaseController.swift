//
//  BaseController.swift
//  FrRunner
//
//  Created by Jakub Kołodziej on 19/11/2018.
//  Copyright © 2018 Jakub Kołodziej. All rights reserved.
//

import Foundation
import UIKit

class BaseController: UIViewController {
    
var loadingView: LoadingView?

func showLoadingView() {
    if loadingView == nil {
        loadingView = LoadingView.showInView(self.view)
    }
}

func hideLoadingView() {
    if let loadingView = loadingView {
        loadingView.hide()
        self.loadingView = nil
    }
}

func wasSelectedInMenu() {
    
}

}

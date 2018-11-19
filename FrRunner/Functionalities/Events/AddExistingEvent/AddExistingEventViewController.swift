//
//  AddExistingEventViewController.swift
//  FrRunner
//
//  Created by Jakub Kołodziej on 09/11/2018.
//  Copyright © 2018 Jakub Kołodziej. All rights reserved.
//

import Foundation
import UIKit
import WebKit
import CoreLocation

class AddExistingEventViewController: BaseController {
    
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var selectRunButton: UIButton!
    
    private var date: String?
    private var eventName: String?
    private var distance: String?
    private var locationName : String?
    private var longitude: String?
    private var latitude: String?
    
    private let dateFormatter = DateFormatter()
    
    private let event = Event(context: CoreDataStack.context)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let urlString :String = "https://run-log.com/events/"
        let url:URL = URL(string: urlString)!
        let urlRequest = URLRequest(url:url)
        webView.load(urlRequest)
    }
    
    @IBAction func selectRunButtonClicked(_ sender: Any) {
        
//        selectRunButton.isEnabled = false
        self.showLoadingView()
        let dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter()
        webView.evaluateJavaScript("document.getElementsByClassName('value dtstart')[0].innerHTML") { (response, error) in
            if let dateResponse = response {
                self.date = dateResponse as? String
                self.dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
                if let date = self.date{
                    self.event.date = self.dateFormatter.date(from:date)}
                 dispatchGroup.leave()
            } else {
                Helper.showAlert(viewController: self, title: "Error"
                    , message: "No date available")
                 dispatchGroup.leave()
                return
            }
        }
        
        dispatchGroup.enter()
        webView.evaluateJavaScript("document.getElementsByClassName('summary')[0].innerHTML") { (response, error) in
            if let titleResponse = response {
                //                self.eventName = titleResponse as? String
                self.event.name = titleResponse as? String
                dispatchGroup.leave()
            } else {
                Helper.showAlert(viewController: self, title: "Error"
                    , message: "No title available")
                 dispatchGroup.leave()
                return
            }
        }
        
        dispatchGroup.enter()
        webView.evaluateJavaScript("document.getElementsByClassName('value')[1].innerHTML") { (response, error) in
            if let distance = response {
                self.distance = distance as? String
                
                var distanceString = self.distance?.replacingOccurrences(of: "km", with: ".", options: .literal, range: nil)
                distanceString = distanceString?.replacingOccurrences(of: "m", with: "")
                distanceString = distanceString?.replacingOccurrences(of: " ", with: "")
                
                self.event.distance = distanceString
                 dispatchGroup.leave()
            } else {
                Helper.showAlert(viewController: self, title: "Error"
                    , message: "No distance available")
                 dispatchGroup.leave()
                return
            }
        }
        
        dispatchGroup.enter()
        webView.evaluateJavaScript("document.getElementsByClassName('value location_name')[0].innerHTML") { (response, error) in
            if let location = response {
                self.event.locationName = location as? String
                
                guard let locationName = self.event.locationName else {
                    Helper.showAlert(viewController: self, title: "Error"
                        , message: "No location available")
                    return
                }
                
                let geoCoder = CLGeocoder()
                geoCoder.geocodeAddressString(locationName) { (placemarks, error) in
                    guard let placemarks = placemarks,let location = placemarks.first?.location
                        else{
                            return
                    }
                        self.event.latitude = location.coordinate.latitude
                        self.event.longitude = location.coordinate.longitude
                        dispatchGroup.leave()
                    }

                
            } else {
                Helper.showAlert(viewController: self, title: "Error"
                    , message: "No location available")
                 dispatchGroup.leave()
                return
            }
            
        }
        
        dispatchGroup.notify(queue: DispatchQueue.main, execute: {
            let viewController = CreateEventViewController.newInstanceWithEvent(event: self.event)
            self.navigationController?.pushViewController(viewController, animated: true)
            self.hideLoadingView()
            self.selectRunButton.isEnabled = true
        })
        
        
    }
    
}


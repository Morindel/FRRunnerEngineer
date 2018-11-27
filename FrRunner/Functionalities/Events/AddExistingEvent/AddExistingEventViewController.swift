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

class AddExistingEventViewController: BaseController,WKNavigationDelegate {
    
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
        
        let urlString :String = "https://run-log.com/events/"
        guard let url = URL(string: urlString) else {
            return
        }
        let urlRequest = URLRequest(url:url)
        
        webView.navigationDelegate = self
        webView.load(urlRequest)
        
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        self.showLoadingView()
    }
    
    @IBAction func selectRunButtonClicked(_ sender: Any) {
        
        self.showLoadingView()
        
        let dispatchGroupDoc = DispatchGroup()
        
        dispatchGroupDoc.enter()
        
        var doc : String = ""
        webView.evaluateJavaScript("document.documentElement.outerHTML.toString()") { (htmlText, Error) in
            doc = htmlText as? String ?? "empty"
            dispatchGroupDoc.leave()
        }
        
        dispatchGroupDoc.notify(queue: DispatchQueue.main, execute: {
            
            let dispatchGroup = DispatchGroup()
            
            self.setTitle(dispatchGroup: dispatchGroup)
            self.setLocation(dispatchGroup: dispatchGroup)
            self.setDateFromDoc(passDocument: doc, dispatchGroup: dispatchGroup)
            self.setDistanceFromDoc(passDocument: doc, dispatchGroup: dispatchGroup)
            self.setDescriptionForEvent(dispatchGroup: dispatchGroup)

            dispatchGroup.notify(queue: DispatchQueue.main, execute: {
                let viewController = CreateEventViewController.newInstanceWithEvent(event: self.event)
                self.navigationController?.pushViewController(viewController, animated: true)
                self.hideLoadingView()
                self.selectRunButton.isEnabled = true
            })
            
            
        })
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.hideLoadingView()
    }
    
    
    //MARK - Parsers
    
    func setDateFromDoc(passDocument doc:String, dispatchGroup:DispatchGroup){
        
        dispatchGroup.enter()
        
        let regex = "class=\"([^\\s]+) ([^\\s]+)\">[0-9]{4}-[0-9]{2}-[0-9]{2}"
        let dateRegex = "[0-9]{4}-[0-9]{2}-[0-9]{2}"
        let regExpression = NSRegularExpression.init()
        
        self.date = regExpression.matches(for: dateRegex, in:(regExpression.matches(for: regex,in: doc).first ?? "")).first ?? ""
        self.dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        if let date = self.date {
            self.event.date = self.dateFormatter.date(from:date)
            dispatchGroup.leave()
        }
        else {
            Helper.showAlert(viewController: self, title: "Error"
                , message: "No date available")
            dispatchGroup.leave()
            return
        }
        
    }
    
    func setDistanceFromDoc(passDocument doc:String, dispatchGroup:DispatchGroup){
        
        dispatchGroup.enter()
        
        let regex = "class=\"([^\\s]+) ([^\\s]+)\">[0-9]{0,}km [0-9]{0,}m"
        let distanceRegex = "[0-9]{0,}km [0-9]{0,}m"
        let regExpression = NSRegularExpression.init()
        
        self.distance = regExpression.matches(for: distanceRegex, in:(regExpression.matches(for: regex,in: doc).first ?? "")).first ?? ""
        self.dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        
        var distanceString = self.distance?.replacingOccurrences(of: "km", with: ".", options: .literal, range: nil)
        distanceString = distanceString?.replacingOccurrences(of: "m", with: "")
        distanceString = distanceString?.replacingOccurrences(of: " ", with: "")
        
        self.event.distance = Double(distanceString ?? "") ?? 0.0
        dispatchGroup.leave()
    }
    
    func setLocation(dispatchGroup:DispatchGroup){
        
        dispatchGroup.enter()
        self.webView.evaluateJavaScript("document.getElementsByClassName('value location_name')[0].innerHTML") { (response, error) in
            if let location = response {
                self.event.locationName = location as? String
                
                guard let locationName = self.event.locationName else {
                    Helper.showAlert(viewController: self, title: "Error"
                        , message: "No location available")
                    dispatchGroup.leave()
                    return
                }
                
                let geoCoder = CLGeocoder()
                geoCoder.geocodeAddressString(locationName) { (placemarks, error) in
                    guard let placemarks = placemarks, let location = placemarks.first?.location
                        else {
                            dispatchGroup.leave()
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
    }
    
    func setTitle(dispatchGroup:DispatchGroup){
        
        dispatchGroup.enter()
        self.webView.evaluateJavaScript("document.getElementsByClassName('summary')[0].innerHTML") { (response, error) in
            if let titleResponse = response {
                self.event.name = titleResponse as? String
                dispatchGroup.leave()
            } else {
                Helper.showAlert(viewController: self, title: "Error"
                    , message: "No title available")
                dispatchGroup.leave()
                return
            }
        }
        
    }
    
    func setDescriptionForEvent(dispatchGroup:DispatchGroup) {
        
        dispatchGroup.enter()
        self.webView.evaluateJavaScript("document.getElementsByClassName('events_description')[0].getElementsByClassName('description')[0].innerHTML") { (response, error) in
            if let descriptionResponse = response {
                let htmlString = descriptionResponse as? String
                let description = htmlString?.replacingOccurrences(of: "<[^>]+>", with: "", options: String.CompareOptions.regularExpression, range: nil)
               
                self.event.eventDescription = description
                    
                dispatchGroup.leave()
            } else {
                dispatchGroup.leave()
                return
            }
        }
    }
    
    
}



//MARK : - OLD VERSION

//            self.webView.evaluateJavaScript("document.getElementsByClassName('value dtstart')[0].innerHTML") { (response, error) in
//                if let dateResponse = response {
//                    print(doc)
//                    self.date = dateResponse as? String
//                    self.dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
//                    if let date = self.date{
//                        self.event.date = self.dateFormatter.date(from:date)}
//                    dispatchGroup.leave()
//                } else {
//                    Helper.showAlert(viewController: self, title: "Error"
//                        , message: "No date available")
//                    dispatchGroup.leave()
//                    return
//                }
//            }


//dispatchGroup.enter()
//self.webView.evaluateJavaScript("document.getElementsByClassName('value')[1].innerHTML") { (response, error) in
//    if let distance = response {
//        self.distance = distance as? String
//
//        var distanceString = self.distance?.replacingOccurrences(of: "km", with: ".", options: .literal, range: nil)
//        distanceString = distanceString?.replacingOccurrences(of: "m", with: "")
//        distanceString = distanceString?.replacingOccurrences(of: " ", with: "")
//
//        self.event.distance = Double(distanceString ?? "") ?? 0.0
//        dispatchGroup.leave()
//    } else {
//        Helper.showAlert(viewController: self, title: "Error"
//            , message: "No distance available")
//        dispatchGroup.leave()
//        return
//    }
//}

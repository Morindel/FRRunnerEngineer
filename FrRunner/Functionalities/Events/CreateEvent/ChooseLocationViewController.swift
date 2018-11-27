//
//  ChooseLocationViewController.swift
//  FrRunner
//
//  Created by Jakub Kołodziej on 15.09.2018.
//  Copyright © 2018 Jakub Kołodziej. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class ChooseLocationViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate{
    
    @IBOutlet weak var map: MKMapView!
    
    var delegate  : ChooseLocationViewControllerDelegate?
    
    var coordinate : CLLocationCoordinate2D?
    var annotation : MKPointAnnotation?
    let locationManager = CLLocationManager()
    
    static func newInstance() -> UIViewController{
        let storyboard = UIStoryboard(name: "ChooseLocation", bundle: nil)
        
        guard let viewController = storyboard.instantiateViewController(withIdentifier: "ChooseLocationViewController") as? ChooseLocationViewController else {
            return UIViewController()
        }

        return viewController
    }
    
    static func newInstanceWithLocation(coordinate:CLLocationCoordinate2D) -> UIViewController{
        let storyboard = UIStoryboard(name: "ChooseLocation", bundle: nil)
        
        guard let viewController = storyboard.instantiateViewController(withIdentifier: "ChooseLocationViewController") as? ChooseLocationViewController else {
            return UIViewController()
        }
        
        viewController.coordinate = coordinate
        return viewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.annotation = MKPointAnnotation()
        
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        // Check for Location Services
        if (CLLocationManager.locationServicesEnabled()) {
            self.locationManager.requestAlwaysAuthorization()
            self.locationManager.requestWhenInUseAuthorization()
        }
        
        if let userLocation = self.locationManager.location?.coordinate {
            let viewRegion = MKCoordinateRegion.init(center: userLocation, latitudinalMeters: 200, longitudinalMeters: 200)
            map.setRegion(viewRegion, animated: false)
        }
        
        
        DispatchQueue.main.async {
            self.locationManager.startUpdatingLocation()
        }
        
        guard let coordinate = self.coordinate else {
            return
        }
        
        self.map.setCenter(coordinate, animated: false)
        
    }
    
    
    @IBAction func locationSelected(_ sender: UILongPressGestureRecognizer) {
        if sender.state != UIGestureRecognizer.State.began { return }
        
        let touchLocation = sender.location(in: map)
        let locationCoordinate = map.convert(touchLocation, toCoordinateFrom: map)
        
        annotation?.coordinate = locationCoordinate
        if let annotation = self.annotation{
            map.addAnnotation(annotation)
        }
        
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: locationCoordinate.latitude, longitude: locationCoordinate.longitude)
        map.setCenter(locationCoordinate, animated: true)
        
        geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
            
            // Place details
            var placeMark: CLPlacemark!
            placeMark = placemarks?[0]
            
            // Address dictionary
            //            print(placeMark.addressDictionary ?? <#default value#>)
            
            
            self.setEventLocation(placeMark: placeMark)
            
            //            print(locationName)
            
        })
    }
    
    func setEventLocation(placeMark:CLPlacemark?) {
        
        let eventLocationName = " \(placeMark?.thoroughfare ?? "") \(placeMark?.subThoroughfare ?? "")"
        
        let alertController = UIAlertController(title: "Save location", message: "Do you want to save \(eventLocationName) as your event location?", preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alertController.addAction(UIAlertAction(title: "Save", style: .default) { _ in
            self.delegate?.setEventLocation(placeMark: placeMark ?? nil)
            self.navigationController?.popViewController(animated: true)
        })
        
        present(alertController, animated: true)
    }
    
}

protocol ChooseLocationViewControllerDelegate : class {
    func setEventLocation(placeMark : CLPlacemark?)
}

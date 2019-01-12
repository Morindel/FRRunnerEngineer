//
//  ChallengeListMapTableViewCell.swift
//  FrRunner
//
//  Created by Jakub Kołodziej on 11/12/2018.
//  Copyright © 2018 Jakub Kołodziej. All rights reserved.
//

import UIKit
import MapKit

class ChallengeListMapTableViewCell: ChallengeListBaseTableViewCell {

    @IBOutlet weak var mapView: MKMapView!
    var mapRegion : MKCoordinateRegion?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    override func loadWithChallenge(challenge: DateChallenge){
        
        let latitude = challenge.latitude
        let longitude = challenge.longitude
        
        let eventCoordinate = CLLocationCoordinate2DMake(latitude, longitude)
        
        self.mapView.setCenter(eventCoordinate, animated: false)
        
        let span = MKCoordinateSpan.init(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let region = MKCoordinateRegion.init(center: eventCoordinate, span: span)
        self.mapView.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation.init()
        annotation.coordinate = eventCoordinate
        
        self.mapView.addAnnotation(annotation)
    }
    
}

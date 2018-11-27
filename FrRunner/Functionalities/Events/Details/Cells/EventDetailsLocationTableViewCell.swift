//
//  EventDetailsLocationTableViewCell.swift
//  FrRunner
//
//  Created by Jakub Kołodziej on 26/11/2018.
//  Copyright © 2018 Jakub Kołodziej. All rights reserved.
//

import UIKit
import MapKit

class EventDetailsLocationTableViewCell: EventDetailsBaseTableViewCell {

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
    
    override func loadWithEvent(event: Event){
        self.mapView.setCenter(CLLocationCoordinate2DMake(event.latitude, event.longitude), animated: false)
        
        let eventCoordinate = CLLocationCoordinate2DMake(event.latitude, event.longitude)
    
        mapRegion = MKCoordinateRegion.init(center: eventCoordinate , span: MKCoordinateSpan.init(latitudeDelta: 0.2, longitudeDelta: 0.2))
        
        guard let mapRegion = mapRegion else { return }
        self.mapView.setRegion(mapRegion, animated: true)
        
        let annotation = MKPointAnnotation.init()
        annotation.coordinate = eventCoordinate
        
        self.mapView.addAnnotation(annotation)
    }
    
}

//
//  RunsHistoryTableViewCell.swift
//  FrRunner
//
//  Created by Jakub Kołodziej on 14.08.2018.
//  Copyright © 2018 Jakub Kołodziej. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class RunsHistoryTableViewCell : UITableViewCell {
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var distanceLabel: UILabel!
    
    @IBOutlet weak var paceLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    private var run : Run!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        mapView.delegate = self
    }
    
    func setRun(run: Run) -> Void{
        
        self.run = run
        
        let distance = Measurement(value: run.distance, unit: UnitLength.meters)
        let seconds = Int(run.duration)
        let formattedDistance = FormatDisplay.distance(distance)
        let formattedDate = FormatDisplay.date(run.timeStamp)
        let formattedTime = FormatDisplay.time(seconds)
        let formattedPace = FormatDisplay.pace(distance: distance,
                                               seconds: seconds,
                                               outputUnit: UnitSpeed.minutesPerKilometer)
        
        
        distanceLabel.text = formattedDistance
        paceLabel.text = formattedPace
        timeLabel.text = formattedTime
        dateLabel.text = formattedDate
        
        loadMap()
        // MARK : TODO)
    }

//MARK: MapView
private func mapRegion() -> MKCoordinateRegion? {

    guard
        let locations = run.locations,
        locations.count > 0
        else {
            return nil
    }
    
    let latitudes = locations.map { location -> Double in
        let location = location as! Location
        return location.latitude
    }
    
    let longitudes = locations.map { location -> Double in
        let location = location as! Location
        return location.longitude
    }
    
    let maxLat = latitudes.max()!
    let minLat = latitudes.min()!
    let maxLong = longitudes.max()!
    let minLong = longitudes.min()!
    
    let center = CLLocationCoordinate2D(latitude: (minLat + maxLat) / 2,
                                        longitude: (minLong + maxLong) / 2)
    let span = MKCoordinateSpan(latitudeDelta: (maxLat - minLat) * 2,
                                longitudeDelta: (maxLong - minLong) * 2)
    return MKCoordinateRegion(center: center, span: span)
}

private func polyLine() -> MKPolyline {
    guard let locations = run.locations else {
        return MKPolyline()
    }
    
    let coords: [CLLocationCoordinate2D] = locations.map { location in
        let location = location as! Location
        return CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
    }
    return MKPolyline(coordinates: coords, count: coords.count)
}

private func loadMap() {
    guard
        let locations = run.locations,
        locations.count > 0,
        let region = mapRegion()
        else {

            return
    }
    
    mapView.setRegion(region, animated: true)
    mapView.addOverlay(polyLine())
}
    
}
extension RunsHistoryTableViewCell: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        guard let polyline = overlay as? MKPolyline else {
            return MKOverlayRenderer(overlay: overlay)
        }
        let renderer = MKPolylineRenderer(polyline: polyline)
        renderer.strokeColor = .blue
        renderer.lineWidth = 1
        return renderer
    }
}


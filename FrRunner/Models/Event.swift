//
//  Event.swift
//  FrRunner
//
//  Created by Jakub Kołodziej on 27/11/2018.
//  Copyright © 2018 Jakub Kołodziej. All rights reserved.
//

import Foundation

struct EventModel:Codable {
    var title : String?
    var locationName : String?
    var eventDescription : String?
    var latitude : Double?
    var longitude : Double?
    var distance : Double?
    var date : Date?
    var createdBy : String?
}

//
//  Branch.swift
//  Branch Locator
//
//  Created by Matthew Jennell on 4/1/17.
//  Copyright © 2017 Matt Jennell. All rights reserved.
//

import Foundation
import MapKit

// Data associated with a branch
class Branch: NSObject, MKAnnotation {
    var state: String
    var type: String
    var label: String
    var address: String
    var city: String
    var zip: String
    var name: String
    var lat: String
    var lng: String
    var bank: String
    var branchType: String
    var lobbyHours: [String]
    var driveHours: [String]
    var atms: Int
    var services: [String]
    var access: String
    var phone: String
    var distance: Double
    var coordinate: CLLocationCoordinate2D
    
    init(state: String, type: String, label: String, address: String, city: String, zip: String, name: String, lat: String, lng: String, bank: String, branchType: String, lobbyHours: [String], driveHours: [String], atms: Int, services: [String], access: String, phone: String, distance: Double) {
        self.state = state
        self.type = type
        self.label = label
        self.address = address
        self.city = city
        self.zip = zip
        self.name = name
        self.lat = lat
        self.lng = lng
        self.bank = bank
        self.branchType = branchType
        self.lobbyHours = lobbyHours
        self.driveHours = driveHours
        self.atms = atms
        self.services = services
        self.access = access
        self.phone = phone
        self.distance = distance
        self.coordinate = CLLocationCoordinate2D(latitude: Double(lat) ?? 0.0, longitude: Double(lng) ?? 0.0)
    }
}

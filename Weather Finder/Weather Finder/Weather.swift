//
//  Weather.swift
//  Weather Finder
//
//  Created by Matthew Jennell on 4/2/17.
//  Copyright © 2017 Matt Jennell. All rights reserved.
//

import Foundation

struct WeatherModel {
    var city: String
    var state: String
    
    var currentTemp: Double
    var image: String
    var description: String
    
    var windSpeed: Double
    var windDirection: Double
    
    var humidity: Int
    
    init() {
        self.city = ""
        self.state = ""
        
        self.currentTemp = 0.0
        self.image = ""
        
        self.description = ""
        self.windSpeed = 0.0
        self.windDirection = 0.0
        self.humidity = 0
    }
}

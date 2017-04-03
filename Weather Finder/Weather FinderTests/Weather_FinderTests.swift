//
//  Weather_FinderTests.swift
//  Weather FinderTests
//
//  Created by Matthew Jennell on 4/2/17.
//  Copyright © 2017 Matt Jennell. All rights reserved.
//

import XCTest
@testable import Weather_Finder

class Weather_FinderTests: XCTestCase {
    
    var vc: WeatherVC!
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WeatherVC") as! WeatherVC
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testDoubleRound() {
        let lowRound = 5.23456.roundToDecimal(2)
        let highRound = 5.23789.roundToDecimal(2)
        
        XCTAssert(lowRound == 5.23)
        XCTAssert(highRound == 5.24)
    }
    
    func testKelvinConversion() {
        let zeroKelvin = vc.convertFromKelvinToFahrenheit(kelvin: 0)
        let threeKelvin = vc.convertFromKelvinToFahrenheit(kelvin: 300)
        let fiveKelvin = vc.convertFromKelvinToFahrenheit(kelvin: 500)
        
        XCTAssert(zeroKelvin == -459.67)
        XCTAssert(threeKelvin == 80.33)
        XCTAssert(fiveKelvin == 440.33)
    }
    
    func testDegreesToDirection() {
        let east = vc.convertFromDegreesToDirection(degrees: 100)
        let north = vc.convertFromDegreesToDirection(degrees: 0)
        let west = vc.convertFromDegreesToDirection(degrees: 275)
        let south = vc.convertFromDegreesToDirection(degrees: 175)
        
        let ne = vc.convertFromDegreesToDirection(degrees: 40)
        let nw = vc.convertFromDegreesToDirection(degrees: 315)
        let se = vc.convertFromDegreesToDirection(degrees: 130)
        let sw = vc.convertFromDegreesToDirection(degrees: 225)
        
        XCTAssert(east == "East")
        XCTAssert(north == "North")
        XCTAssert(west == "West")
        XCTAssert(south == "South")
        
        XCTAssert(ne == "North East")
        XCTAssert(nw == "North West")
        XCTAssert(se == "South East")
        XCTAssert(sw == "South West")
        
    }
    
    func testMilesPerHourConversion() {
        let zeroMS = vc.convertMStoMPH(ms: 0).roundToDecimal(2)
        let tenMS = vc.convertMStoMPH(ms: 10).roundToDecimal(2)
        let fiftyMS = vc.convertMStoMPH(ms: 50).roundToDecimal(2)
        
        XCTAssert(zeroMS == 0)
        XCTAssert(tenMS == 22.37)
        XCTAssert(fiftyMS == 111.85)
    }
    
}

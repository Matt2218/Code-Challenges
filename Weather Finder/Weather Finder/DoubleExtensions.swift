//
//  DoubleExtensions.swift
//  Weather Finder
//
//  Created by Matthew Jennell on 4/2/17.
//  Copyright © 2017 Matt Jennell. All rights reserved.
//

import Foundation

extension Double {
    func roundToDecimal(_ fractionDigits: Int) -> Double {
        let multiplier = pow(10, Double(fractionDigits))
        return Darwin.round(self * multiplier) / multiplier
    }
}

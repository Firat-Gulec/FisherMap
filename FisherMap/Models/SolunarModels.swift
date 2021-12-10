//
//  SolunarModels.swift
//  FisherMap
//
//  Created by Fırat GÜLEÇ on 10.02.2021.
//

import Foundation

struct SolunarModel: Codable {
    var moonPhase: String? = "00:00"
    var sunRise: String? = "00:00"
    var sunSet: String? = "00:00"
    var moonRise: String? = "00:00"
    var moonSet: String? = "00:00"
    var moonTransit: String? = "00:00"
    var moonUnder: String? = "00:00"
    var dayRating: Int? = 0
    var moonIllumination: Float? = 0.0
    var sunRiseDec: Float? = 0.0
    var sunTransit: String? = "00:00"
    var minor1Start: String? = "00:00"
    var minor2Start: String? = "00:00"
    var major1Start: String? = "00:00"
    var major2Start: String? = "00:00"
    var minor1Stop: String? = "00:00"
    var minor2Stop: String? = "00:00"
    var major1Stop: String? = "00:00"
    var major2Stop: String? = "00:00"
    var hourlyRating: [String:Int] = [:]

    
    
}



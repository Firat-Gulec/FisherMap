//
//  SolunarModels.swift
//  FisherMap
//
//  Created by Fırat GÜLEÇ on 10.02.2021.
//

import Foundation

struct SolunarModel: Codable {
    var moonPhase: String? = "test"
    var sunRise: String? = "test"
    var sunSet: String? = "test"
    var moonRise: String? = "test"
    var moonSet: String? = "test"
    var moonTransit: String? = "test"
    var moonUnder: String? = "test"
    let dayRating: Int
    let moonIllumination: Float
    let sunRiseDec: Float
    var sunTransit: String? = "test"
    var minor1Start: String? = "test"
    var minor2Start: String? = "test"
    var major1Start: String? = "test"
    var major2Start: String? = "test"
    var minor1Stop: String? = "test"
    var minor2Stop: String? = "test"
    var major1Stop: String? = "test"
    var major2Stop: String? = "test"
    var hourlyRating: [String:Int] = [:]

    
    
}



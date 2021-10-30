//
//  SolunarModels.swift
//  FisherMap
//
//  Created by Fırat GÜLEÇ on 10.02.2021.
//

import Foundation

struct SolunarModel: Codable {
    let moonPhase: String
    let sunRise: String
    let sunSet: String
    let moonRise: String
    let moonSet: String
    let moonTransit: String
    let moonUnder: String
    let dayRating: Int
    let moonIllumination: Float
    let sunRiseDec: Float
    let sunTransit: String
}

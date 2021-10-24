//
//  WeatherModels.swift
//  FisherMap
//
//  Created by Fırat GÜLEÇ on 3.02.2021.
//

import Foundation
//current weather forecast
struct WeatherModel: Codable {
    let name: String
    let visibility: Int
    let weather: [WeatherInfo]
    let main: CurrentWeather
    let wind: CurrentWind
    let sys: CurrentLocation
    let clouds: CurrentClouds
}

struct WeatherInfo: Codable {
    let main: String
    let description: String
}

struct CurrentWeather: Codable {
    let temp: Float
    let feels_like: Float
    let temp_min: Float
    let temp_max: Float
    let humidity: Int
}

struct CurrentWind: Codable {
    let speed: Float
    let deg: Int
}

struct CurrentLocation: Codable {
    let sunrise: Date
    let sunset: Date
}

struct CurrentClouds: Codable {
    let all: Int
}



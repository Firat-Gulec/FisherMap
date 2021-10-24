//
//  WForecastModels.swift
//  FisherMap
//
//  Created by Fırat GÜLEÇ on 19.10.2021.
//

import Foundation

//5 day weather forecast
struct WeatherForecast: Decodable {
    let list: [List]
}
 
struct Main: Decodable {
    let temp: Float
    let temp_max: Float
    let temp_min: Float
    let feels_like: Float
    let humidity: Float
}
 
struct Weather2: Decodable {
    let main: String
    let description: String
    let icon: String
}

//struct Clouds2: Decodable {
  //  let all: Int
//}

/*  struct Wind2: Decodable {
    let speed: Float
    let deg: Int
  }*/
 
struct List: Decodable {
    let main: Main
    let weather: [Weather2]
//  let clouds: [Clouds2]
 // let wind: [Wind2]
    let visibility: Int
    let dt_txt: String
}





/*: Codable {
    let cod: String
    let message, cnt: Int
    let list: [List]
    let city: City
}

// MARK: - City
struct City: Codable {
    let id: Int
    let name: String
    let country: String
    let population, timezone, sunrise, sunset: Int
}

struct List: Codable {
    //let id = UUID()
    let dt: Int
    let dt_txt: String
    let weather: [WeatherF]
    let main: [MainF]
    let wind: [WindF]
    let clouds: [CloudsF]
}

struct WeatherF: Codable {
    let id: Int
    let main: String
    let description: String
}

struct MainF: Codable {
    let temp: Float
    let feels_like: Float
    let temp_min: Float
    let temp_max: Float
    let humidity: Int
}

struct WindF: Codable {
    let speed: Float
    let deg: Int
}

struct CloudsF: Codable {
    let all: Int
}
*/

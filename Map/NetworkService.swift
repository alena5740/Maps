//
//  NetworkService.swift
//  Map
//
//  Created by Alena Sidorova on 12.05.2023.
//

import Foundation
import UIKit
import MapKit

protocol NetworkServiceProtocol {
    func getWeather(lat: Double , lon: Double,
                    completion: @escaping (Result<Location, Error>) -> Void)
}

final class NetworkService: NetworkServiceProtocol {

    private let openWeatherURL = "https://api.openweathermap.org/data/2.5/weather"
    private let openWeatherIPkey = "bd5ac2232bd727451b6e7146911a3ea5"

    func getWeather(lat : Double , lon : Double,
                    completion: @escaping (Result<Location, Error>) -> Void) {
        let weatherRequestURL = URL(string: "\(openWeatherURL)?lat=\(lat)&lon=\(lon)&appid=\(openWeatherIPkey)")!
        execute(weatherRequestURL: weatherRequestURL, completion: completion)
    }

    private func execute(weatherRequestURL : URL,
                         completion: @escaping (Result<Location, Error>) -> Void) {
        URLSession.shared.dataTask(with: weatherRequestURL) { (data, response, error) in

            if let networkError = error {
                print(networkError)
            } else {
                if let usbleData = data {
                    do {
                        let weatherJSONData = try JSONSerialization.jsonObject(with: usbleData, options: JSONSerialization.ReadingOptions.mutableContainers) as! [String: AnyObject]
                        let weather = Location(weatherData: weatherJSONData)
                        completion(.success(weather))
                    }  catch let  jsonError as NSError{
                        print(jsonError)
                    }
                }
            }
        }.resume()
    }
}

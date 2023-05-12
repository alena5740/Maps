//
//  LocationModel.swift
//  Map
//
//  Created by Alena Sidorova on 12.05.2023.
//

import UIKit

struct Location {
    let city: String?
    let longitude: Double?
    let latitude: Double?

    private let temp: Double?


    var tempCelsius: Double {
        get {
            return (temp ?? 0.0 - 273.15).rounded(toPlaces: 2)
        }
    }

    var tempFahrenheit: Double {
        get {
            return ((temp ?? 0.0 - 273.15) * 1.8 + 32).rounded(toPlaces: 2)
        }
    }

    init(weatherData: [String: AnyObject]) {
        city = weatherData["name"] as? String

        let coordDict = weatherData["coord"] as? [String: AnyObject]
        longitude = coordDict?["lon"] as? Double
        latitude = coordDict?["lat"] as? Double

        let mainDict = weatherData["main"] as? [String: AnyObject]
        temp = mainDict?["temp"] as? Double
    }
}

extension Double {
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

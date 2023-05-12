//
//  LocationPresenter.swift
//  Map
//
//  Created by Alena Sidorova on 12.05.2023.
//

import MapKit

protocol LocationPresenterProtocol {
    func getWeatherCount(index: Int) -> Location
    func getWeather(completion: @escaping () -> Void)
    func getWeatherCount() -> Int
}

final class LocationPresenter: LocationPresenterProtocol {

    private var randomLocation: [Coordinate] = []
    private let aGroup = DispatchGroup()


    private let networkService : NetworkServiceProtocol
    private var weater: Location?
    private var models = [Location]()

    init(networkService : NetworkServiceProtocol) {
        self.networkService = networkService
    }

    func getWeather(completion: @escaping () -> Void) {
        randomNumbers()
        for location in randomLocation {
            aGroup.enter()
            networkService.getWeather(lat: location.lat, lon: location.lon) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let model):
                    self.models.append(model)
                    self.aGroup.leave()
                case .failure(_):
                    self.aGroup.leave()
                }
            }
        }
        aGroup.notify(queue: DispatchQueue.main) {
            completion()
        }
    }

    func getWeatherCount() -> Int {
        return models.count
    }

    func getWeatherCount(index: Int) -> Location {
        return models[index]
    }

    private func randomNumbers() {
        for _ in 0..<5 {
            let resultLon = Double.random(in: 1...99)
            let resultLat = Double.random(in: 1...99)
            let location = Coordinate(lon: resultLon, lat: resultLat)
            randomLocation.append(location)
        }
    }
}

//
//  MapPresenter.swift
//  Map
//
//  Created by Alena Sidorova on 12.05.2023.
//

import Foundation
import MapKit

protocol MapViewOutputProtocol: AnyObject {
    func updateView()
    func showError(title: String)
}

protocol MapPresenterProtocol {
    func getWeatherModel() -> Location?
    func getWeather(lat: Double, lon: Double, completion: @escaping () -> Void)
}

final class MapPresenter: MapPresenterProtocol {

    private let networkService : NetworkServiceProtocol
    private var weater: Location?
    private var locations = [CLLocation]()

    init(networkService : NetworkServiceProtocol) {
        self.networkService = networkService
    }

    func getWeather(lat: Double, lon: Double, completion: @escaping () -> Void) {
        networkService.getWeather(lat: lat, lon: lon) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let model):
                self.weater = model
                completion()
            case .failure(_):
                print("хер вам")
            }
        }
    }

    func getWeatherModel() -> Location? {
        return weater
    }
}

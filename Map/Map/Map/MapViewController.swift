//
//  MapViewController.swift
//  Map
//
//  Created by Alena Sidorova on 12.05.2023.
//

import UIKit
import MapKit

protocol MapViewControllerProtocol {
    var didTapOnLocation: (() -> Void)? { get set }
    var didTapOnClose: (() -> Void)? { get set }
}

final class MapViewController: UIViewController, MapViewControllerProtocol {

    var didTapOnLocation: (() -> Void)?
    var didTapOnClose: (() -> Void)?
    private let mapView = MKMapView()
    private var coordinate = CLLocation()
    private let pin = MKPointAnnotation()
    private var locationIsVisible = false
    private let presenter: MapPresenterProtocol

    init(presenter : MapPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        mapView.delegate = self
    }

    private func setupUI() {
        setupMapView()
    }

    private func setupMapView() {
        view.addSubview(mapView)
        mapView.frame = view.frame

        let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(addAnnotation(gestureRecognizer:)))
        longGesture.minimumPressDuration = 1.0

        mapView.addGestureRecognizer(longGesture)
    }

    private func setupCoordinate(lat: Double, lon: Double) {
        coordinate = CLLocation(latitude: lat, longitude: lon)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if locationIsVisible {
            self.mapView.removeAnnotation(pin)
            locationIsVisible = !locationIsVisible
            didTapOnClose?()
        }
    }

    @objc func addAnnotation(gestureRecognizer: UIGestureRecognizer) {
        if !locationIsVisible {
            if gestureRecognizer.state == UIGestureRecognizer.State.began {
                let touchPoint = gestureRecognizer.location(in: mapView)
                let location = mapView.convert(touchPoint, toCoordinateFrom: mapView)

                mapView.centerLocation(location: location)
                addPins(location: location)

                locationIsVisible = !locationIsVisible
                presenter.getWeather(lat: location.latitude, lon: location.longitude, completion: {
                    DispatchQueue.main.async {
                        self.didTapOnLocation?()
                    }
                })
            }
        }
    }

    func addPins(location: CLLocationCoordinate2D) {
        pin.coordinate = CLLocationCoordinate2D (
            latitude: location.latitude,
            longitude: location.longitude
        )
        mapView.addAnnotation(pin)
    }
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }

        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "custom")

        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "custom")
        } else {
            annotationView?.annotation = annotation
        }

        annotationView?.image = UIImage(named: "Pin")
        return annotationView
    }
}

extension MKMapView {
    func centerLocation(location: CLLocationCoordinate2D) {
        let span: MKCoordinateSpan = .init(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let cootdinateRegion = MKCoordinateRegion(center: location, span: span)
        setRegion(cootdinateRegion, animated: true)
    }
}

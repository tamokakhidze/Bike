//
//  FullMapViewController.swift
//  BikeRentalApp
//
//  Created by Tamuna Kakhidze on 10.07.24.
//

import UIKit
import MapKit
import CoreLocation

// MARK: - FullMapViewController

final class FullMapViewController: UIViewController {
    
    // MARK: - UI Components and Properties

    private let map = MKMapView()
    private let manager = CLLocationManager()
    private var viewModel = HomeViewModel()
    private var userLocation = CLLocation()
    private var nearbyLocations = [CLLocation]()
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setDelegates()
        configureManager()
        setupUI()
        fetchBikeLocations()
    }
    
    // MARK: - UI Setup

    private func setupUI() {
        setupViewHierarchy()
        setConstraints()
    }
    
    private func setupViewHierarchy() {
        view.addSubview(map)
    }
    
    private func setConstraints() {
        map.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            map.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            map.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            map.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            map.topAnchor.constraint(equalTo: view.topAnchor)
        ])
    }
    
    // MARK: - Set delegates

    private func setDelegates() {
        map.delegate = self
        manager.delegate = self
    }
    
    // MARK: - Map Logic

    private func configureManager() {
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }
    
    private func fetchBikeLocations() {
        viewModel.fetchData {
            self.updateNearbyLocations()
        }
    }
    
    private func updateNearbyLocations()  {
        nearbyLocations = viewModel.locations.filter { location in
            userLocation.distance(from: location) <= Map.nearbyDistance
        }
        updateMapAnnotations()
    }
    
    private func updateMapAnnotations() {
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: userLocation.coordinate, span: span)
        map.setRegion(region, animated: true)
        
        map.removeAnnotations(map.annotations)
        
        var annotations = [MKPointAnnotation]()
        
        for location in nearbyLocations {
            let annotation = MKPointAnnotation()
            annotation.coordinate = location.coordinate
            
            if let bike = viewModel.bikes.first(where: { $0.location.latitude == location.coordinate.latitude && $0.location.longitude == location.coordinate.longitude }) {
                annotation.title = bike.geometry.capitalized
            }
            
            annotations.append(annotation)
        }
        
        map.addAnnotations(annotations)
        
        var regionRect = MKMapRect.null
        
        let userLoc = MKMapPoint(userLocation.coordinate)
        regionRect = regionRect.union(MKMapRect(x: userLoc.x, y: userLoc.y, width: 0, height: 0))
        
        for annotation in annotations {
            let point = MKMapPoint(annotation.coordinate)
            regionRect = regionRect.union(MKMapRect(x: point.x, y: point.y, width: 0, height: 0))
        }
        
        let edgePadding = UIEdgeInsets(top: 50, left: 50, bottom: 50, right: 50)
        map.setVisibleMapRect(regionRect, edgePadding: edgePadding, animated: true)
        
    }
}

// MARK: - CLLocationManagerDelegate

extension FullMapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        manager.stopUpdatingLocation()
        guard let currentLocation = locations.first else { return }
        userLocation = currentLocation
        print("User location \(userLocation)")
        updateNearbyLocations()
        render(userLocation: userLocation)
        manager.stopUpdatingLocation()
    }
    
    func render(userLocation: CLLocation) {
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: userLocation.coordinate, span: span)
        map.setRegion(region, animated: true)
    }
}

// MARK: - MKMapViewDelegate

extension FullMapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: Map.annotationIdentifier) as? BikeAnnotationView
        
        if annotationView == nil {
            annotationView = BikeAnnotationView(annotation: annotation, reuseIdentifier: Map.annotationIdentifier)
        } else {
            annotationView?.annotation = annotation
        }
        
        annotationView?.configure(with: annotation)
        if annotation.title == Titles.road {
            annotationView?.image = .roadBike
        } else if annotation.title == Titles.mountain {
            annotationView?.image = .mapPin
        } else {
            annotationView?.image = .currentLoc
        }
        annotationView?.image = .mapPin
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let coordinate = view.annotation?.coordinate else { return }
        if let bike = viewModel.bikes.first(where: { $0.location.latitude == coordinate.latitude && $0.location.longitude == coordinate.longitude }) {
            navigationController?.pushViewController(DetailsViewController(bike: bike), animated: true)
        }
    }
}

extension FullMapViewController {
    enum Map {
        static let nearbyDistance: Double = 10000
        static let annotationIdentifier = "AnnotationIdentifier"
    }
    
    enum Titles {
        static let road = "Road"
        static let mountain = "Mountain"
    }
}

//
//  DetailsViewController.swift
//  BikeRentalApp
//
//  Created by Tamuna Kakhidze on 09.07.24.
//

import UIKit
import MapKit
import CoreLocation
import FirebaseFirestore

// MARK: - DetailsViewController

final class DetailsViewController: UIViewController {
    
    // MARK: - Ui components and properties
    
    private lazy var mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.mapType = .standard
        mapView.layer.cornerRadius = 20
        mapView.clipsToBounds = true
        return mapView
    }()
    
    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        return stackView
    }()
    
    private lazy var featuresStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.alignment = .center
        return stackView
    }()
    
    private lazy var buttonsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.alignment = .center
        return stackView
    }()
    
    private lazy var mainImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isUserInteractionEnabled = true
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var featuresCollectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 18
        layout.minimumInteritemSpacing = 0
        let itemWidth: CGFloat = 136
        let itemHeight: CGFloat = 89
        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(FeaturesCell.self, forCellWithReuseIdentifier: FeaturesCell.identifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        
        collectionView.showsHorizontalScrollIndicator = false
        
        return collectionView
    }()
    
    private lazy var blurEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.translatesAutoresizingMaskIntoConstraints = false
        blurEffectView.alpha = 0
        return blurEffectView
    }()
    
    private let rentButton = CustomButton(title: "Rent now!", hasBackground: true, width: 200)
    private let view3DModelButton = SmallCustomButton(width: 30, height: 30, backgroundImage: "arKitImage", backgroundColor: .clear)
    private let allPhotosButton = SmallCustomButton(width: 30, height: 30, backgroundImage: "allImagesIcon", backgroundColor: .white )
    private var addHelmetButton = SmallCustomButton(width: 50, height: 50, backgroundColor: .white)
    private lazy var backgroundOne = CustomRectangleView(color: .darkBlue)
    private lazy var backgroundTwo = CustomRectangleView(color: .white)
    
    let manager = CLLocationManager()
    private var userLocation = CLLocation()
    private var viewModel = DetailsViewModel()
    var bike: Bike
    private var route: MKOverlay?
    var helmetIsChosen = false
    var helmetPrice = 0.0
    let image = UIImageView(image: UIImage(resource: .roadBike))
    
    // MARK: - Lifecycle
    
    init(bike: Bike) {
        self.bike = bike
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue
        setupUI()
        setDelegates()
        addActions()
        checkLocationServices()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkLocationServices()
        
    }
    
    // MARK: - Ui setup
    
    private func setupUI() {
        
        addHelmetButton.isEnabled = bike.hasHelmet
        addHelmetButton.setBackgroundImage(UIImage(named: "helmetImage"), for: .normal)
        if let image = bike.detailedImages.first,
           let url = URL(string: image) {
            mainImage.setImage(with: url)
        } else {
            mainImage.image = .bike
        }
        
        view.addSubview(mapView)
        view.addSubview(backgroundOne)
        view.addSubview(backgroundTwo)
        view.addSubview(mainStackView)
        view.addSubview(blurEffectView)
        view.addSubview(mainImage)
        
        configureStackViews()
        configureConstraints()
        
        manager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    private func configureStackViews() {
        featuresStackView.addArrangedSubviews(
            CustomImageView(width: 10, height: 16, backgroundImage: "currencyImage"),
            CustomUiLabel(fontSize: 12, text: "\(bike.price)", tintColor: .white, textAlignment: .left),
            CustomUiLabel(fontSize: 12, text: "Year: \(bike.year)", tintColor: .white, textAlignment: .left),
            view3DModelButton,
            UIView()
        )
        
        buttonsStackView.addArrangedSubviews(addHelmetButton, UIView(), rentButton)
        
        mainStackView.addArrangedSubviews(
            CustomUiLabel(fontSize: 28, text: bike.geometry.capitalized, tintColor: .white, textAlignment: .left),
            featuresStackView,
            CustomUiLabel(fontSize: 24, text: "Features", tintColor: .darkBackground, textAlignment: .left),
            featuresCollectionView,
            buttonsStackView)
    }
    
    private func configureConstraints() {
        mapView.translatesAutoresizingMaskIntoConstraints = false
        backgroundOne.translatesAutoresizingMaskIntoConstraints = false
        backgroundTwo.translatesAutoresizingMaskIntoConstraints = false
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        featuresStackView.translatesAutoresizingMaskIntoConstraints = false
        buttonsStackView.translatesAutoresizingMaskIntoConstraints = false
        allPhotosButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: backgroundTwo.topAnchor, constant: -30),
            
            backgroundOne.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 300),
            backgroundOne.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundOne.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundOne.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            backgroundTwo.topAnchor.constraint(equalTo: backgroundOne.topAnchor, constant: 99),
            backgroundTwo.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundTwo.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundTwo.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            mainStackView.topAnchor.constraint(equalTo: backgroundOne.topAnchor, constant: 20),
            mainStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 28),
            mainStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -28),
            mainStackView.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor),
                        
            mainImage.topAnchor.constraint(equalTo: mainStackView.topAnchor, constant: 40),
            mainImage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            mainImage.widthAnchor.constraint(equalToConstant: 200),
            mainImage.heightAnchor.constraint(equalToConstant: 132),
            
//            featuresStackView.widthAnchor.constraint(equalToConstant: 125),
            
            featuresCollectionView.heightAnchor.constraint(equalToConstant: 136),
            
            blurEffectView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            blurEffectView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            blurEffectView.topAnchor.constraint(equalTo: view.topAnchor),
            blurEffectView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            
        ])
    }
    
    // MARK: - Actions
    
    private func addActions() {
        rentButton.addTarget(self, action: #selector(goToCalendarView), for: .touchUpInside)
        allPhotosButton.addTarget(self, action: #selector(showSlider), for: .touchUpInside)
        addHelmetButton.addTarget(self, action: #selector(addHelmetButtonTapped), for: .touchUpInside)
        view3DModelButton.addTarget(self, action: #selector(view3DModelButtonTapped), for: .touchUpInside)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(scaleImageUp))
        mainImage.addGestureRecognizer(tapGesture)
    }
    
    @objc func view3DModelButtonTapped() {
        navigationController?.pushViewController(Bike3DViewController(), animated: true)
    }
    
    @objc func scaleImageUp() {
        viewModel.playButtonClick(mainImage)
    }
    
    @objc private func goToCalendarView() {
        print(bike)
        let vc = CalendarViewController(bike: bike, isHelmetChosen: helmetIsChosen, helmetPrice: helmetPrice)
        print(helmetIsChosen)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func showSlider() {
        let vc = SliderPopUpViewController(bike: bike)
        vc.modalPresentationStyle = .popover
        if let popoverController = vc.popoverPresentationController {
            popoverController.delegate = self
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.height/4, width: 0, height: 0)
            popoverController.permittedArrowDirections = .any
            vc.preferredContentSize = CGSize(width: 300, height: 400)
            
        }
        present(vc, animated: true, completion: nil)
    }
    
    @objc private func addHelmetButtonTapped() {
        helmetIsChosen.toggle()
        updateHelmetButtonIcon()
    }
    
    private func updateHelmetButtonIcon() {
        if helmetIsChosen {
            addHelmetButton.setBackgroundImage(UIImage(named: "helmetImageFill"), for: .normal)
            print("helmet is chosen! price: \(String(describing: bike.helmetPrice))")
        } else {
            addHelmetButton.setBackgroundImage(UIImage(named: "helmetImage"), for: .normal)
        }
    }
    
    // MARK: - Set delegates

    private func setDelegates() {
        featuresCollectionView.dataSource = self
        mapView.delegate = self
        manager.delegate = self
        viewModel.delegate = self
    }
    
    // MARK: - Location services
    
    private func checkLocationServices() {
        checkLocationAuthorization()
    }
    
    private func checkLocationAuthorization() {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            manager.startUpdatingLocation()
        case .denied, .restricted:
            print("Location access denied/restricted.")
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        @unknown default:
            fatalError("Unknown authorization status.")
        }
    }
    
    // MARK: - Drawing route
    
    private func drawRoute(routeData: [CLLocation]) {
        if routeData.count == 0 {
            print("nothing to draw")
            return
        }
        
        let coordinates = routeData.map { location -> CLLocationCoordinate2D in
            return location.coordinate
        }
        
        DispatchQueue.main.async {
            self.route = MKPolyline(coordinates: coordinates, count: coordinates.count)
            self.mapView.addOverlay(self.route!)
            let customEdgePadding: UIEdgeInsets = UIEdgeInsets(top: 50, left: 50, bottom: 50, right: 50)
            self.mapView.setVisibleMapRect(self.route!.boundingMapRect, edgePadding: customEdgePadding ,animated: true)
        }
    }
}

// MARK: - CLLocationManagerDelegate

extension DetailsViewController: CLLocationManagerDelegate {
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            manager.stopUpdatingLocation()
            print("Location updated: \(location.coordinate.latitude), \(location.coordinate.longitude)")
            render(bike: bike, userLocation: location)
        }
    }
    
    func render(bike: Bike, userLocation: CLLocation) {
        let bikeLat = bike.location.latitude
        let bikeLong = bike.location.longitude
        let bikeCoordinate = CLLocationCoordinate2D(latitude: bikeLat, longitude: bikeLong)
        
        let span = MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
        
        let bikeAnnotation = MKPointAnnotation()
        bikeAnnotation.coordinate = bikeCoordinate
        bikeAnnotation.title = "Bike Location"
        mapView.addAnnotation(bikeAnnotation)
        
        let userLocAnnotation = MKPointAnnotation()
        userLocAnnotation.coordinate = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
        userLocAnnotation.title = "Your location"
        mapView.addAnnotation(userLocAnnotation)
        
        let bikeCLLocation = CLLocation(latitude: bikeLat, longitude: bikeLong)
        let midPoint = midPoint(of: bikeCLLocation, userLocation)
        let region = MKCoordinateRegion(center: midPoint, span: span)
        mapView.setRegion(region, animated: true)
        
        drawRoute(routeData: [bikeCLLocation, userLocation])
        print("mid loc: \(midPoint), bike loc: \(bikeCLLocation), me: \(userLocation) ")
        
    }
}

// MARK: - UIPopoverPresentationControllerDelegate

extension DetailsViewController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}

// MARK: - MKMapViewDelegate

extension DetailsViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        var reuseIdentifier = ""
        
        if annotation.title == "Bike Location" {
            reuseIdentifier = "bike"
        }
        else if  annotation.title == "Your location" {
            reuseIdentifier = "user"
        }
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier)
        
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
        } else {
            annotationView?.annotation = annotation
        }
        
        if annotation.title == "Your location" {
            annotationView?.image = UIImage(resource: .currentLoc)
        } else if annotation.title == "Bike Location" {
            annotationView?.image = UIImage(resource: .mapPin)
        } else {
            annotationView?.image = UIImage(resource: .currentLoc)
        }
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: any MKOverlay) -> MKOverlayRenderer {
        let render = MKGradientPolylineRenderer(overlay: overlay)
        
        render.setColors([.lightGray], locations: [])
        
        render.lineCap = .round
        render.lineWidth = 1.0
        
        return render
    }
}

// MARK: - UICollectionViewDataSource

extension DetailsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeaturesCell.identifier, for: indexPath) as? FeaturesCell
        
        var text = ""
        var icon = ""
        var info = ""
        switch indexPath.row {
        case 0:
            text = bike.hasHelmet ? "Choose helmet " : "No helmet"
            icon = bike.hasHelmet ? "figure.outdoor.cycle" : "slash.circle.fill"
            info = bike.hasHelmet ? "Price: \(bike.helmetPrice) an hour" : "Check shop"
        case 1:
            text = "Gears: \(bike.numberOfGears)"
            icon = "gear"
            info = "Smooth Shifting"
        case 2:
            text = "Brake type: \(bike.brakeType.capitalized)"
            icon = "pedal.brake.fill"
            info = "High Performance"
        default:
            text = bike.hasLights ? "With lights" : "No lights"
            icon = bike.hasLights ? "flashlight.on.circle.fill" : "flashlight.slash.circle.fill"
            info = bike.hasLights ? "Safety at Night" : "Daytime Use Only"
        }
        
        cell?.configure(with: text, icon: icon, detailsText: info)
        
        return cell ?? UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
}

// MARK: - DetailsViewModelDelegate

extension DetailsViewController: DetailsViewModelDelegate {
    
    
    func scaleDown() {
        DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
            UIView.animate(withDuration: 1) { [self] in
                mainImage.transform = .identity
                self.blurEffectView.alpha = 0.0
                self.view.backgroundColor = .white
            }
        }
    }
    
    func scaleUp() {
        UIView.animate(withDuration: 1.0) {
            let scaleTransform = CGAffineTransform(scaleX: 2.2, y: 2.2)
            let translationTransform = CGAffineTransform(translationX: -70, y: 0)
            let combinedTransform = scaleTransform.concatenating(translationTransform)
            self.blurEffectView.alpha = 1.0
            self.view.backgroundColor = .black
            self.mainImage.transform = combinedTransform
        }
    }
    
}

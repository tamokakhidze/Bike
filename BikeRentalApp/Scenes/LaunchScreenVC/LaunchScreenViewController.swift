//
//  LaunchScreenViewController.swift
//  BikeRentalApp
//
//  Created by Tamuna Kakhidze on 22.07.24.
//

import UIKit

// MARK: - LaunchScreenViewController

final class LaunchScreenViewController: UIViewController {

    // MARK: - Ui components

    private let bikeImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "bike_body"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let frontWheelImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "front_wheel"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let rearWheelImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "rear_wheel"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let roadImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "roadImage"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupBikeAndWheels()
        startBikeAnimation()
        transitionToHomeScreen()
    }
    
    // MARK: - ui setup

    private func setupBikeAndWheels() {
        view.addSubview(bikeImageView)
        view.addSubview(frontWheelImageView)
        view.addSubview(rearWheelImageView)
        view.addSubview(roadImageView)
        
        NSLayoutConstraint.activate([
            bikeImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            bikeImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            bikeImageView.widthAnchor.constraint(equalToConstant: 110),
            bikeImageView.heightAnchor.constraint(equalToConstant: 100),
            
            frontWheelImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -55),
            frontWheelImageView.bottomAnchor.constraint(equalTo: bikeImageView.bottomAnchor, constant: 20),
            frontWheelImageView.widthAnchor.constraint(equalToConstant: 100),
            frontWheelImageView.heightAnchor.constraint(equalToConstant: 100),
            
            rearWheelImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 55),
            rearWheelImageView.bottomAnchor.constraint(equalTo: bikeImageView.bottomAnchor, constant: 20),
            rearWheelImageView.widthAnchor.constraint(equalToConstant: 100),
            rearWheelImageView.heightAnchor.constraint(equalToConstant: 100),
            
            roadImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            roadImageView.topAnchor.constraint(equalTo: bikeImageView.bottomAnchor, constant: -40),
            roadImageView.widthAnchor.constraint(equalToConstant: 114),
            roadImageView.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    // MARK: - Animations

    private func startBikeAnimation() {
        let wheelRotation = CABasicAnimation(keyPath: "transform.rotation")
        wheelRotation.toValue = NSNumber(value: Double.pi * 2)
        wheelRotation.duration = 1
        wheelRotation.isCumulative = true
        wheelRotation.repeatCount = .infinity
        
        frontWheelImageView.layer.add(wheelRotation, forKey: "frontWheelRotation")
        rearWheelImageView.layer.add(wheelRotation, forKey: "rearWheelRotation")
        
        let bikeAnimation = CABasicAnimation(keyPath: "transform.scale")
        bikeAnimation.fromValue = NSNumber(value: 1.0)
        bikeAnimation.toValue = NSNumber(value: 1.1)
        bikeAnimation.duration = 0.5
        bikeAnimation.autoreverses = true
        bikeAnimation.repeatCount = .infinity
        bikeImageView.layer.add(bikeAnimation, forKey: "bikeAnimation")
    }
    
    // MARK: - Navigation to home screen

    private func transitionToHomeScreen() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            NotificationCenter.default.post(name: NSNotification.Name("LaunchScreenAnimationEnded"), object: nil)
        }
    }
}


#Preview {
    LaunchScreenViewController()
}

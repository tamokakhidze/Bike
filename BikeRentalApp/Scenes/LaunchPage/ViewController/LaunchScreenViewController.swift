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
        let imageView = UIImageView(image: .bikeBody)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let frontWheelImageView: UIImageView = {
        let imageView = UIImageView(image: .frontWheel)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let rearWheelImageView: UIImageView = {
        let imageView = UIImageView(image: .rearWheel)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let roadImageView: UIImageView = {
        let imageView = UIImageView(image: .road)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        startBikeAnimation()
        transitionToHomeScreen()
    }
    
    // MARK: - ui setup
    
    private func setupUI() {
        setupView()
        setupViewHierarchy()
        setConstraints()
    }
    
    private func setupView() {
        view.backgroundColor = .launchScreenBackground
    }
    
    private func setupViewHierarchy() {
        view.addSubviews(bikeImageView, frontWheelImageView, rearWheelImageView, roadImageView)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            bikeImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            bikeImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            bikeImageView.widthAnchor.constraint(equalToConstant: LayoutConstants.bikeImageWidth),
            bikeImageView.heightAnchor.constraint(equalToConstant: LayoutConstants.bikeImageHeight),
            
            frontWheelImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: LayoutConstants.frontWheelXOffset),
            frontWheelImageView.bottomAnchor.constraint(equalTo: bikeImageView.bottomAnchor, constant: LayoutConstants.wheelBottomOffset),
            frontWheelImageView.widthAnchor.constraint(equalToConstant: LayoutConstants.wheelWidth),
            frontWheelImageView.heightAnchor.constraint(equalToConstant: LayoutConstants.wheelHeight),
            
            rearWheelImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: LayoutConstants.rearWheelXOffset),
            rearWheelImageView.bottomAnchor.constraint(equalTo: bikeImageView.bottomAnchor, constant: LayoutConstants.wheelBottomOffset),
            rearWheelImageView.widthAnchor.constraint(equalToConstant: LayoutConstants.wheelWidth),
            rearWheelImageView.heightAnchor.constraint(equalToConstant: LayoutConstants.wheelHeight),
            
            roadImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            roadImageView.topAnchor.constraint(equalTo: bikeImageView.bottomAnchor, constant: LayoutConstants.roadYOffset),
            roadImageView.widthAnchor.constraint(equalToConstant: LayoutConstants.roadWidth),
            roadImageView.heightAnchor.constraint(equalToConstant: LayoutConstants.roadHeight)
        ])
    }
    
    // MARK: - Animations
    
    private func startBikeAnimation() {
        let wheelRotation = CABasicAnimation(keyPath: "transform.rotation")
        wheelRotation.toValue = AnimationConstants.wheelRotationToValue
        wheelRotation.duration = AnimationConstants.wheelRotationDuration
        wheelRotation.isCumulative = true
        wheelRotation.repeatCount = .infinity
        
        frontWheelImageView.layer.add(wheelRotation, forKey: AnimationConstants.frontWheelAnimationKey)
        rearWheelImageView.layer.add(wheelRotation, forKey: AnimationConstants.rearWheelAnimationKey)
        
        let bikeAnimation = CABasicAnimation(keyPath: "transform.scale")
        bikeAnimation.fromValue = AnimationConstants.bikeAnimationFromValue
        bikeAnimation.toValue = AnimationConstants.bikeAnimationToValue
        bikeAnimation.duration = AnimationConstants.bikeScaleDuration
        bikeAnimation.autoreverses = true
        bikeAnimation.repeatCount = .infinity
        bikeImageView.layer.add(bikeAnimation, forKey: AnimationConstants.bikeAnimationKey)
    }
    
    // MARK: - Navigation to home screen
    
    private func transitionToHomeScreen() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            NotificationCenter.default.post(name: NSNotification.Name("LaunchScreenAnimationEnded"), object: nil)
        }
    }
}

// MARK: - Constants extension

extension LaunchScreenViewController {
    enum LayoutConstants {
        static let bikeImageWidth: CGFloat = 110
        static let bikeImageHeight: CGFloat = 100
        static let wheelWidth: CGFloat = 100
        static let wheelHeight: CGFloat = 100
        static let frontWheelXOffset: CGFloat = -55
        static let rearWheelXOffset: CGFloat = 55
        static let wheelBottomOffset: CGFloat = 20
        static let roadYOffset: CGFloat = -40
        static let roadWidth: CGFloat = 114
        static let roadHeight: CGFloat = 100
    }
    
    enum AnimationConstants {
        static let wheelRotationToValue = NSNumber(value: Double.pi * 2)
        static let wheelRotationDuration: CFTimeInterval = 1
        static let frontWheelAnimationKey = "frontWheelRotation"
        static let rearWheelAnimationKey = "rearWheelRotation"
        static let bikeAnimationFromValue = NSNumber(value: 1.0)
        static let bikeAnimationToValue = NSNumber(value: 1.1)
        static let bikeScaleDuration: CFTimeInterval = 0.5
        static let bikeAnimationKey = "bikeAnimation"
    }
}

#Preview {
    LaunchScreenViewController()
}

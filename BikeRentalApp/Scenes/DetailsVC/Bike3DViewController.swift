//
//  Bike3DViewController.swift
//  BikeRentalApp
//
//  Created by Tamuna Kakhidze on 24.08.24.
//

import UIKit
import SceneKit

class Bike3DViewController: UIViewController {
    
    private lazy var sceneView: SCNView = {
        let sceneView = SCNView()
        sceneView.allowsCameraControl = true
        sceneView.backgroundColor = .clear
        sceneView.cameraControlConfiguration.allowsTranslation = false
        sceneView.translatesAutoresizingMaskIntoConstraints = false
        sceneView.isUserInteractionEnabled = true
        return sceneView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        load3DModelFromAssets()
    }
    
    private func setupUI() {
        view.backgroundColor = .darkBackground
        
        view.addSubview(sceneView)
        
        NSLayoutConstraint.activate([
            sceneView.topAnchor.constraint(equalTo: view.topAnchor),
            sceneView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            sceneView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            sceneView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
        ])
        
    }
    
    private func load3DModelFromAssets() {
        guard let scene = SCNScene(named: "voltage.usdz") else {
            print("Could not load asset")
            return
        }
        
        DispatchQueue.main.async { [self] in
            sceneView.scene = scene
        }
        
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light?.type = .omni
        lightNode.position = SCNVector3(0, 10, 35)
        scene.rootNode.addChildNode(lightNode)
        
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light?.type = .ambient
        ambientLightNode.light?.color = UIColor.darkGray
        scene.rootNode.addChildNode(ambientLightNode)
    }
}

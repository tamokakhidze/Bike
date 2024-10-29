//
//  SceneDelegate.swift
//  BikeRentalApp
//
//  Created by Tamuna Kakhidze on 03.07.24.
//

import UIKit
import FirebaseCore
import FirebaseAuth
import LocalAuthentication

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    var navigationController = UINavigationController()
    var isUserAuthenticated: Bool{
        Auth.auth().currentUser?.uid != nil
    }

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }

        window = UIWindow(windowScene: scene)
        showLaunchScreen()

        NotificationCenter.default.addObserver(self, selector: #selector(userDidLogout), name: NSNotification.Name("UserDidLogout"), object: nil)
    }
    
    private func showLaunchScreen() {
        let launchScreenVC = LaunchScreenViewController()
        window?.rootViewController = launchScreenVC
        window?.makeKeyAndVisible()
        
        loadDataAndTransition()
    }
    
    private func loadDataAndTransition() {
        DispatchQueue.global().async {
            sleep(4)
            DispatchQueue.main.async {
                if self.isUserAuthenticated {
                    self.authenticateWithFaceId()
                } else {
                    self.checkIfUserIsLoggedIn()
                }
            }
        }
    }

    func checkIfUserIsLoggedIn() {
           if !isUserAuthenticated {
               navigationController.setViewControllers([LoginViewController()], animated: false)
           } else {
               navigationController.setViewControllers([LandingViewController()], animated: false)
           }
           window?.rootViewController = navigationController
           window?.makeKeyAndVisible()
       }

    @objc func userDidLogout() {
        checkIfUserIsLoggedIn()
    }
    
    func authenticateWithFaceId() {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "This is a security check reason.") { [weak self] success, authenticationError in
                
                DispatchQueue.main.async {
                    if success {
                        self?.checkIfUserIsLoggedIn()
                    } else {
                        AuthService.shared.signOut { error in
                            DispatchQueue.main.async {
                                if let error = error {
                                    print("couldn't sign out, \(error)")
                                } else {
                                    self?.checkIfUserIsLoggedIn()
                                }
                            }
                        }
                    }
                }
            }
        } else {
            DispatchQueue.main.async {
                print("biometrics are not available")
            }
        }
    }
}


//
//  HomeViewModel.swift
//  BikeRentalApp
//
//  Created by Tamuna Kakhidze on 08.07.24.
//

import Foundation
import FirebaseFirestore
import CoreLocation
import FirebaseAuth

// MARK: - Protocols

protocol HomeViewModelDelegate: AnyObject {
    func scrollToItem(at indexPath: IndexPath, animated: Bool)
    func updatePageControl(currentPage: Int)
}

final class HomeViewModel: ObservableObject {
    
    private var db = Firestore.firestore()
    var salesImagesArray = [
        "https://i.pinimg.com/originals/19/f0/b5/19f0b54227480dc5dace75c8399764f3.png",
        "https://i.pinimg.com/originals/48/6b/1d/486b1dae8fc4a1945d741c967e4acad9.jpg",
        "https://i.pinimg.com/564x/9f/b5/49/9fb54992d1f3aef360aa6c819bf248a4.jpg"
    ]
    
    var salesHeroTexts = [
        "Book a ride",
        "Rent for friends",
        "Exchange points",
    ]
    
    var salesSubtexts = [
        "Earn points",
        "Rent as many as you want",
        "Check shop for exchange"
    ]
    
    weak var delegate: HomeViewModelDelegate?
    private var userId: String? {
        return Auth.auth().currentUser?.uid
    }
    var bikes = [Bike]()
    var locations = [CLLocation]()
    var currentIndex = 0
    var timer: Timer?
    var username: String?
    var image: String?
    var cheapBikes = [Bike]()
    var filteredBikes = [Bike]()
    var currentUsersBikes = [Bike]()
    
    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 3.5, target: self, selector: #selector(automateSlider), userInfo: nil, repeats: true)
    }
    
    @objc func automateSlider() {
        let nextPage = currentIndex + 1
        let positionToScroll: IndexPath
        
        if nextPage < salesImagesArray.count {
            positionToScroll = IndexPath(item: nextPage, section: 0)
        } else {
            positionToScroll = IndexPath(item: 0, section: 0)
        }
        
        currentIndex = positionToScroll.item
        
        delegate?.scrollToItem(at: positionToScroll, animated: true)
        delegate?.updatePageControl(currentPage: currentIndex)
    }
    
    func pageControlChanged(to page: Int) {
        let selectedPage = page
        let positionToScroll = IndexPath(item: selectedPage, section: 0)
        
        delegate?.scrollToItem(at: positionToScroll, animated: true)
        currentIndex = selectedPage
    }
    
    func fetchUserInfo() {
        guard let userId = userId else {
            print("User not authenticated")
            return
        }
        
        let userRef = db.collection("users").document(userId)
        
        userRef.getDocument { [weak self] document, error in
            guard let self = self else { return }
            
            if let document = document, document.exists {
                do {
                    let userInfo = try document.data(as: UserInfo.self)
                    DispatchQueue.main.async {
                        self.username = userInfo.username ?? "Username"
                        self.image = userInfo.image ?? "https://i.pinimg.com/736x/00/37/e6/0037e6acc12861555781ceb897668c66.jpg"
                    }
                } catch {
                    print("Failed to fetch user info:\(error.localizedDescription)")
                    print("Error details:\(error)")
                }
            } else {
                print("Document doesn't exist")
            }
        }
    }
    
    // MARK: - Fetching data
    
    func fetchData(completion: @escaping () -> Void) {
        db.collection("bikes").order(by: "price", descending: false).getDocuments { (querySnapshot, error) in
            if let error = error {
                completion()
                return
            }
            
            guard let documents = querySnapshot?.documents else {
                completion()
                return
            }
            
            
            self.bikes = documents.compactMap { document in
                do {
                    let bike = try document.data(as: Bike.self)
                    return bike
                } catch {
                    return nil
                }
            }
            
            if self.bikes.count >= 8 {
                self.cheapBikes = Array(self.bikes.prefix(7))
            } else {
                self.cheapBikes = self.bikes
            }
            
            self.locations = self.bikes.map { CLLocation(latitude: $0.location.latitude, longitude: $0.location.longitude) }
            self.currentUsersBikes = self.bikes.filter( {$0.ownerID == self.userId})
            print("current users bikes are: \(self.currentUsersBikes)")
            completion()
        }
    }
    
    // MARK: - Filtering bikes
    
    func getBikesByGeometryType(geometry: String) {
        switch geometry {
        case "road":
            filteredBikes = bikes.filter( {$0.geometry.lowercased() == "road"})
        case "mountain":
            filteredBikes = bikes.filter( {$0.geometry.lowercased() == "mountain"})
        case "hybrid":
            filteredBikes = bikes.filter( {$0.geometry.lowercased() == "hybrid"})
        default:
            filteredBikes = bikes
        }
    }
    
}

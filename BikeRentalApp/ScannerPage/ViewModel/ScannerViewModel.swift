//
//  ScannerViewModel.swift
//  BikeRentalApp
//
//  Created by Tamuna Kakhidze on 21.07.24.
//

import Foundation
import FirebaseFirestore

// MARK: - Protocols

protocol ScannerViewModelDelegate: AnyObject {
    func bikeFetched(bike: Bike)
}

// MARK: - ScannerViewModel

class ScannerViewModel {
    
    // MARK: - Properties

    weak var delegate: ScannerViewModelDelegate?
    
    // MARK: - Fetching

    func fetchBikes(bikeId: String) {
        let trimmedBikeId = bikeId.trimmingCharacters(in: .whitespacesAndNewlines)
        print("trimmed bike ID: '\(trimmedBikeId)'")
        
        let bikesCollectionRef = Firestore.firestore().collection("bikes")
        
        FirestoreService.shared.fetchCollectionData(from: bikesCollectionRef, as: Bike.self) { [weak self] result in
            print("fetch result: \(result)")
            
            switch result {
            case .success(let bikes):
                print("fetched bikes count: \(bikes.count)")
                
                for bike in bikes {
                    let trimmedScannerId = bike.bicycleID.trimmingCharacters(in: .whitespacesAndNewlines)
                    print("fetched bike scannerId: '\(trimmedScannerId)'")
                }
                
                if let bike = bikes.first(where: { $0.bicycleID.trimmingCharacters(in: .whitespacesAndNewlines) == trimmedBikeId }) {
                    print("bike found: \(bike)")
                    self?.delegate?.bikeFetched(bike: bike)
                } else {
                    print("no bike found with scanner ID: '\(trimmedBikeId)'")
                }
                
            case .failure(let error):
                print("fetch failure: \(error.localizedDescription)")
            }
        }
    }
}

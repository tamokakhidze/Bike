//
//  BikeService.swift
//  BikeRentalApp
//
//  Created by Tamuna Kakhidze on 10.07.24.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

final class BikeService {
    let db = Firestore.firestore()
    public static let shared = BikeService()
    private init() {}
    let authorizedUser = Auth.auth().currentUser
    
    public func rentBike(with booking: Booking, completion: @escaping (Bool, Error?) -> Void) {
        checkAvailability(for: booking) { available, error in
            if let error = error {
                print("error checking availability: \(error.localizedDescription)")
                completion(false, error)
                return
            }
            
            guard available else {
                print("bike not available")
                completion(false, nil)
                return
            }
            
            var updatedBooking = booking
            if let currentUser = Auth.auth().currentUser {
                updatedBooking.userID = currentUser.uid
            } else {
                print("user is not logged in")
                completion(false, nil)
                return
            }
            
            let bookings = self.db.collection("bookings")
            bookings.addDocument(data: updatedBooking.dictionary as [String : Any]) { error in
                if let error = error {
                    print("error adding booking to firestore: \(error.localizedDescription)")
                    completion(false, error)
                } else {
                    print("booking added to firestore")
                    self.updateUserCurrentRentals(for: updatedBooking.userID, with: updatedBooking) { success, error in
                        if success {
                            print("Current rentals updated successfully for user")
                        }
                        else {
                            print("Error updating user's current rentals while renting bike")
                        }
                    }
                    self.givePointsToUser(to: updatedBooking.userID) { success, error in
                        if success {
                            print("User's points updated +100")
                        }
                        else {
                            print("error giving +100 points to user")
                        }
                        completion(true, nil)
                    }
                    
                }
            }
        }
    }
    
    public func checkAvailability(for bookingRequest: Booking, completion: @escaping (Bool, Error?) -> Void) {
        let requestedStartTime = bookingRequest.startTime
        let requestedEndTime = bookingRequest.endTime
        let bicycleId = bookingRequest.bicycleID
        
        let bookings = db.collection("bookings")
        let query = bookings.whereField("bicycleID", isEqualTo: bicycleId)
                            .whereField("startTime", isLessThanOrEqualTo: requestedEndTime)
                            .whereField("endTime", isGreaterThanOrEqualTo: requestedStartTime)
        
        query.getDocuments { querySnapshot, error in
            if let error = error {
                print("error getting data: \(error.localizedDescription)")
                completion(false, error)
                return
            }
            
            if let documents = querySnapshot?.documents, !documents.isEmpty {
                print("bike is not available in this period")
                completion(false, nil)
            } else {
                print("bike is available")
                completion(true, nil)
            }
        }
    }
    
    public func updateUserCurrentRentals(for userID: String, with bookingData: Booking, completion: @escaping (Bool, Error?) -> Void) {
        let userRef = db.collection("users").document(userID)
        
        userRef.getDocument { document, error in
            if let error = error {
                print("Error fetching user document: \(error.localizedDescription)")
                completion(false, error)
                return
            }
            
            do {
                var userInfo = try document?.data(as: UserInfo.self)
                if userInfo == nil {
                    userInfo = UserInfo(documentID: userID, currentRentals: [bookingData], points: 0)
                } else {
                    if userInfo?.currentRentals == nil {
                        userInfo?.currentRentals = [bookingData]
                    } else {
                        userInfo?.currentRentals?.append(bookingData)
                    }
                }
                
                try userRef.setData(from: userInfo!) { error in
                    if let error = error {
                        print("Error updating user document: \(error.localizedDescription)")
                        completion(false, error)
                    } else {
                        print("Current rentals updated successfully")
                        completion(true, nil)
                    }
                }
            } catch {
                print("Error decoding user document: \(error.localizedDescription)")
                completion(false, error)
            }
        }
    }

    public func givePointsToUser(to userID: String, completion: @escaping (Bool, Error?) -> Void) {
         let user = db.collection("users").document(userID)
         
         user.getDocument { (document, error) in
             if let document = document {
                 let currentPoints = document.data()?["points"] as? Int ?? 0
                 user.updateData(["points": currentPoints + 100]) { error in
                     if let error = error {
                         print("Error updating points: \(error.localizedDescription)")
                         completion(false, error)
                     } else {
                         print("Points successfully updated")
                         completion(true, nil)
                     }
                 }
             } else {
                 print("User does not exist")
                 completion(false, nil)
             }
         }
    }
}

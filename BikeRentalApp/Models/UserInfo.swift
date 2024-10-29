//
//  UserInfo.swift
//  BikeRentalApp
//
//  Created by Tamuna Kakhidze on 12.07.24.
//

import FirebaseFirestoreSwift

struct UserInfo: Identifiable, Codable {
    @DocumentID var documentID: String?
    var username: String?
    var email: String?
    var currentRentals: [Booking]?
    var points: Int?
    var image: String?
    var receivedInvitations: [String]? //add this
    
    var id: String? {
        documentID
    }
}

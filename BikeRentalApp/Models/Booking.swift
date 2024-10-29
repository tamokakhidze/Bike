//
//  Booking.swift
//  BikeRentalApp
//
//  Created by Tamuna Kakhidze on 10.07.24.
//

import Foundation

struct Booking: Codable {
    var bookingID: String
    var startTime: String
    var endTime: String
    var userID: String
    var bicycleID: String
    var totalPrice: String

    init(dictionary: [String: Any?]) {
        self.bookingID = dictionary["bookingID"] as? String ?? ""
        self.startTime = dictionary["startTime"] as? String ?? ""
        self.endTime = dictionary["endTime"] as? String ?? ""
        self.userID = dictionary["userID"] as? String ?? ""
        self.bicycleID = dictionary["bicycleID"] as? String ?? ""
        self.totalPrice = dictionary["totalPrice"] as? String ?? ""
    }

    var dictionary: [String: Any?] {
        return [
            "bookingID": bookingID,
            "startTime": startTime,
            "endTime": endTime,
            "userID": userID,
            "bicycleID": bicycleID,
            "totalPrice": totalPrice
        ]
    }
}

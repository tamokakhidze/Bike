//
//  BookingAttributes.swift
//  BikeRentalApp
//
//  Created by Tamuna Kakhidze on 27.08.24.
//

import Foundation
import ActivityKit

struct BookingAttributes: ActivityAttributes {
    struct ContentState: Codable, Hashable {
        var status: Status = .bookingStarted
    }
    
    var bookingNumber: Int
    var bookingItems: String
}

enum Status: String, CaseIterable, Equatable, Codable {
    case bookingStarted = "fitness.timer"
    case bookingEnded = "return"
}

//
//  Bike.swift
//  BikeRentalApp
//
//  Created by Tamuna Kakhidze on 08.07.24.
//

import Foundation
import FirebaseFirestoreSwift
import CoreLocation
import FirebaseFirestore

struct Bike: Identifiable, Codable {
    @DocumentID var id: String?
    var bicycleID: String
    var price: Double
    var year: Int
    var hasLights: Bool
    var numberOfGears: Int
    var geometry: String
    var locationLatitude: Double
    var locationLongitude: Double
    var brakeType: String
    var image: String
    var detailedImages: [String]
    var hasHelmet: Bool
    var helmetPrice: Double
    var ownerID: String?
    
    var location: CLLocationCoordinate2D {
        get {
            CLLocationCoordinate2D(latitude: locationLatitude, longitude: locationLongitude)
        }
        set {
            locationLatitude = newValue.latitude
            locationLongitude = newValue.longitude
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case bicycleID
        case price
        case year
        case hasLights
        case numberOfGears
        case geometry
        case location
        case brakeType
        case image
        case detailedImages
        case hasHelmet
        case helmetPrice
        case ownerID
        case locationLatitude
        case locationLongitude
    }
    
    init(bicycleID: String,
         price: Double, year: Int, hasLights: Bool, numberOfGears: Int, geometry: String, locationLatitude: Double, locationLongitude: Double, brakeType: String, image: String, detailedImages: [String], hasHelmet: Bool, helmetPrice: Double, ownerID: String) {
        self.bicycleID = bicycleID
        self.price = price
        self.year = year
        self.hasLights = hasLights
        self.numberOfGears = numberOfGears
        self.geometry = geometry
        self.locationLatitude = locationLatitude
        self.locationLongitude = locationLongitude
        self.brakeType = brakeType
        self.image = image
        self.detailedImages = detailedImages
        self.hasHelmet = hasHelmet
        self.helmetPrice = helmetPrice
        self.ownerID = ownerID
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(String.self, forKey: .id)
        self.bicycleID = try container.decodeIfPresent(String.self, forKey: .bicycleID) ?? ""
        self.price = try container.decodeIfPresent(Double.self, forKey: .price) ?? 0.0
        self.year = try container.decodeIfPresent(Int.self, forKey: .year) ?? 0
        self.hasLights = try container.decodeIfPresent(Bool.self, forKey: .hasLights) ?? false
        self.numberOfGears = try container.decodeIfPresent(Int.self, forKey: .numberOfGears) ?? 0
        self.geometry = try container.decodeIfPresent(String.self, forKey: .geometry) ?? ""
        self.brakeType = try container.decodeIfPresent(String.self, forKey: .brakeType) ?? ""
        self.image = try container.decodeIfPresent(String.self, forKey: .image) ?? ""
        self.detailedImages = try container.decodeIfPresent([String].self, forKey: .detailedImages) ?? []
        self.hasHelmet = try container.decodeIfPresent(Bool.self, forKey: .hasHelmet) ?? false
        self.helmetPrice = try container.decodeIfPresent(Double.self, forKey: .helmetPrice) ?? 0.0
        self.ownerID = try container.decodeIfPresent(String.self, forKey: .ownerID) ?? "No owner"
        let geoPoint = try container.decode(FirebaseFirestore.GeoPoint.self, forKey: .location)
        self.locationLatitude = geoPoint.latitude
        self.locationLongitude = geoPoint.longitude
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(bicycleID, forKey: .bicycleID)
        try container.encode(price, forKey: .price)
        try container.encode(year, forKey: .year)
        try container.encode(hasLights, forKey: .hasLights)
        try container.encode(numberOfGears, forKey: .numberOfGears)
        try container.encode(geometry, forKey: .geometry)
        try container.encode(brakeType, forKey: .brakeType)
        try container.encode(image, forKey: .image)
        try container.encode(detailedImages, forKey: .detailedImages)
        try container.encode(hasHelmet, forKey: .hasHelmet)
        try container.encode(helmetPrice, forKey: .helmetPrice)
        try container.encode(ownerID, forKey: .ownerID)
        let geoPoint = GeoPoint(latitude: locationLatitude, longitude: locationLongitude)
        try container.encode(geoPoint, forKey: .location)
    }
}

//
//  Product.swift
//  BikeRentalApp
//
//  Created by Tamuna Kakhidze on 18.07.24.
//

import Foundation

struct Product: Identifiable, Decodable, Equatable {
    var id: String
    let name: String
    var price: Double
    var quantity: Int
    let image: String
    let category: String
    let categoryImage: String
}

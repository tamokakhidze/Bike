//
//  DetectionResultValidator.swift
//  BikeRentalApp
//
//  Created by Tamuna Kakhidze on 22.07.24.
//

import Foundation

class DetectionResultValidator {
    private let whitelist: Set<String>

    init() {
        whitelist = ["tricycle", "trike", "velocipede", "bicycle-built-for-two", "tandem bicycle", "tandem"]
    }

    func isValid(result: String?) -> Bool {
        guard let result = result else { return false }
        print(result)
        let resultsArray = result.split(separator: ",").map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }

        for item in resultsArray {
            if whitelist.contains(item) || item.contains("bicycle") || item.contains("bike") {
                return true
            }
        }

        return false
    }
}


//
//  Classifier.swift
//  BikeRentalApp
//
//  Created by Tamuna Kakhidze on 22.07.24.
//

import CoreML
import Vision
import CoreImage

struct Classifier {
    
    private(set) var isValid: Bool?
    
    mutating func detect(ciImage: CIImage) {
        
        guard let model = try? VNCoreMLModel(for: MobileNetV2(configuration: MLModelConfiguration()).model) else {
            return
        }
        
        let request = VNCoreMLRequest(model: model)
        
        let handler = VNImageRequestHandler(ciImage: ciImage, options: [:])
        
        try? handler.perform([request])
        
        guard let results = request.results as? [VNClassificationObservation] else {
            return
        }
        
        if let firstResult = results.first {
            let validator = DetectionResultValidator()
            self.isValid = validator.isValid(result: firstResult.identifier)
        }
        
    }
    
}



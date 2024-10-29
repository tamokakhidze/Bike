//
//  ImageExtension.swift
//  BikeRentalApp
//
//  Created by Tamuna Kakhidze on 03.07.24.
//

import UIKit

extension UIImageView {
    func setImage(with url: URL) {
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard
                let data = data, error == nil,
                let image = UIImage(data: data)
            else {
                return
            }
            DispatchQueue.main.async {
                self?.image = image
            }
        }.resume()
    }
}

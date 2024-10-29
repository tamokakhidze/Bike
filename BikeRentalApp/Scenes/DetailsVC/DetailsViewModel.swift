//
//  DetailsViewModel.swift
//  BikeRentalApp
//
//  Created by Tamuna Kakhidze on 19.07.24.
//

import Foundation

// MARK: - Protocols

protocol DetailsViewModelDelegate: AnyObject {
    func scaleUp()
    func scaleDown()
}

// MARK: - DetailsViewModel

class DetailsViewModel {
    
    // MARK: - Properties

    private var playButtonClicked = true
    weak var delegate: DetailsViewModelDelegate?
    
    // MARK: - Action methods

    @objc func playButtonClick(_ sender: Any) {
        
        if playButtonClicked {
            playButtonClicked = false
            delegate?.scaleDown()
            
        }
        else {
            playButtonClicked = true
            delegate?.scaleUp()
        }
    }
    
}


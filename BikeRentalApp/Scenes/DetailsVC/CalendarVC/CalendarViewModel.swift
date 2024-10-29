//
//  CalendarViewModel.swift
//  BikeRentalApp
//
//  Created by Tamuna Kakhidze on 13.07.24.
//

import Foundation
import FirebaseFirestore
import PassKit

// MARK: - Protocols

protocol CalendarViewModelDelegate: AnyObject {
    func showAlert(message: String, title: String)
    func updateAvailability(isAvailable: Bool)
    func showPaymentViewController(viewController: UIViewController, animated: Bool)
}

// MARK: - CalendarViewModel

class CalendarViewModel {
    
    // MARK: - Properties

    weak var delegate: CalendarViewModelDelegate?
    var isBikeAvailable: Bool = false
    var unavailableDates = [Date]()
    
    // MARK: - Methods

    func checkAvailability(for bike: Bike, startTime: Date, endTime: Date) {
        let dateFormatter = ISO8601DateFormatter()
        let startTimeString = dateFormatter.string(from: startTime)
        let endTimeString = dateFormatter.string(from: endTime)
        
        let booking = Booking(dictionary: [
            "startTime": startTimeString,
            "endTime": endTimeString,
            "bicycleID": bike.bicycleID
        ])
        print(bike.bicycleID)
        BikeService.shared.checkAvailability(for: booking) { [weak self] available, error in
            if let error = error {
                print("Error checking availability: \(error.localizedDescription)")
            } 
            else {
                self?.delegate?.updateAvailability(isAvailable: available)
                
                if available {
                    self?.delegate?.showAlert(message: "Bike is available", title: "Click rent button to proceed payment")
                } 
                else {
                    self?.delegate?.showAlert(message: "Bike is not available", title: "Please choose other dates")
                }
            }
        }
    }
    
    func rentBike(startTime: Date, endTime: Date, bike: Bike, isHelmetChosen: Bool) {
        let startTime = startTime
        let endTime = endTime
        let diffComponents = Calendar.current.dateComponents([.hour], from: startTime, to: endTime)
        guard let hours = diffComponents.hour else { return  }
        var totalPrice = bike.price * Double(hours)
        
        if isHelmetChosen {
            totalPrice += bike.helmetPrice * Double(hours)
        }
        
        print(isHelmetChosen, "on calencar view")
        
        let request = createRequest(price: totalPrice)
        
        if let paymentVC = PKPaymentAuthorizationViewController(paymentRequest: request) {
            self.delegate?.showPaymentViewController(viewController: paymentVC, animated: true)
        } else {
            self.delegate?.showAlert(message: "Payment not possible", title: "Please try again")
        }
    }
    
    func createRequest(price: Double) -> PKPaymentRequest {
      
        let request = PKPaymentRequest()
        request.merchantIdentifier = "TK"
        request.supportedNetworks = [.visa, .amex, .masterCard]
        request.supportedCountries = ["GE", "US"]
        request.merchantCapabilities = .capability3DS
        request.countryCode = "GE"
        request.currencyCode = "GEL"
        request.paymentSummaryItems = [PKPaymentSummaryItem(label: "for bike rental", amount: NSDecimalNumber(value: price))]
        
        return request
    }

}

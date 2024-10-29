//
//  ShopViewModel.swift
//  BikeRentalApp
//
//  Created by Tamuna Kakhidze on 18.07.24.
//

import Foundation
import NetworkServicePackage

class ShopViewModel: ObservableObject {
    
    // MARK: - Properties
    
    @Published var productsList = [Product]()
    @Published var productCategories = [String]()
    @Published var cartItems = [Product]()
    @Published var couponCodes = ["7mayerrs", "35mm", "Tbcxusaid"]
    @Published var discountValue: Double?

    private let url = "https://mocki.io/v1/2a31ac2c-2f00-4592-bbcf-960d6b366b63"
    
    // MARK: - Fetching Data
    
    func viewAppeared() {
        fetchData() { [weak self] result in
            switch result {
            case .success(let success):
                self?.productsList = success
                let products = success.map( {$0.category} )
                let orderedCategories = products.reduce(into: [String]()) { result, category in
                    if !result.contains(category) {
                        result.append(category)
                    }
                }
                self?.productCategories = orderedCategories
                print(self?.productCategories ?? [Product]())
            case .failure(let failure):
                print("fetching failed. \(failure)")
            }
        }
    }
    
    func fetchData(completion: @escaping (Result<[Product],Error>) ->(Void)) {
        NetworkService().getData(urlString: url, completion: completion)
    }
    
    // MARK: - Shopping methods
    
    func getRandomDiscount() {
        discountValue = Double.random(in: 0.2...0.5)
        print(discountValue ?? 0.0)
    }
    
    func checkCouponCode(code: String) -> Bool {
        return couponCodes.contains(code)
    }
    
    func increaseProductQuantity(for product: Product) {
        addItemToCart(item: product)
        if let index = productsList.firstIndex(where: { $0.id == product.id }) {
            productsList[index].quantity += 1
        }
    }
    
    func decreaseProductQuantity(for product: Product) {
        removeItemFromCart(item: product)
        if let index = productsList.firstIndex(where: { $0.id == product.id }) {
            if productsList[index].quantity > 0 {
                productsList[index].quantity -= 1
            }
        }
    }
    
    func delete(for product: Product) {
        if let index = productsList.firstIndex(where: { $0.id == product.id }) {
            productsList[index].quantity = 0
        }
    }
    
    func calculateTotalQuantity() -> Int {
        return productsList.reduce(0) { $0 + $1.quantity }
    }
    
    func calculateTotalPrice() -> Double {
        let totalPrice = productsList.reduce(0.0) { $0 + Double($1.quantity) * $1.price }
        return Double(round(totalPrice * 100) / 100)
    }
    
    func applyDiscount() {
        guard let discountValue = discountValue else { return }
        for index in productsList.indices {
            productsList[index].price -= productsList[index].price * discountValue
        }
    }
    
    func formatPrice(for product: Product) -> String {
        if productsList.contains(where: { $0.id == product.id }) {
            return String(format: "%.2f", product.price) + "$"
        }
        return "0.0"
    }
    
    var formattedPrice: String {
        return String(format: "%.2f", calculateTotalPrice()) + "$"
    }
    
    var total: Double {
        return cartItems.reduce(0) { $0 + $1.price }
    }
    
    func calculateDiscountedTotal(isCodeCorrect: Bool) -> Double {
        let discountRate = discountValue ?? 0.2
        let totalPrice = calculateTotalPrice()
        return isCodeCorrect ? totalPrice * (1 - discountRate) : totalPrice
    }
    
    func addItemToCart(item: Product) {
        cartItems.append(item)
        print(cartItems.count)
    }
    
    func removeItemFromCart(item: Product) {
        if let index = cartItems.firstIndex(of: item) {
            cartItems.remove(at: index)
        }
    }
}

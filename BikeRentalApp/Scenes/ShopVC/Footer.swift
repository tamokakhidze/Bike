//
//  Footer.swift
//  BikeRentalApp
//
//  Created by Tamuna Kakhidze on 18.07.24.
//

import SwiftUI

// MARK: - Footer

struct Footer: View {
    
    // MARK: - Properties
    
    @EnvironmentObject var viewModel: ShopViewModel
    @Binding var showPopup: Bool
    @Binding var isCodeCorrect: Bool
    
    // MARK: - Body
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 10) {
                
                HStack(alignment: .bottom) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Total items : \(viewModel.cartItems.count)")
                            .font(.system(size: 14, weight: .regular))
                        
                        let total = viewModel.calculateDiscountedTotal(isCodeCorrect: isCodeCorrect)
                        Text("$ \(String(format: "%.2f", total))")
                            .font(.system(size: 20, weight: .regular))
                    }
                    
                    Spacer()
                    ZStack {
                        VStack {
                            Button("Coupon") {
                                withAnimation {
                                    showPopup = true
                                }
                            }
                            .frame(width: 100, height: 50)
                            .background(.shopSecondary)
                            .cornerRadius(50)
                            .foregroundColor(.primaryDeep)
                        }
                    }
                    
                    Link("Pay", destination: URL(string: "https://www.google.com")!)
                        .frame(width: 100, height: 50)
                        .background(.shopSecondary)
                        .cornerRadius(50)
                        .foregroundColor(.primaryDeep)
                }
                Spacer()
                
            }
            .padding(25)
            .padding(.top, 25)
            .cornerRadius(30)
            .background(.primaryDeep)
            .foregroundStyle(.white)
            
        }.frame(height: 100)
            .cornerRadius(30)
        
    }
}

// MARK: - CustomPopupView

struct CustomPopupView: View {
    
    // MARK: - Properties
    
    @Binding var showPopup: Bool
    @Binding var couponCode: String
    @ObservedObject var viewModel: ShopViewModel
    @Binding var isCodeCorrect: Bool
    
    // MARK: - Body
    
    var body: some View {
        VStack {
            Spacer()
            VStack(spacing: 20) {
                HStack {
                    Text("Enter coupon code")
                        .font(.headline)
                    
                    Button(action: {
                        showPopup = false
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.black)
                            .font(.system(size: 24))
                    }
                }
                
                TextField("code", text: $couponCode)
                Button("Check") {
                    withAnimation {
                        isCodeCorrect = viewModel.checkCouponCode(code: couponCode)
                        print(isCodeCorrect)
                    }
                }
                .padding()
                .background(Color.secondaryText)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
            .padding()
            .background(Color.white)
            .cornerRadius(20)
            .shadow(color: .gray.opacity(0.2), radius: 10)
            
            .padding()
            Spacer()
        }
        .background(Color.black.opacity(0.2))
        
    }
}

#Preview {
    ProductsListView(category: "Helmets")
        .environmentObject(ShopViewModel())
}


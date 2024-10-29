//
//  RentHistoryCell.swift
//  BikeRentalApp
//
//  Created by Tamuna Kakhidze on 05.07.24.
//

import SwiftUI

// MARK: - RentHistoryCell

struct RentHistoryCell: View {
    
    // MARK: - Properties

    @State var rating: Int = 0
    @State private var isPresented: Bool = false
    @State var showAlert: Bool = false
    @ObservedObject var viewModel: ProfileViewModel
    
    var number: Int
    var totalPrice: Double
    var startTime: Date
    var endTime: Date
    var isRentEnded: Bool = false
    var rateAction: () -> Void
    
    // MARK: - Body

    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading, spacing: 11) {
                    Text("Bike number: \(number)")
                        .font(.system(size: 20))
                        .foregroundColor(.white)
                        .bold()
                    
                    Text(String(format: "%.2f$", totalPrice))
                        .font(.system(size: 12))
                        .foregroundColor(.white)
                    
                    Text("\(startTime)")
                        .font(.system(size: 12))
                        .foregroundColor(.white)
                    
                    Text("\(endTime)")
                        .font(.system(size: 12))
                        .foregroundColor(.white)
                    
                }.frame(width: 170)
                
                Spacer()
                
                if isRentEnded {
                    Button(action: {
                        isPresented.toggle()
                    }) {
                        VStack {
                            StarRatingView(rating: $rating)
                            Button("Send rating") {
                                viewModel.rateBike()
                                showAlert.toggle()
                            }
                            .alert(isPresented: $showAlert, content: {
                                Alert(
                                    title: Text("Thank you"),
                                    message: Text("Your rating was sent"),
                                    primaryButton: .default(Text("OK")),
                                    secondaryButton: .cancel()
                                )
                            })
                        }
                    }
                } else {
                    Image(systemName: "star.slash.fill")
                        .resizable()
                        .foregroundColor(.white)
                        .frame(width: 32, height: 32)
                }
            }
            
            Divider()
                .frame(height: 1)
                .background(Color.gray.opacity(0.5))
        }
    }
}

#Preview {
    RentHistoryCell(viewModel: ProfileViewModel(), number: 2, totalPrice: 3.9, startTime: Date.now, endTime: Date.now, isRentEnded: true, rateAction: {}).background(.black)
}

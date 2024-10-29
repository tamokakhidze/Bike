//
//  RentalHistoryView.swift
//  BikeRentalApp
//
//  Created by Tamuna Kakhidze on 03.09.24.
//

import SwiftUI

struct RentalHistoryView: View {
    
    @StateObject private var viewModel = ProfileViewModel()
    
    var body: some View {
        ZStack {
            //Image(.waves)
            
            VStack(spacing: 28) {
                Text("Rental History")
                    .font(.system(size: 40))
                    .foregroundStyle(.darkBlue)
                    .fontWeight(.bold)
                Text("Current and past")
                    .font(.system(size: 18))
                    .foregroundStyle(.gray.opacity(0.4))
                    .fontWeight(.semibold)
                
                ZStack {
                    Rectangle()
                        .fill(.white)
                        .frame(width: 311, height: 166)
                        .cornerRadius(20)
                        .clipShape(UnevenRoundedRectangle(style: .continuous))
                        .shadow(color: Color.black.opacity(0.03), radius: 4, x: 0, y: 4)
                    
                    ScrollView(.vertical) {
                        VStack(alignment: .leading) {
                            ForEach(0..<viewModel.ongoingRentals.count, id: \.self) { index in
                                let rental = viewModel.ongoingRentals[index]
                                RentCell(viewModel: viewModel, number: index,
                                         totalPrice: Double(rental.totalPrice) ?? 0.0,
                                         startTime: viewModel.formatDate(dateString: rental.startTime),
                                         endTime: viewModel.formatDate(dateString: rental.endTime),
                                         isRentEnded: viewModel.formatDate(dateString: rental.endTime) <= Date(),
                                         rateAction: {
                                    viewModel.rateBike()
                                }
                                )
                            }.padding()
                        }.frame(maxWidth: .infinity, maxHeight: .infinity)
                    }.frame(width: 311, height: 166)
                    
                }
                
                ZStack {
                    Rectangle()
                        .fill(.white)
                        .frame(height: 166)
                        .cornerRadius(20)
                        .clipShape(UnevenRoundedRectangle(style: .continuous))
                        .shadow(color: Color.black.opacity(0.03), radius: 4, x: 0, y: 4)
                    
                    ScrollView(.vertical) {
                        VStack(alignment: .leading) {
                            ForEach(0..<viewModel.finishedRentals.count, id: \.self) { index in
                                
                                let rental = viewModel.finishedRentals[index]
                                RentCell(viewModel: viewModel, number: index,
                                                totalPrice: Double(rental.totalPrice) ?? 0.0,
                                                startTime: viewModel.formatDate(dateString: rental.startTime),
                                                endTime: viewModel.formatDate(dateString: rental.endTime),
                                                isRentEnded: viewModel.formatDate(dateString: rental.endTime) <= Date(),
                                                rateAction: {
                                    viewModel.rateBike()
                                }
                                )
                            }.padding()
                        }.frame(maxWidth: .infinity, maxHeight: .infinity)
                    }.frame(width: 311, height: 166)
                }
                
            }
            
        }
        .onAppear {
            viewModel.fetchUserInfo()
        }
    }
}

// MARK: - RentHistoryCell

struct RentCell: View {
    
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
                    
                    Text("Bike Number \(number), \(String(format: "%.2f$", totalPrice))")
                        .font(.system(size: 18))
                        .foregroundColor(.darkBlue)
                        .fontWeight(.semibold)
                    
                    
                    Text("\(startTime)")
                        .font(.system(size: 12))
                        .foregroundColor(.gray.opacity(0.4))
                        .fontWeight(.semibold)
                    
                    Text("\(endTime)")
                        .font(.system(size: 12))
                        .foregroundColor(.gray.opacity(0.4))
                        .fontWeight(.semibold)
                    
                }
                .frame(width: 200)
                
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
                        .foregroundColor(.darkBlue)
                        .frame(width: 32, height: 32)
                }
            }
        }.padding()
    }
}

//#Preview {
//    RentCell(viewModel: ProfileViewModel(), number: 2, totalPrice: 3.9, startTime: Date.now, endTime: Date.now, isRentEnded: false, rateAction: {}).background(.black)
//}

#Preview {
    RentalHistoryView()
}

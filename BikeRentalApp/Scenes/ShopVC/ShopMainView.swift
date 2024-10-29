//
//  ShopMainView.swift
//  BikeRentalApp
//
//  Created by Tamuna Kakhidze on 18.07.24.
//

import SwiftUI

// MARK: - ShopMainView

struct ShopMainView: View {
    
    // MARK: - Properties

    @EnvironmentObject var viewModel: ShopViewModel
    @State var couponCode: String = ""
    @State var isCodeCorrect: Bool = false
    
    // MARK: - Body

    var body: some View {
        NavigationStack {
            ScrollView(.vertical) {
                VStack(alignment: .leading, spacing: 20) {
                    Spacer()
                        .frame(height: 80)
                    
                    HStack {
                        Spacer()
                        ZStack(alignment: .topTrailing) {
                            Image("cartImage")
                                .resizable()
                                .frame(width: 35, height: 35)
                            
                            Circle()
                                .frame(width: 20, height: 20)
                                .foregroundStyle(.red)
                                .offset(x: 7, y: -7)
                            
                            Text("\(viewModel.cartItems.count)")
                                .foregroundStyle(.white)
                                .fontWeight(.medium)
                                .offset(x: 3, y: -7)
                        }
                    }
                    
                    Text("Shop essentials for your ride")
                        .fontWeight(.medium)
                        .font(.system(size: 20))
                        .foregroundStyle(.primaryDeep)
                    
                    ZStack(alignment: .leading) {
                        Rectangle()
                            .frame(height: 157)
                            .foregroundColor(.darkBlue.opacity(0.95))
                            .cornerRadius(18)
                            .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 10)
                        
                        VStack(alignment: .leading) {
                            Text("Receive surprise coupon!")
                                .foregroundStyle(.white)
                                .fontWeight(.regular)
                                .font(.system(size: 20))
                                .frame(alignment: .leading)
                            
                            Button("Check") {
                                viewModel.getRandomDiscount()
                            }
                            .frame(width: 100, height: 50)
                            .background(.cellBackground)
                            .cornerRadius(50)
                            .foregroundColor(.primaryDeep)
                            
                        }
                        .padding()
                        
                        
                    }
                    
                    Text("New arrivals")
                        .fontWeight(.medium)
                        .font(.system(size: 20))
                        .foregroundStyle(.primaryDeep)
                    
                    ScrollView(.horizontal) {
                        
                        LazyHGrid(rows: [GridItem(.fixed(353))], spacing: 20) {
                            ForEach(Array(viewModel.productCategories), id: \.self) { category in
                                if let product = viewModel.productsList.first(where: {$0.category == category}) {
                                    NavigationLink(destination: ProductsListView(category: category)) {
                                        CategoriesCell(image: product.categoryImage, categoryName: category, startingPrice: 19)
                                            .background(.shopSecondary)
                                            .cornerRadius(18)
                                            .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 10)
                                    }
                                }
                            }
                        }
                    }
                    
                    Text("Discover stores")
                        .fontWeight(.medium)
                        .font(.system(size: 20))
                        .padding(.bottom, 100)
                        .foregroundStyle(.primaryDeep)
                    
                }
                .onAppear {
                    viewModel.viewAppeared()
                }
                .padding(.leading, 24)
                .padding(.trailing, 24)
                
                
            }
            .background(Color.background).ignoresSafeArea()
            
        }
    }
}

#Preview {
    ShopMainView()
        .environmentObject(ShopViewModel())
}

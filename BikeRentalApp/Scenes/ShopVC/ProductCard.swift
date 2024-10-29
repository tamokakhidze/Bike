//
//  ProductCard.swift
//  BikeRentalApp
//
//  Created by Tamuna Kakhidze on 18.07.24.
//

import SwiftUI

// MARK: - ProductCard

struct ProductCard: View {
    
    // MARK: - Properties

    @EnvironmentObject var viewModel: ShopViewModel
    var product: Product
    
    // MARK: - Body

    var body: some View {
        HStack(spacing: 0) {
            ZStack {
                Rectangle()
                    .frame(width: 106, height: 106)
                    .cornerRadius(15)
                    .foregroundStyle(.clear)
                
                AsyncImage(url: URL(string: product.image)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .scaledToFill()
                        .clipped()
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 106, height: 106)
                .cornerRadius(15)
            }

            .clipShape(RoundedRectangle(cornerRadius: 8))
            
            VStack(alignment: .leading, spacing: 10) {
                Text(product.name)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(.primaryDeep)
                
                HStack(alignment: .bottom) {
                    Text("\(viewModel.formatPrice(for: product))")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundStyle(.secondaryText)
                }
                
                Image("favIcon")
            }.padding(EdgeInsets(top: 19, leading: 14, bottom: 19, trailing: 18))
            
            Spacer()
            
            HStack {
                Button("-")
                {
                    viewModel.decreaseProductQuantity(for: product)
                }
                .frame(width: 30, height: 30)
                .background(.shopSecondary)
                .cornerRadius(8)
                .foregroundColor(.primaryDeep)
                
                
                Text("\(product.quantity)")
                
                Button("+")
                {
                  viewModel.increaseProductQuantity(for: product)                    
                }
                .frame(width: 30, height: 30)
                .background(.shopSecondary)
                .cornerRadius(8)
                .foregroundColor(.primaryDeep)
            }
            
            Spacer()
                .frame(width: 10)
            
        }
        .padding(10)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.cellBackground)
        .cornerRadius(20)
        .shadow(color: .black.opacity(0.04), radius: 10, x: 0, y: 10)
    }
}

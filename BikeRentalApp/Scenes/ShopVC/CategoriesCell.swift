//
//  CategoriesCell.swift
//  BikeRentalApp
//
//  Created by Tamuna Kakhidze on 18.07.24.
//

import SwiftUI

// MARK: - CategoriesCell

struct CategoriesCell: View {
    
    // MARK: - Properties

    var image: String
    var categoryName: String
    var startingPrice: Int
    
    // MARK: - Body

    var body: some View {
        ZStack {
            AsyncImage(url: URL(string: image)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .scaledToFill()
                    .clipped()
            } placeholder: {
                ProgressView()
            }
            .frame(width: 302, height: 353)
            .cornerRadius(15)
            
            VStack {
                Spacer()
                HStack {
                    VStack(alignment: .leading) {
                        Text("\(categoryName)")
                            .font(.system(size: 18))
                            .foregroundStyle(.white)
                            .fontWeight(.bold)
                
                        Text("Starting from \(startingPrice)$")
                            .font(.system(size: 18))
                            .foregroundStyle(.gray.opacity(0.7))
                            .fontWeight(.bold)
                    }
                     Spacer()
                    Image(systemName: "rectangle.portrait.and.arrow.forward.fill")
                        .foregroundStyle(.white.opacity(0.5))
                    
                }
                .padding(.bottom, 16)
                .padding()
                
            }
        }
        .frame(width: 302, height: 353)
        .cornerRadius(18)
    }
}


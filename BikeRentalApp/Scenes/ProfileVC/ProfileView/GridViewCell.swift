//
//  GridViewCell.swift
//  BikeRentalApp
//
//  Created by Tamuna Kakhidze on 05.07.24.
//

import SwiftUI

// MARK: - GridCellView

struct GridCellView: View {
    
    // MARK: - Properties

    var imageUrl: String
    var price: Double
    var type: String

    // MARK: - Body

    var body: some View {
        VStack(alignment:.leading) {
            AsyncImage(url: URL(string: imageUrl)) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                        .frame(width: 50, height: 50)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(8)
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 100, height: 60)
                case .failure:
                    Image(systemName: "xmark.circle")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 20, height: 20)
                        .padding()
                @unknown default:
                    EmptyView()
                }
            }
            Text(String(format: "%.2f$", price))
                .font(.system(size: 12))
                .fontWeight(.semibold)
                .foregroundStyle(.gray.opacity(0.4))
            
            Text(type)
                .font(.system(size: 18))
                .fontWeight(.semibold)
                .foregroundStyle(.darkBlue)
        }
        .frame(width: 144, height: 140)
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: .gray.opacity(0.2), radius: 10)
        
    }
}

#Preview {
    GridCellView(imageUrl: "https://i.pinimg.com/736x/22/39/9c/22399cf9dc52f9adfb7f2f33ce74775d.jpg", price: 5.4, type: "Hybrid")
}

//
//  StarRatingView.swift
//  BikeRentalApp
//
//  Created by Tamuna Kakhidze on 19.07.24.
//

import SwiftUI

struct StarRatingView: View {
    @Binding var rating: Int
    
    var body: some View {
        HStack {
            ForEach(1..<6) { index in
                Image(systemName: index <= rating ? "star.fill" : "star")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                    .foregroundColor(index <= rating ? .yellow : .gray)
                    .onTapGesture {
                        withAnimation {
                            rating = index
                        }
                    }
            }
        }
    }
}


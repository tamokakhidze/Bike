//
//  AlertView.swift
//  BikeRentalApp
//
//  Created by Tamuna Kakhidze on 20.07.24.
//

import SwiftUI

struct AlertView: View {
    @Binding var showPopup: Bool
    @Binding var message: String
    
    var body: some View {
        VStack {
            Spacer()
            VStack(spacing: 20) {
                HStack {
                    Text("\(message)")
                        .font(.headline)
                    
                    Button(action: {
                        showPopup = false
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.black)
                            .font(.system(size: 24))
                    }
                }
                
            }
            .padding()
            .background(Color.white)
            .cornerRadius(20)
            .shadow(color: .gray.opacity(0.2), radius: 10)
            
            .padding()
            Spacer()
        }.frame(width: 350, height: 200)
        
    }
}

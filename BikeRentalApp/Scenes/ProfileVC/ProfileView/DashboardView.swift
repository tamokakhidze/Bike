//
//  DashboardView.swift
//  BikeRentalApp
//
//  Created by Tamuna Kakhidze on 03.09.24.
//

import SwiftUI

struct DashboardView: View {
    
    var points: Int
    var rentalsCount: Int
    var invitations: Int
    
    @State private var showRentalHistory = false
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(.white)
                .frame(width: 311, height: 166)
                .cornerRadius(20)
                .clipShape(UnevenRoundedRectangle(style: .continuous))
                .shadow(color: Color.black.opacity(0.03), radius: 4, x: 0, y: 4)
            VStack {
                HStack {
                    Text("Dashboard")
                        .font(.system(size: 14))
                        .foregroundStyle(.darkBlue)
                        .fontWeight(.bold)
                }
                
                HStack(spacing: 47) {
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Image(systemName: "list.number")
                                .foregroundStyle(.darkBlue)
                            
                            VStack(alignment: .leading) {
                                Text("Points")
                                    .font(.system(size: 18))
                                    .foregroundStyle(.darkBlue)
                                    .fontWeight(.semibold)
                                
                                Text("\(points) Points")
                                    .font(.system(size: 12))
                                    .foregroundStyle(.gray.opacity(0.6))
                                    .fontWeight(.semibold)
                            }
                        }
                        
                        HStack {
                            Image(systemName: "clock.fill")
                                .foregroundStyle(.darkBlue)
                            
                            VStack(alignment: .leading) {
                                Text("History")
                                    .font(.system(size: 18))
                                    .foregroundStyle(.darkBlue)
                                    .fontWeight(.semibold)
                                
                                Button(action: {
                                    showRentalHistory = true
                                }) {
                                    Text("View details")
                                        .font(.system(size: 12))
                                        .foregroundStyle(.gray.opacity(0.6))
                                        .fontWeight(.semibold)
                                }
                            }
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Image(systemName: "bicycle.circle.fill")
                                .foregroundStyle(.darkBlue)
                            VStack(alignment: .leading) {
                                Text("Rentals")
                                    .font(.system(size: 18))
                                    .foregroundStyle(.darkBlue)
                                    .fontWeight(.semibold)
                                
                                Text("\(rentalsCount) bikes total")
                                    .font(.system(size: 12))
                                    .foregroundStyle(.gray.opacity(0.6))
                                    .fontWeight(.semibold)
                            }
                        }
                        
                        HStack {
                            Image(systemName: "person.fill.badge.plus")
                                .foregroundStyle(.darkBlue)
                            
                            VStack(alignment: .leading) {
                                Text("Invitations")
                                    .font(.system(size: 18))
                                    .foregroundStyle(.darkBlue)
                                    .fontWeight(.semibold)
                                
                                Text("\(invitations) new")
                                    .font(.system(size: 12))
                                    .foregroundStyle(.gray.opacity(0.6))
                                    .fontWeight(.semibold)
                            }
                        }
                    }
                }
            }
        }
        .sheet(isPresented: $showRentalHistory) {
            RentalHistoryView()
                .presentationDetents([.medium, .large])
                .presentationDragIndicator(.visible) 
        }
    }
}

#Preview {
    DashboardView(points: 800, rentalsCount: 5, invitations: 3)
}

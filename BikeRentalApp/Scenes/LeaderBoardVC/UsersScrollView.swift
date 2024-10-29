//
//  UsersScrollView.swift
//  BikeRentalApp
//
//  Created by Tamuna Kakhidze on 18.07.24.
//

import SwiftUI

// MARK: - UsersScrollView

struct UsersScrollView: View {
    
    // MARK: - Properties
    
    @ObservedObject var viewModel: LeaderBoardViewModel
    @Binding var invitationSent: Bool
    @Binding var message: String
    
    // MARK: - Body
    
    var body: some View {
        ScrollView {
            VStack() {
                ForEach(viewModel.users) { user in
                    if user.points ?? 0 > 0 {
                        ScrollItem(username: user.username ?? "Unknown", points: user.points ?? 0, image: user.image ?? "", viewModel: viewModel, userID: user.id ?? "", invitationSent: $invitationSent, message: $message)
                        
                    }
                }
            }
            .background(.white)
            .cornerRadius(40)
        }
    }
}


struct ScrollItem: View {
    
    let username: String
    let points: Int
    let image: String
    @ObservedObject var viewModel: LeaderBoardViewModel
    let userID: String
    @Binding var invitationSent: Bool
    @Binding var message: String
    
    var body: some View {
        HStack(spacing: 17) {
            
            ZStack {
                Circle()
                    .frame(width: 53, height: 53)
                    .foregroundStyle(.primaryDeep)
                    .presentationCornerRadius(50)
                
                AsyncImage(url: URL(string: image)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .scaledToFill()
                        .clipped()
                } placeholder: {
                    Image(systemName: "person.fill")
                }
                .frame(width: 50, height: 50)
                .cornerRadius(50)
                
            }
            
            VStack(alignment: .leading, spacing: 6) {
                Text("@"+username)
                    .fontWeight(.medium)
                    .font(.system(size: 12))
                    .foregroundStyle(.black)
                
                Button(action: {
                    viewModel.inviteUser(userID: userID)
                    invitationSent.toggle()
                }) {
                    Label("Invite", systemImage: "person.fill.badge.plus")
                        .frame(width: 80, height: 35)
                        .background(.ultraThinMaterial)
                        .cornerRadius(15)
                        .font(.system(size: 14))
                        .foregroundColor(.black)
                        .fontWeight(.medium)
                }
                
            }
            
            Spacer()
            
            Text("\(points) pts")
                .fontWeight(.bold) 
                .font(.system(size: 12))
                .foregroundStyle(.black)
        }
        .padding(EdgeInsets(top: 17, leading: 23, bottom: 17, trailing: 23))
        
        Divider()
            .background(Color.gray.opacity(1))
            .frame(height: 0.5)
    }
    
    
}

#Preview {
    LeaderboardView()
}

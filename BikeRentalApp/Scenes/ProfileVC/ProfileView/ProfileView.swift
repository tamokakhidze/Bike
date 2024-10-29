//
//  ProfileView.swift
//  BikeRentalApp
//
//  Created by Tamuna Kakhidze on 05.07.24.
//

import PhotosUI
import SwiftUI
import FirebaseAuth
import FirebaseCore
import FirebaseStorage

// MARK: - ProfileView

@available(iOS 16.0, *)
struct ProfileView: View {
    
    // MARK: - Properties
    
    @Environment(\.presentationMode) var presentationMode
    @StateObject var viewModel = ProfileViewModel()
    @StateObject var leaderboardViewModel = LeaderBoardViewModel()
    @StateObject var homeViewModel = HomeViewModel()
    @State var photoPicker: PhotosPickerItem? = nil
    @State var selectedImageData: Data? = nil
    @State var image: String = ""
    @State var rating = 4
    private let storage = Storage.storage().reference()
    
    let bikeIconUrl = "https://i.pinimg.com/736x/22/39/9c/22399cf9dc52f9adfb7f2f33ce74775d.jpg"
    let prices = [5.4, 6.2, 7.8]
    
    // MARK: - Body
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical) {
                VStack {
                    ZStack(alignment:.center) {
                        Rectangle()
                            .fill(.darkBlue)
                            .frame(height: 319)
                            .clipShape(UnevenRoundedRectangle(bottomLeadingRadius: 40, bottomTrailingRadius: 40, style: .continuous))
                            .ignoresSafeArea(edges: .top)
                        
                        Image(.profileBackground)
                            .offset(x: -116, y: 380)

                        VStack(spacing: 12) {
                            PhotosPicker(
                                selection: $photoPicker,
                                matching: .images,
                                photoLibrary: .shared()
                            )
                            {
                                if let selectedImageData,
                                   let profileImage = UIImage(data: selectedImageData) {
                                    Image(uiImage: profileImage)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 100, height: 100)
                                        .cornerRadius(27)
                                        .clipped()
                                } else if let image = viewModel.image {
                                    AsyncImage(url: URL(string: image)) { image in
                                        image
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .scaledToFill()
                                            .clipped()
                                    } placeholder: {
                                        ProgressView()
                                    }
                                    .frame(width: 100, height: 100)
                                    .cornerRadius(27)
                                }
                                else {
                                    Image(systemName: "person.circle.fill")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 100, height: 100)
                                        .foregroundStyle(.gray.opacity(0.3))
                                        .cornerRadius(27)
                                }
                            }
                            .onChange(of: photoPicker) { newPhoto in
                                Task {
                                    if let data = try? await newPhoto?.loadTransferable(type: Data.self) {
                                        selectedImageData = data
                                        
                                        let imageRef = storage.child("images/\(UUID().uuidString).jpg")
                                        
                                        imageRef.putData(data, metadata: nil) { metadata, error in
                                            guard metadata != nil else {
                                                print("error uploading image")
                                                return
                                            }
                                            
                                            imageRef.downloadURL { url, error in
                                                guard let downloadURL = url else {
                                                    return
                                                }
                                                image = downloadURL.absoluteString
                                                print("download phot urll : \(image)")
                                                viewModel.uploadImage(image: image)
                                            }
                                        }
                                    }
                                }
                            }
                            
                            VStack(alignment: .center) {
                                Text("\(viewModel.username)")
                                    .foregroundStyle(.white)
                                    .fontWeight(.black)
                                    .font(.system(size: 24))
                                
                                Spacer()
                                
                                NavigationLink(destination: AddBikeFormView()) {
                                    Text("Add your bike")
                                        .foregroundStyle(.white)
                                }
                                
                            }
                            .frame(height: 50)
                                                        
                        }.padding(.leading)
                    }
                    .padding(.top, -90)
                    
                    DashboardView(points: viewModel.points, rentalsCount: Int(viewModel.allRentals.count), invitations: viewModel.invitations.count)
                        .offset(y: -80)
                    
                    HStack {
                        VStack(alignment: .leading, spacing: -7) {
                            Text("\(leaderboardViewModel.currentUsersRank)th")
                                .foregroundStyle(.darkBlue)
                                .fontWeight(.bold)
                                .font(.system(size: 36))
                                .padding(.leading, 50)
                            
                            Text("On leaderboard")
                                .font(.system(size: 12))
                                .foregroundStyle(.gray.opacity(0.6))
                                .fontWeight(.semibold)
                                .padding(.leading, 50)
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .leading, spacing: -7){
                            Text("Total time spent on bike")
                                .font(.system(size: 12))
                                .foregroundStyle(.gray.opacity(0.6))
                                .fontWeight(.semibold)
                            
                            Text("100h 12m")
                                .foregroundStyle(.darkBlue)
                                .fontWeight(.bold)
                                .font(.system(size: 36))
                        }
                    }
                    .padding(.trailing)
                    .offset(y:-15)
                    
                    HStack{
                        Text("My listings")
                            .foregroundStyle(.darkBlue)
                            .fontWeight(.bold)
                            .font(.system(size: 14))
                        Spacer()
                    }
                    .padding(.leading, 30)
                    ScrollView(.horizontal) {
                        LazyHGrid(rows: [GridItem(.flexible(minimum: 136, maximum: 136))], spacing: 23) {
                            let usersBikes = homeViewModel.currentUsersBikes
                            ForEach(usersBikes.indices, id: \.self) { index in
                                GridCellView(imageUrl: bikeIconUrl, price: usersBikes[index].price, type: usersBikes[index].geometry)
                            }
                        }
                        .padding(.leading, 40)
                        
                    }
                    
                    Button(action: {
                        viewModel.logOutTapped()
                    }) {
                        Text("Log out")
                            .frame(width: 150, height: 50)
                            .background(.darkBlue)
                            .cornerRadius(50)
                            .foregroundColor(.white)
                            .fontWeight(.medium)
                    }
                    
                    Spacer()
                }.onAppear {
                    viewModel.fetchUserInfo()
                    leaderboardViewModel.fetchUserInfo()
                    homeViewModel.fetchData {
                        
                    }
                }
                .background(.mainBackground)
                .toolbar(.hidden, for: .navigationBar)
            }
        }        .onChange(of: viewModel.isLoggedOut) { isLoggedOut in
            if isLoggedOut {
                presentationMode.wrappedValue.dismiss()
            }
        }
        .navigationTitle("My Profile")
        .edgesIgnoringSafeArea(.top)
        
        
    }
}

#Preview {
    ProfileView()
}

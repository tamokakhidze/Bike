//
//  AddBikeFormView.swift
//  BikeRentalApp
//
//  Created by Tamuna Kakhidze on 12.07.24.
//

import SwiftUI
import _PhotosUI_SwiftUI
import FirebaseStorage

// MARK: - AddBikeFormView

struct AddBikeFormView: View {
    
    // MARK: - properties

    @State private var price = ""
    @State private var year = ""
    @State private var hasLights = false
    @State private var numberOfGears = ""
    @State private var geometry = ""
    @State private var locationLatitude = ""
    @State private var locationLongitude = ""
    @State private var brakeType = ""
    @State private var image = ""
    @State private var detailedImages = ""
    @State private var hasHelmet = false
    @State private var helmetPrice = ""
    @State private var photoPicker: PhotosPickerItem? = nil
    @State private var selectedImageData: Data? = nil
    @State private var message = ""
    @State private var showPopup = false
    private let storage = Storage.storage().reference()
    
    @Environment(\.presentationMode) var presentationMode
    
    @StateObject private var viewModel = AddBikeFormViewModel()
    
    // MARK: - Body

    var body: some View {
        ZStack {
            VStack {
                ScrollView(.vertical) {
                    Form {
                        Section(header: Text("Enter bike details")) {
                            TextField("Bike Price", text: $price)
                                .keyboardType(.decimalPad)
                            TextField("Year", text: $year)
                                .keyboardType(.numberPad)
                            Toggle("Does your bike have lights?", isOn: $hasLights)
                            TextField("Number of Gears", text: $numberOfGears)
                                .keyboardType(.numberPad)
                            TextField("Geometry", text: $geometry)
                            TextField("Location Latitude", text: $locationLatitude)
                                .keyboardType(.decimalPad)
                            TextField("Location Longitude", text: $locationLongitude)
                                .keyboardType(.decimalPad)
                            TextField("Brake Type", text: $brakeType)
                            TextField("Image URL", text: $image)
                            TextField("Detailed Images (comma separated)", text: $detailedImages)
                            Toggle("Does your bike have helmet?", isOn: $hasHelmet)
                            TextField("Helmet Price", text: $helmetPrice)
                                .keyboardType(.decimalPad)
                            
                        }
                    }
                    .frame(height: 600)
                    
                    PhotosPicker(
                        selection: $photoPicker,
                        matching: .images,
                        photoLibrary: .shared()
                    )
                    {
                        if let selectedImageData,
                           let bikeImage = UIImage(data: selectedImageData) {
                            Image(uiImage: bikeImage)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 200, height: 150)
                                .clipped()
                        } else {
                            ZStack {
                                Rectangle()
                                    .strokeBorder(style: StrokeStyle(lineWidth: 3, dash: [10]))
                                    .frame(width: 200, height: 150)
                                    .foregroundStyle(.darkBackground)
                                
                                Image(systemName: "photo.badge.plus")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 50, height: 50)
                                    .foregroundStyle(.gray.opacity(0.2))
                            }
                        }
                    }
                    .onChange(of: photoPicker) { newPhoto in
                        Task {
                            if let data = try? await newPhoto?.loadTransferable(type: Data.self) {
                                selectedImageData = data
                                if let uiImage = UIImage(data: data) {
                                    viewModel.detect(uiImage: uiImage)
                                    let imageRef = storage.child("images/\(UUID().uuidString).jpg")
                                    imageRef.putData(data, metadata: nil) { metadata, error in
                                        guard metadata != nil else { return }
                                        
                                        imageRef.downloadURL { url, error in
                                            if let downloadURL = url {
                                                image = downloadURL.absoluteString
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    
                    if viewModel.isValid == false  {
                        Text("The selected image does not contain a valid bike.")
                            .foregroundColor(.red)
                            .fontWeight(.regular)
                    }
                    
                    Button(action: {
                        addBike()
                    }, label: {
                        Text("Add your bike")
                            .frame(width: 350, height: 50)
                            .background(.darkBackground)
                            .cornerRadius(50)
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                    }).disabled(!viewModel.isAddBikeButtonEnabled)
                    
                    Spacer()
                    
                }.background(.loginBackground)
            }
            
            if showPopup {
                AlertView(showPopup: $showPopup, message: $message)
            }
            
        }
    }
    
    private func addBike() {
        guard viewModel.isValid == true,
              let priceValue = Double(price),
              let yearValue = Int(year),
              let numberOfGearsValue = Int(numberOfGears),
              !geometry.isEmpty,
              let locationLatitudeValue = Double(locationLatitude),
              locationLatitudeValue >= -90 && locationLatitudeValue <= 90,
              let locationLongitudeValue = Double(locationLongitude),
              locationLongitudeValue >= -180 && locationLongitudeValue <= 180,
              !image.isEmpty else {
            message = "Please fill in all required fields correctly or ensure the image is valid."
            showPopup = true
            print("Please fill in all required fields or ensure the image is valid.")
            return
        }
        
        let detailedImagesArray = detailedImages.components(separatedBy: ",").map {
            $0.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        
        let bike = Bike(
            bicycleID: UUID().uuidString,
            price: priceValue,
            year: yearValue,
            hasLights: hasLights,
            numberOfGears: numberOfGearsValue,
            geometry: geometry,
            locationLatitude: locationLatitudeValue,
            locationLongitude: locationLongitudeValue,
            brakeType: brakeType,
            image: image,
            detailedImages: detailedImagesArray,
            hasHelmet: hasHelmet,
            helmetPrice: Double(helmetPrice) ?? 0.0, 
            ownerID: viewModel.currentUserId ?? "User id not available"
        )
        
        viewModel.addBike(bike: bike) { result in
            switch result {
            case .success:
                message = "Bike added successfully!"
                viewModel.isAddBikeButtonEnabled = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    presentationMode.wrappedValue.dismiss()
                }
            case .failure(let error):
                message = "Failed to add bike: \(error.localizedDescription)"
            }
            showPopup = true
        }
    }
}

#Preview {
    AddBikeFormView()
}

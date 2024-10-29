//
//  InvitationService.swift
//  BikeRentalApp
//
//  Created by Tamuna Kakhidze on 28.08.24.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

final class InvitationService {
    
    static let shared = InvitationService()
    
    func sendInvitation(to userID: String, from currentUser: String, completion: @escaping (Bool, Error?) -> Void) {
        let userRef = Firestore.firestore().collection("users").document(userID)
        
        userRef.getDocument { document, error in
            if let error = error {
                print("error getting user document \(error.localizedDescription)")
                completion(false, error)
                return
            }
            
            do {
                var userInfo = try document?.data(as: UserInfo.self)
                if userInfo != nil {
                    if userInfo?.receivedInvitations == nil {
                        userInfo?.receivedInvitations = [currentUser]
                    } else {
                        userInfo?.receivedInvitations?.append(currentUser)
                    }
                }
                
                try userRef.setData(from: userInfo!) { error in
                    if let error = error {
                        print("error updating users invitations \(error.localizedDescription)")
                        completion(false, error)
                    } else {
                        print("user's invitations updated succesfully")
                        completion(true, nil)
                    }
                    
                }
            }
            
            catch {
                print("Error decoding user document: \(error.localizedDescription)")
                completion(false, error)
            }
        }
    }
}

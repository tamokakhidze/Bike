//
//  LeaderboardViewModel.swift
//  BikeRentalApp
//
//  Created by Tamuna Kakhidze on 18.07.24.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

// MARK: - LeaderBoardViewModel

class LeaderBoardViewModel: ObservableObject {
    
    // MARK: - Properties

    @Published var users = [UserInfo]()
    @Published var topThreeUser = [UserInfo]()
    @Published var currentUsersRank = 0
    
    private var currentUser: String? {
        return Auth.auth().currentUser?.uid
    }
    
    private var currentUserEmail: String? {
        return Auth.auth().currentUser?.email
    }

    // MARK: - Fetching users info

    func fetchUserInfo() {
        let users = Firestore.firestore().collection("users")
        
        FirestoreService.shared.fetchCollectionData(from: users, as: UserInfo.self) { [weak self] result in
            switch result {
            case .success(let success):
                guard let self = self else { return }
                self.users = success.sorted( by: {$0.points ?? 0 > $1.points ?? 0} )
                print("Total users fetched: \(self.users.count)")
                if success.count >= 3 {
                    self.topThreeUser = Array(self.users.prefix(3))
                    print("top 3 users fetched: \(self.topThreeUser.count)")
                }
                for (index, user) in self.users.enumerated() {
                    if user.email == self.currentUserEmail {
                        self.currentUsersRank = index + 1
                        break
                    }
                }
                print(self.users)
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        }
    }
    
    func inviteUser(userID: String) {
        InvitationService.shared.sendInvitation(to: userID, from: currentUser ?? "no current user detected") { success, error in
            if let error = error {
                print("Sorry, invitation was not send. \(error)")
            } else {
                print("invitation sent!!!!")
            }
            
        }
    }
    
}


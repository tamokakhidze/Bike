//
//  ProfileHostingViewController.swift
//  BikeRentalApp
//
//  Created by Tamuna Kakhidze on 08.07.24.
//

import Foundation
import UIKit
import SwiftUI

// MARK: - ProfileHostingController

class ProfileHostingController: UIHostingController<ProfileView> {
    
    required init?(coder: NSCoder) {
        super.init(coder: coder, rootView: ProfileView())
    }

    override init(rootView: ProfileView) {
        super.init(rootView: rootView)
    }

    init() {
        super.init(rootView: ProfileView())
    }
    
}


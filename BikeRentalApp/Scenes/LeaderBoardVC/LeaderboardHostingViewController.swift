//
//  LeaderboardHostingViewController.swift
//  BikeRentalApp
//
//  Created by Tamuna Kakhidze on 18.07.24.
//

import SwiftUI
import UIKit

class LeaderboardHostingVC: UIHostingController<AnyView> {
    
    init() {
        let rootView = LeaderboardView()
        super.init(rootView: AnyView(rootView))
    }
    
    @objc required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

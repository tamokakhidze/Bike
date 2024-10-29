//
//  ShopHostingViewController.swift
//  BikeRentalApp
//
//  Created by Tamuna Kakhidze on 18.07.24.
//

import SwiftUI
import UIKit

class ShopHostingViewController: UIHostingController<AnyView> {
    
    init() {
        let viewModel = ShopViewModel()
        let rootView = ShopMainView().environmentObject(viewModel)
        super.init(rootView: AnyView(rootView))
    }
    
    @objc required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

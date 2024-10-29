//
//  BikeAppWidgetBundle.swift
//  BikeAppWidget
//
//  Created by Tamuna Kakhidze on 25.08.24.
//

import WidgetKit
import SwiftUI

@main
struct BikeAppWidgetBundle: WidgetBundle {
    var body: some Widget {
        BikeAppWidget()
        BikeAppWidgetLiveActivity()
    }
}

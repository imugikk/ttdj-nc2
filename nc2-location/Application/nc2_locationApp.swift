//
//  nc2_locationApp.swift
//  nc2-location
//
//  Created by Paraptughessa Premaswari on 22/05/23.
//

import SwiftUI

@main
struct nc2_locationApp: App {
    
    init() {
        let geoFencingLocation = LocationManager()
        geoFencingLocation.requestAuthorization()
    }
    
    var body: some Scene {
        WindowGroup {
            BoardingView()
        }
    }
}

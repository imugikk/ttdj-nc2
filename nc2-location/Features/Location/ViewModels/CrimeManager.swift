//
//  CrimeManager.swift
//  nc2-location
//
//  Created by Paraptughessa Premaswari on 23/05/23.
//

import Foundation
import MapKit
//pertama check dulu user location tuh ada diregion mana

//nanti kalau udh dicheck deket region yg mana, di check lagi berapa crime ratenya

//kalau crimeratenya tinggi, return true, kalau ga ya return false

class CrimeManager {
    @Published var crimeRateData: Double?
    @Published var regionNews: [News]?
    
    func calculateCrimeRate(for location: CLLocationCoordinate2D)-> Double {
        if let region = regions.first(where: {
            let regionCenterLocation = CLLocation(latitude: $0.center.latitude, longitude: $0.center.longitude)
            let locationCoordinate = CLLocation(latitude: location.latitude, longitude: location.longitude)
            let distance = locationCoordinate.distance(from: regionCenterLocation)
            return distance <= $0.radius
        }) {
            let regionCrimeCount = crimes.filter { crime in
                let crimeLocation = CLLocation(latitude: crime.latitude, longitude: crime.longitude)
                let regionCenterLocation = CLLocation(latitude: region.center.latitude, longitude: region.center.longitude)
                let distance = crimeLocation.distance(from: regionCenterLocation)
                return distance <= region.radius
            }.count
            
            let crimeRate = Double(regionCrimeCount) / Double(region.population) * 1000000 // Adjust the multiplication factor based on preference
            
            print("Crime Rate in Region: \(crimeRate)")
            crimeRateData = crimeRate
        
            return crimeRateData ?? 0
        } else {
            print("Region not found for the provided location.")
            return 0
        }
    }
    
    func newsRegion(for location: CLLocationCoordinate2D)-> [News] {
        if let region = regions.first(where: {
            let regionCenterLocation = CLLocation(latitude: $0.center.latitude, longitude: $0.center.longitude)
            let locationCoordinate = CLLocation(latitude: location.latitude, longitude: location.longitude)
            let distance = locationCoordinate.distance(from: regionCenterLocation)
            return distance <= $0.radius
        }) {
            regionNews = region.news
            print(regionNews ?? [])
            return regionNews ?? []
        } else {
            print("Region not found for the provided location.")
            return []
        }
    }
}







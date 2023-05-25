//
//  CrimeModel.swift
//  nc2-location
//
//  Created by Paraptughessa Premaswari on 23/05/23.
//

import Foundation

struct CrimeData {
    let id = UUID()
    let latitude: Double
    let longitude: Double
    let crimeName: String
}

var crimes: [CrimeData] = [
    //pamulang
    CrimeData(latitude: -6.3452, longitude: 106.7435, crimeName: "Assault"),
    CrimeData(latitude: -6.3407, longitude: 106.7408, crimeName: "Burglary"),
    CrimeData(latitude: -6.3407, longitude: 106.7408, crimeName: "Burglary"),
    CrimeData(latitude: -6.3407, longitude: 106.7408, crimeName: "Burglary"),
    CrimeData(latitude: -6.3407, longitude: 106.7408, crimeName: "Burglary"),
    CrimeData(latitude: -6.3407, longitude: 106.7408, crimeName: "Burglary"),
    CrimeData(latitude: -6.3407, longitude: 106.7408, crimeName: "Burglary"),
    CrimeData(latitude: -6.3407, longitude: 106.7408, crimeName: "Burglary"),
    CrimeData(latitude: -6.3407, longitude: 106.7408, crimeName: "Burglary"),
    CrimeData(latitude: -6.3407, longitude: 106.7408, crimeName: "Burglary"),
    CrimeData(latitude: -6.3407, longitude: 106.7408, crimeName: "Burglary"),
    CrimeData(latitude: -6.3407, longitude: 106.7408, crimeName: "Burglary"),
    CrimeData(latitude: -6.3407, longitude: 106.7408, crimeName: "Burglary"),
    CrimeData(latitude: -6.3407, longitude: 106.7408, crimeName: "Burglary"),
    CrimeData(latitude: -6.3407, longitude: 106.7408, crimeName: "Burglary"),
    
    //ciputat
    CrimeData(latitude: -6.3371, longitude: 106.7486, crimeName: "Theft"),
    
    //serpong utara
    CrimeData(latitude: -6.2723, longitude: 106.6632, crimeName: "Burglary"),
    CrimeData(latitude: -6.2761, longitude: 106.6715, crimeName: "Drug Offenses"),
    
    //pondok aren
    CrimeData(latitude: -6.2580, longitude: 106.7178, crimeName: "Robbery"),
    CrimeData(latitude: -6.2618, longitude: 106.7227, crimeName: "Vandalism"),
]



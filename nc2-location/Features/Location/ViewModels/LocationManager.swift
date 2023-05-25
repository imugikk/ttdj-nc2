//
//  LocationViewModel.swift
//  nc2
//
//  Created by Paraptughessa Premaswari on 19/05/23.
//

import SwiftUI
import CoreLocation
import MapKit
import UserNotifications

// combine framework to watch textfield change
import Combine

//// map defaults
//enum mapDefaults {
//    static let initialLocation = CLLocationCoordinate2D(latitude: -37.81785423438109, longitude:  144.97973738630145)
//    static let initialSpan = MKCoordinateSpan(latitudeDelta:0.01, longitudeDelta:0.01)
//}


class LocationManager: NSObject, ObservableObject, MKMapViewDelegate, CLLocationManagerDelegate {
    @Published var mapView: MKMapView = .init()
    @Published var manager: CLLocationManager = .init()

    @Published var searchText: String = ""
    var cancellable: AnyCancellable?
    @Published var fetchedPlaces: [CLPlacemark]?

    @Published var userLocation: CLLocation?

    //final location
    @Published var pickedLocation: CLLocation?
    @Published var pickedPlaceMark: CLPlacemark?

    var userLatitude = CLLocationCoordinate2D().latitude
    var userLongitude = CLLocationCoordinate2D().longitude

    @Published var initialCoordinate : CLLocationCoordinate2D?
    @Published var movedCoordinate : CLLocationCoordinate2D?
    @Published private(set) var authorizationStatus: UNAuthorizationStatus?
    
    @Published var crimeData: Double = 0
    @Published var newsData: [News] = []
    let crimeManager = CrimeManager()
    var crimeRate: Double = 0

    override init(){
        // setting delegates
        super.init()
        manager.delegate = self
        mapView.delegate = self

        //request location access
//        manager.requestWhenInUseAuthorization()
        manager.requestAlwaysAuthorization()
        manager.startUpdatingLocation()
        manager.distanceFilter = 10

//        let geoFenceRegion: CLCircularRegion = CLCircularRegion(center: CLLocationCoordinate2D(latitude: -6.3022067, longitude: 106.6521684), radius: 10, identifier: "Apple Academy")
//
//        manager.startMonitoring(for: geoFenceRegion)

        //search textfield watching
        cancellable = $searchText
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink(receiveValue: { value in
                if value != "" {
                    self.fetchPlaces(value: value)
                } else {
                    self.fetchedPlaces = nil
                }
            })
        
        // Define region 1
        let pamulangRegion = CLCircularRegion(center: CLLocationCoordinate2D(latitude: -6.342050, longitude: 106.738147), radius: 5000, identifier: "Pamulang")
        // Start monitoring region 1
        manager.startMonitoring(for: pamulangRegion)

        let pondokArenRegion = CLCircularRegion(center: CLLocationCoordinate2D(latitude: -6.265253, longitude: 106.700901), radius: 5000, identifier: "PondokAren")
        manager.startMonitoring(for: pondokArenRegion)
        
        let serpongRegion = CLCircularRegion(center: CLLocationCoordinate2D(latitude: -6.309660, longitude: 106.680130), radius: 5000, identifier: "Serpong")
        manager.startMonitoring(for: serpongRegion)
        
        let CTRegion = CLCircularRegion(center: CLLocationCoordinate2D(latitude: -6.291398, longitude: 106.755760), radius: 5000, identifier: "CT")
        manager.startMonitoring(for: CTRegion)
        
        let CiputatRegion = CLCircularRegion(center: CLLocationCoordinate2D(latitude: -6.315077, longitude: 106.726285), radius: 5000, identifier: "Ciputat")
        manager.startMonitoring(for: CiputatRegion)
        
        let SerpongUtaraRegion = CLCircularRegion(center: CLLocationCoordinate2D(latitude: -6.251200,longitude: 106.662112), radius: 5000, identifier: "SerpongUtara")
        manager.startMonitoring(for: SerpongUtaraRegion)
        
        let SetuRegion = CLCircularRegion(center: CLLocationCoordinate2D(latitude: -6.342801, longitude: 106.673685), radius: 5000, identifier: "Setu")
        manager.startMonitoring(for: SetuRegion)
    }

    func fetchPlaces(value: String) {
        //fetching place using mklocalsearch & async/await
        Task{
            do{
                let request = MKLocalSearch.Request()
                request.naturalLanguageQuery = value.lowercased()

                let response = try await MKLocalSearch(request: request).start()

                //main actor to publish changes in main thread
                await MainActor.run(body: {
                    self.fetchedPlaces = response.mapItems.compactMap({ item -> CLPlacemark? in
                        return item.placemark
                    })
                })
            } catch{
                //handle error
            }
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        //Handle Error
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let currentLocation = locations.last else{return}
        self.userLocation = currentLocation
        let location = currentLocation

        userLatitude = location.coordinate.latitude
        userLongitude = location.coordinate.longitude

        // Starting position
        initialCoordinate = CLLocationCoordinate2D(latitude: userLatitude , longitude: userLongitude)
        // Updated position
        movedCoordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude , longitude: location.coordinate.longitude)
        crimeRate = crimeManager.calculateCrimeRate(for: CLLocationCoordinate2D(latitude: userLatitude, longitude: userLongitude))
    }

    // check if location permission is enabled or not
    func checkLocationEnabled() {
        manager.startUpdatingLocation()
        print("Location permission enabled")
    }

    // Check if user authorized location
       private func checkLocationAuth() {
           switch manager.authorizationStatus{

           case .notDetermined:
               manager.requestAlwaysAuthorization()
           case .restricted:
               print("User location access is restricted")
           case .denied:
               print("User denied location access")
           case .authorizedAlways, .authorizedWhenInUse:
               manager.requestAlwaysAuthorization()
//               manager.requestLocation()
           @unknown default:
               break
           }
       }

    //location authorization
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuth()

        // request for notification access
        requestAuthorization()
    }

    func handleLocationError(){
        // handle error
    }

    // add dragable pin to mapview
    func addDraggablePin(coordinate: CLLocationCoordinate2D){
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = "You were here"

        mapView.addAnnotation(annotation)
    }

    //enabling dragging
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let marker = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "DELIVERYPIN")
        marker.isDraggable = true
        marker.canShowCallout = false
        return marker
    }

    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, didChange newState: MKAnnotationView.DragState, fromOldState oldState: MKAnnotationView.DragState) {
        guard let newLocation = view.annotation?.coordinate else{return}
        self.pickedLocation = .init(latitude: newLocation.latitude, longitude: newLocation.longitude)
        updatePlacemark(location: .init(latitude: newLocation.latitude, longitude: newLocation.longitude))
    }

    func updatePlacemark(location: CLLocation) {
        Task{
            do{
                guard let place = try await reverseLocationCoordinates(location: location) else {return}
                await MainActor.run(body: {
                    self.pickedPlaceMark = place
                })
            }
        }
    }

    //displaying new location data
    func reverseLocationCoordinates(location: CLLocation) async throws->CLPlacemark?{
        let place = try await CLGeocoder().reverseGeocodeLocation(location).first
        return place
    }

    // enter safe area (region)
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        print("enter")
        
        if region.identifier == "Pamulang" && crimeRate > 30{
            triggerLocalNotification(subTitle: "Hi Ugik!", body: "Attention, citizen! You've entered the land of mischievous mischief-makers. Keep your Spidey senses tingling!")
        } else if region.identifier == "Serpong" && crimeRate > 30{
            triggerLocalNotification(subTitle: "Hi, Ugik!", body: "Warning: High crime zone ahead! It's time to unleash your secret superhero alter ego!")
        } else if region.identifier == "SerpongUtara" && crimeRate > 30{
            triggerLocalNotification(subTitle: "Hi, Ugik!", body: "Alert: This neighborhood's crime rate is so high that even the local cats have taken up martial arts training. Stay on your toes!")
        } else if region.identifier == "CT" && crimeRate > 30{
            triggerLocalNotification(subTitle: "Hi, Ugik!", body: "Warning: This area is like a magnet for mischief! Keep your valuables close and your ninja moves ready.")
        } else if region.identifier == "Setu" && crimeRate > 30{
            triggerLocalNotification(subTitle: "Hi, Ugik!", body: "Watch out! You're in the territory of 'The Cheesy Bandits.' They may steal your heart with their jokes, but they'll never catch you off guard!")
        } else if region.identifier == "PondokAren" && crimeRate > 30{
            triggerLocalNotification(subTitle: "Hi, Ugik!", body: "Attention, fellow explorer! This area is rumored to be guarded by the 'Tickle Monster Gang.' Stay on your toes and carry extra giggles.")
        } else if region.identifier == "Ciputat" && crimeRate > 30{
            triggerLocalNotification(subTitle: "Hi, Ugik!", body: "Danger, danger! This area has more villains than a comic book convention!")
        }
    }

    // exiting safe area (region)
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        print("exit")
        
        if region.identifier == "Pamulang" && crimeRate < 30{
            triggerLocalNotification(subTitle: "Hi Ugik!", body: "Great news! You're now in a low-risk area, but remember, even superheroes need to lock their doors!")
        } else if region.identifier == "Serpong" && crimeRate < 30{
            triggerLocalNotification(subTitle: "Hi, Ugik!", body: "Phew! You've left the crime-infested zone. Remember, even in safe areas, never challenge a mime to a silent showdown!")
        } else if region.identifier == "SerpongUtara" && crimeRate < 30{
            triggerLocalNotification(subTitle: "Hi, Ugik!", body: "Hooray! You've entered a low-risk zone. Time to relax, but keep your Spidey senses tingling for any 'unsolvable' mysteries nearby.")
        } else if region.identifier == "CT" && crimeRate < 30{
            triggerLocalNotification(subTitle: "Hi, Ugik!", body: "Congratulations on leaving the high-risk area! Remember, even in safe neighborhoods, guard your ice cream from sneaky seagulls with a sweet tooth.")
        } else if region.identifier == "Setu" && crimeRate < 30{
            triggerLocalNotification(subTitle: "Hi, Ugik!", body: "You've made it out of the danger zone! But be warned, the neighborhood watch consists of expert nosy neighbors armed with telescopes.")
        } else if region.identifier == "PondokAren" && crimeRate < 30{
            triggerLocalNotification(subTitle: "Hi, Ugik!", body: "Congratulations on escaping the high-risk neighborhood! Just a friendly reminder, even here, be cautious of runaway shopping carts on joyrides.")
        } else if region.identifier == "Ciputat" && crimeRate < 30{
            triggerLocalNotification(subTitle: "Hi, Ugik!", body: "Great job on leaving the high-risk area! Remember, in the safest neighborhoods, 'crime' is stealing the last slice of pizza at the local pizzeria.")
        }
    }

    // request for notification
    func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { isGranted, _ in
            DispatchQueue.main.async {
                self.authorizationStatus = isGranted ? .authorized : .denied
            }
        }
    }

    // create user notification
    func triggerLocalNotification(subTitle: String, body: String){
        // configure notification content
        let content = UNMutableNotificationContent()
        content.title = subTitle
        content.body = body
        content.sound = UNNotificationSound.default

        // setup trigger
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)

        // create request
        let request = UNNotificationRequest(identifier: "EnterRegionNotification", content: content, trigger: trigger)

        // add notification request
        UNUserNotificationCenter.current().add(request)
    }
}

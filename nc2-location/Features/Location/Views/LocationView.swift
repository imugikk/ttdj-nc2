//
//  SearchView.swift
//  nc2
//
//  Created by Paraptughessa Premaswari on 21/05/23.
//

import SwiftUI
import MapKit

var crimeData: Double?

struct SearchView: View {
    @StateObject var locationManager: LocationManager = .init()
    let crimeManager = CrimeManager()

    //navigation tag to push view to mapview
    @State var navigationTag: String?

    var body: some View {
        VStack{
            Text("Welcome Back!").font(.system(size: 30)).bold().foregroundColor(Color("primary"))
            
            HStack{
                Image(systemName: "mappin.and.ellipse").foregroundColor(.gray).padding(.trailing, 6)
                TextField("Choose Your Destination", text: $locationManager.searchText)
            }
            .padding(.vertical, 15)
            .padding(.horizontal, 12)
            .background(.gray.opacity(0.1))
            .cornerRadius(8)
            .textInputAutocapitalization(.never)

            if let places = locationManager.fetchedPlaces, !places.isEmpty{
                List{
                    ForEach(places, id: \.self){place in
                        Button{
                            if let coordinate = place.location?.coordinate{
                                locationManager.pickedLocation = .init(latitude: coordinate.latitude, longitude: coordinate.longitude)
                                locationManager.mapView.region = .init(center: coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
                                locationManager.addDraggablePin(coordinate: coordinate)
                                locationManager.updatePlacemark(location: .init(latitude: coordinate.latitude, longitude: coordinate.longitude))
                                
                                locationManager.newsData = crimeManager.newsRegion(for: coordinate)
                                locationManager.crimeData = crimeManager.calculateCrimeRate(for: coordinate)
                            }
                            navigationTag = "MAPVIEW"
                        }label: {
                            HStack(spacing: 15) {
                                Image(systemName: "mappin.circle.fill")
                                    .font(.title2)
                                    .foregroundColor(.green)

                                VStack(alignment: .leading, spacing: 6){
                                    Text(place.name ?? "").font(.title3.bold()).foregroundColor(.primary)
                                    HStack{
                                        Text(place.locality ?? "").font(.caption).foregroundColor(.gray)
                                    }
                                }
                            }
                        }
                    }
                }.listStyle(.plain)
            } else {
                
                //CURRENT LOCATION
                Button {
                    if let coordinate = locationManager.movedCoordinate{
                        print("test")
                        locationManager.mapView.region = .init(center: coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
                        locationManager.addDraggablePin(coordinate: coordinate)
                        locationManager.updatePlacemark(location: .init(latitude: coordinate.latitude, longitude: coordinate.longitude))
                        locationManager.newsData = crimeManager.newsRegion(for: coordinate)
                        locationManager.crimeData = crimeManager.calculateCrimeRate(for: coordinate)
                        navigationTag = "MAPVIEW"
                    }
                } label: {
                    Label {
                        Text("Use Current Location Instead").font(.callout).tint(.green)
                    } icon: {
                        Image(systemName: "location.north.circle.fill").tint(.green)
                    }
                }.onAppear(perform: locationManager.checkLocationEnabled)
                
                Spacer()
                Image("sunshineOutline").resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 200, height: 200)
                Spacer()
                
                Button {
                    if let coordinate = locationManager.movedCoordinate{
                        print("test")
                        locationManager.mapView.region = .init(center: coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
                        locationManager.addDraggablePin(coordinate: coordinate)
                        locationManager.updatePlacemark(location: .init(latitude: coordinate.latitude, longitude: coordinate.longitude))
                        navigationTag = "REPORTVIEW"
                    }
                } label: {
                    Text("or do you want to *report a crime?*").foregroundColor(.green)
                }
            }
        }.padding()
        .frame(maxHeight: .infinity, alignment: .top)
        .background{
            NavigationLink(tag: "MAPVIEW", selection: $navigationTag){
                MapViewSelection().environmentObject(locationManager)
//                    .navigationBarBackButtonHidden(true)
            } label: {}
                .labelsHidden()
        }
        .background{
            NavigationLink(tag: "REPORTVIEW", selection: $navigationTag){
                MapViewReportSelection().environmentObject(locationManager)
//                    .navigationBarBackButtonHidden(true)
            } label: {}
                .labelsHidden()
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}

// mapview live selection
struct MapViewSelection: View {
    @EnvironmentObject var locationManager: LocationManager
    @State private var isPresentingSheet = true
    @State var offset : CGFloat = 0
    
    var body: some View{
        ZStack {
            MapViewHelper().environmentObject(locationManager)
                .ignoresSafeArea()
            //displaying data
            
            if let place = locationManager.pickedPlaceMark{
                GeometryReader{reader in
                    VStack(alignment: .leading, spacing: 15){
                        HStack(){
                            Spacer()
                            Capsule()
                                .fill(Color.gray.opacity(0.5))
                                .frame(width: 50, height: 5)
                                .padding(.bottom,5)
                            Spacer()
                        }
                        
                        Text(place.name ?? "").font(.title2.bold())
                        
                        VStack(alignment: .leading, spacing: 5){
                            Text("Crime Rate").font(.system(size: 14)).foregroundColor(.gray.opacity(0.8))
                            HStack(){
                                
                                if locationManager.crimeData < 10 {
                                    Text(String(format: "%.2f", locationManager.crimeData) + "%").font(.system(size: 48)).foregroundColor(Color("primary"))
                                    Spacer()
                                    Text("Low").font(.body.bold()).foregroundColor(Color("primary"))
                                } else if (locationManager.crimeData < 30 && locationManager.crimeData > 10){
                                    Text(String(format: "%.2f", locationManager.crimeData) + "%").font(.system(size: 48)).foregroundColor(.yellow)
                                    Spacer()
                                    Text("Moderate").font(.body.bold()).foregroundColor(.yellow)
                                } else {
                                    Text(String(format: "%.2f", locationManager.crimeData) + "%").font(.system(size: 48)).foregroundColor(.red)
                                    Spacer()
                                    Text("High").font(.body.bold()).foregroundColor(.red)
                                }
                            }
                            
                            if locationManager.crimeData < 10 {
                                Text("Living in a low crime rate area means you can enjoy a sense of security. Remember to continue prioritizing your personal safety and be aware of your surroundings.").font(.body)
                            } else if (locationManager.crimeData < 30 && locationManager.crimeData > 10){
                                Text("Being in a moderate crime rate area means it's crucial to remain cautious and mindful of your surroundings. Take extra care when walking alone, especially during late hours.").font(.body)
                            } else {
                                Text("Living in a high crime rate area can be concerning, but your safety is our utmost priority. We recommend taking extra precautions such as avoiding isolated areas and using well-lit routes.").font(.body)
                            }
                        }
                        .padding()
                        .background(.white)
                        .cornerRadius(8)
                        
                            VStack(alignment: .leading){
                                Text("Discover What's Happening Nearby").font(.system(size: 14)).foregroundColor(.gray.opacity(0.8))
                                ScrollView{
                                    VStack(alignment: .leading, spacing: 15){
                                        if locationManager.newsData.count > 0 {
                                            ForEach(locationManager.newsData, id: \.self) { newsItem in
                                                Link(destination: newsItem.link) {
                                                    Text(newsItem.title)
                                                        .foregroundColor(.green)
                                                        .multilineTextAlignment(.leading)
                                                }
                                            }
                                        } else {
                                            Text("No Related News in This Area").frame(maxWidth: .infinity, alignment: .leading)
                                        }
                                    }
                                }.frame(height: 300)
                            }.padding()
                                .background(.white)
                                .cornerRadius(8)
                    }
                    .padding()
                    .background{
                        RoundedRectangle(cornerRadius: 10, style: .continuous).fill(Color("gray"))
                            .ignoresSafeArea()
                    }
                    .frame(maxHeight: .infinity, alignment: .bottom)
                    .offset(y: reader.frame(in: .global).height - 280)
                    //adding gesture
                    .offset(y: offset)
                    .gesture(DragGesture().onChanged({(value) in
                        
                        withAnimation{
                            //cek arah scroll
                            //scroll ke atas
                            //pake startLocation karena nilainya berubah2 pas kita scroll atas & bawah
                            if value.startLocation.y > reader.frame(in: .global).midX{
                                
                                if value.translation.height < 0 && offset >
                                    (-reader.frame(in: .global).height + 280){
                                    
                                    offset = value.translation.height
                                }
                            }
                            
                            if value.startLocation.y < reader.frame(in: .global).midX{
                                
                                if value.translation.height > 0 && offset < 0 {
                                    
                                    offset = (-reader.frame(in: .global).height + 280) + value.translation.height
                                    
                                }
                            }
                        }
                        
                    }).onEnded({(value) in
                        
                        withAnimation{
                            //cek pull up screen
                            if value.startLocation.y > reader.frame(in: .global).midX{
                                
                                if -value.translation.height > reader.frame(in: .global).midX{
                                    
                                    offset = (-reader.frame(in: .global).height + 280)
                                    
                                    return
                                }
                                offset = 0
                            }
                            
                            if value.startLocation.y < reader.frame(in: .global).midX{
                                
                                if value.translation.height < reader.frame(in: .global).midX{
                                    
                                    offset = (-reader.frame(in: .global).height + 280)
                                    
                                    return
                                }
                                offset = 0
                            }
                        }
                    }))
                    
                }
            }
        }.onDisappear{
            locationManager.pickedLocation = nil
            locationManager.pickedPlaceMark = nil

            locationManager.mapView.removeAnnotations(locationManager.mapView.annotations)
        }
    }
}

// mapview live selection
struct MapViewReportSelection: View {
    @EnvironmentObject var locationManager: LocationManager
    @State private var isPresentingSheet = true
    @State private var crimeName: String = ""
    
    @State private var showAlert = false
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View{
        ZStack {
            
            MapViewHelper().environmentObject(locationManager)
                .ignoresSafeArea()

            VStack(alignment: .leading){
                HStack(){
                    Spacer()
                    Capsule()
                        .fill(Color.gray.opacity(0.5))
                        .frame(width: 50, height: 5)
                        .padding(.top)
                        .padding(.bottom,5)
                    Spacer()
                }
                
                Text("Report a Crime").font(.title2.bold()).padding()
                
                VStack(alignment: .leading){
                    Text("Tell Us What's Your Witnesses").foregroundColor(.gray.opacity(0.5)).font(.system(size: 14))
                    TextField("Write here...", text: $crimeName)
                    .padding(.vertical, 15)
                    .padding(.horizontal, 12)
                    .background(.gray.opacity(0.1))
                    .cornerRadius(8)
                    .textInputAutocapitalization(.never)
                    
                    Button("Send") {
                        insertData()
                        showAlert = true
                    }
                    .padding(.vertical, 15)
                    .frame(maxWidth: .infinity)
                    .background(Color("primary"))
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .alert(isPresented: $showAlert) {
                        Alert(
                            title: Text("Your Report Has Been Sent!"),
                            message: Text("So sorry to hear that, hope you’ll never face that situation again. We will check your report as soon as possible"),
                            dismissButton: .default(Text("OK"), action: {
                                presentationMode.wrappedValue.dismiss()
                            })
                        )
                    }
                }
                .padding()
                .background{
                    RoundedRectangle(cornerRadius: 10, style: .continuous).fill(.white)
                        .ignoresSafeArea()
                }
                .frame(alignment: .bottom)
            }
//            .padding()
            .background{
                RoundedRectangle(cornerRadius: 10, style: .continuous).fill(.white)
                    .ignoresSafeArea()
            }
            .frame(maxHeight: .infinity, alignment: .bottom)
        }.onDisappear{
            locationManager.pickedLocation = nil
            locationManager.pickedPlaceMark = nil

            locationManager.mapView.removeAnnotations(locationManager.mapView.annotations)
        }
    }
    
    func insertData() {
        // Insert the crime data into your model or perform any other necessary actions
        let crime = CrimeData(latitude: locationManager.userLatitude, longitude: locationManager.userLongitude, crimeName: crimeName)
        crimes.append(crime)
        // Clear the text field
        crimeName = ""
    }
}

//uikit mapview
struct MapViewHelper: UIViewRepresentable {
    @EnvironmentObject var locationManager: LocationManager
    func makeUIView(context: Context) -> MKMapView {
        return locationManager.mapView
    }

    func updateUIView(_ uiView: UIViewType, context: Context) {}
}

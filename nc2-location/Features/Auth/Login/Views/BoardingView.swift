//
//  ContentView.swift
//  nc2
//
//  Created by Paraptughessa Premaswari on 18/05/23.
//

import SwiftUI

struct BoardingView: View {
    @StateObject var vm = ViewModel()
    
    @State private var isTextFieldFocused = false
//    @StateObject private var vm = CloudKitViewModel()
    
    var body: some View {
        if vm.authenticated{
//            if !locationManager.searchText.isEmpty {
            NavigationView{
                SearchView().navigationBarBackButtonHidden(true)
            }
//            } else {
//                VStack {
//                    Spacer()
//                    Text("Welcome back")
//                    Spacer()
//                    Text("Nice to meet you again, **\(vm.username)**!")
//                    Text("Where do you like to take me today?")
//                    TextField("", text: $locationManager.searchText).textFieldStyle(.roundedBorder)
//                        .textInputAutocapitalization(.never).padding()
////                    Button("Log out", action: vm.logOut).tint(.red).buttonStyle(.bordered)
//                }
//            }
        } else {
            ZStack {
                VStack(alignment: .center) {
                    Spacer()
                    Text("Hi Mate!").font(.system(size: 30)).bold().foregroundColor(Color("primary"))
                    Text("Please enter your detail to Sign In").foregroundColor(Color("primary")).padding(.bottom, 30)
                    TextField("Username", text: $vm.username)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 15)
//                        .textFieldStyle(.roundedBorder)
                        .textInputAutocapitalization(.never)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color("primary"), lineWidth: 1) // Set border color and width
                        )
                    SecureField("Password", text: $vm.password)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 15)
//                        .textFieldStyle(.roundedBorder)
                        .textInputAutocapitalization(.never)
                        .privacySensitive()
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color("primary"), lineWidth: 1) // Set border color and width
                        )
                        .padding(.bottom, 15)
                    Button("Log In", action: vm.authenticate)
                        .padding(.vertical, 15)
                        .frame(maxWidth: .infinity)
                        .background(Color("primary"))
                        .foregroundColor(.white)
                        .cornerRadius(8)
                    Spacer()
                }
                .alert("Access denied", isPresented: $vm.invalid) {
                    Button("Dismiss", action: vm.logPressed)
                }
                .frame(width: 300)
                .padding()
            }.transition(.offset(x: 0, y: 800))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        BoardingView()
    }
}

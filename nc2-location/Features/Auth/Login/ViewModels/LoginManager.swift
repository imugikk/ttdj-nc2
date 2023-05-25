//
//  LoginViewModel.swift
//  nc2
//
//  Created by Paraptughessa Premaswari on 18/05/23.
//

import Foundation
import SwiftUI

extension BoardingView {
    class ViewModel: ObservableObject {
        @AppStorage("AUTH_KEY") var authenticated = false {
            willSet { objectWillChange.send() }
        }
        @AppStorage("USER_KEY") var username = ""
        @Published var password = ""
        @Published var invalid: Bool = false
        
        private var sampleUser = "ugik"
        private var samplePassword = "123"
        
        init() {
            print("Currently logged on: \(authenticated)")
            print("Current user: \(username)")
        }
        
        func toggleAuthentication() {
            self.password = ""
            
            withAnimation{
                authenticated.toggle()
            }
        }
        
        func authenticate() {
            guard self.username.lowercased() == sampleUser else {
                self.invalid = true
                return
            }
            
            guard self.password.lowercased() == samplePassword else {
                self.invalid = true
                return
            }
            
            toggleAuthentication()
        }
        
        func logOut() {
            toggleAuthentication()
        }
        
        func logPressed() {
            print("Button pressed.")
        }
    }
}

//
//  LoginViewModel.swift
//  nimbleSurveys
//
//  Created by Felicitas Figueroa Fagalde on 04/11/2023.
//

import Foundation
import KeychainSwift

class LoginViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var name: String = ""
    @Published var password: String = ""
    @Published var authURL: URL?
    @Published var showAuthWebView: Bool = false
    @Published var isAuthenticated: Bool = false
    let authService = AuthService()
    @Published var passwordConfirmation: String = ""
    @Published var showAlert = false
    @Published var alertMessage = ""

        
   
    func login() {
        print("LOGIN FUNCTION")
        authService.loginWithCredentials(email: email, password: password) { [weak self] (success, error) in
            DispatchQueue.main.async {
                if success {
                    self?.isAuthenticated = true
                } else {
                    //Create alert
                    print(error?.localizedDescription ?? "Error desconocido")
                }
            }
        }
    }
    
    func exchangeCodeForToken(code: String) {
    }
    
    func forgotPassword() {
       
    }
}

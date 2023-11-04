//
//  LoginView.swift
//  nimbleSurveys
//
//  Created by Felicitas Figueroa Fagalde on 03/11/2023.
//

import SwiftUI

struct LoginView: View {
    @StateObject var vm = LoginViewModel()
    
    var body: some View {
        ZStack {
            // Background
            Image("bkgLogin")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            
            // Logo
            Image("splashLogo")
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 100)
                .position(x: UIScreen.main.bounds.width/2, y: 153)
            
            // Campos y botón
            VStack(spacing: 20) {
                TextField(vm.email, text: .constant(""))
                    .padding()
                    .background(Color.white.opacity(0.2))
                    .cornerRadius(10)
                    .keyboardType(.emailAddress)
                
                
                ZStack(alignment: .trailing) {
                    SecureField(vm.password, text: .constant(""))
                        .padding()
                        .background(Color.white.opacity(0.2))
                        .cornerRadius(10)
                        .foregroundColor(.white)
                    
                    Button(action: vm.forgotPassword) {
                        Text("Forgot?")
                            .foregroundColor(.white)
                            .padding(.trailing, 8)
                    }
                }
                
                Button(action: vm.login) {
                    Text("Log in")
                        .foregroundColor(.black)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.white)
                        .cornerRadius(10)
                }
            }
            .padding(.horizontal, 24)
            .position(x: UIScreen.main.bounds.width/2, y: 153 + 100 + 109)
        }
    }
}

#Preview {
    LoginView()
}

//
//  LoginView.swift
//  nimbleSurveys
//
//  Created by Felicitas Figueroa Fagalde on 03/11/2023.
//

import SwiftUI

struct LoginView: View {
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
                .padding(.top, 50)
            
            // Campos y botón
            VStack(spacing: 16) {
                TextField("Email", text: .constant(""))
                    .padding()
                    .background(Color.white.opacity(0.2))
                    .cornerRadius(10)
                    .keyboardType(.emailAddress)
                    .foregroundColor(.white)
                
                SecureField("Password", text: .constant(""))
                    .padding()
                    .background(Color.white.opacity(0.2))
                    .cornerRadius(10)
                    .foregroundColor(.white)
                
                HStack {
                    Spacer()
                    Text("Forgot?")
                        .foregroundColor(.white)
                }
                
                Button(action: {}) {
                    Text("Log in")
                        .foregroundColor(.black)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                }
            }
            .padding(.horizontal, 32)
            .padding(.top, 250)
        }
    }
}

#Preview {
    LoginView()
}

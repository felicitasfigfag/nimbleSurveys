//
//  ContentView.swift
//  nimbleSurveys
//
//  Created by Felicitas Figueroa Fagalde on 03/11/2023.
//

import SwiftUI

struct ContentView: View {
    @StateObject var loginVM = LoginViewModel()

    var body: some View {
        if loginVM.isAuthenticated {
            SlideContainerView(vm: SlideContainerViewModel(slides: mockSlides))
        } else {
            LoginView(vm: loginVM)
        }
    }
}


#Preview {
    ContentView()
}

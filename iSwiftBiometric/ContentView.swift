//
//  ContentView.swift
//  iSwiftBiometric
//
//  Created by Elfana Anamta Chatya on 26/02/24.
//

import SwiftUI
import LocalAuthentication

struct ContentView: View {
    
    @ObservedObject var authController = AuthController()
    @State private var status = "Status:"
    @State private var biometricAvailable = true
    
    var body: some View {
        VStack{
            Text(status)
                .foregroundColor(biometricAvailable ? .primary : .red)
                .font(.largeTitle)
                .multilineTextAlignment(.center)
                .padding(.top, 100)
                .padding(.bottom, 50)
            
            if authController.biometricType == .faceID{
                Button {
                    authenticate()
                } label: {
                    Label("Use FaceID", systemImage: "faceid")
                }
                .buttonStyle(.bordered)
            } else if authController.biometricType == .touchID{
                Button {
                    authenticate()
                } label: {
                    Label("Use TouchID", systemImage: "touchid")
                }
                .buttonStyle(.bordered)
            } else {
                Text("No Biometric Option Available")
            }
            
            Spacer()
        }.onAppear(perform: checkPermission)
    }
    
    func checkPermission(){
        authController.askBiometricAvailability { error in
            if let error{
                status = "Status: " + "\n" + error.localizedDescription
                biometricAvailable = false
            } else {
                biometricAvailable = true
            }
        }
    }
    
    func authenticate(){
        authController.authenticate { result in
            switch result {
            case .success(_):
                status = "Status:" + "\n Logged In."
            case .failure(let failure):
                status = "Status:" + failure.localizedDescription
            }
        }
    }
}

//struct ContentView: View {
//    @State var isUnlocked = false
//    @ObservedObject var authController = AuthController()
//      @State private var status = "Status:"
//      @State private var biometricAvailable = true
//
//
//    func authenticate() {
//        let context = LAContext()
//        var error: NSError?
//        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
//            let reason = "We need to unlock your passwords."
//            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) {
//                success, authenticationError in
//               DispatchQueue.main.async {
//                   if success {
//                                      self.isUnlocked = true
//                                  }
//                   else {
//                       self.isUnlocked = false
//                                  }
//                }
//            }
//        }
//
//        else {
//            // No Biometrics found
//        }
//    }
//    
//    var body: some View {
//        VStack {
//            if isUnlocked {
//                VStack {
//                    Text("Hello User!")
//                }
//            }
//            else {
//                Text("Use your Biometrics to use the app.")
//            }
//            Button(action: {
//                authenticate()
//            }, label: {
//                Text("Authenticate")
//            })
//        }
////        .onAppear(perform: authenticate)
//    }
//}

#Preview {
    ContentView()
}

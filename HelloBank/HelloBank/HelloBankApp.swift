//
//  HelloBankApp.swift
//  HelloBank
//
//  Created by Jaromir Jagieluk on 05/05/2025.
//

import SwiftUI

@main
struct HelloBankApp: App {
    @StateObject private var httpEngine = HttpsEngine()
    @StateObject private var securityInformation = SecureInformation()
    
    var body: some Scene {
        WindowGroup {
            TabsView()
                .environmentObject(httpEngine)
                .environmentObject(securityInformation)
        }
    }
}

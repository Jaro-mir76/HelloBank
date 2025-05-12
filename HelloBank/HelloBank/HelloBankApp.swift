//
//  HelloBankApp.swift
//  HelloBank
//
//  Created by Jaromir Jagieluk on 05/05/2025.
//

import SwiftUI

@main
struct HelloBankApp: App {
    @StateObject private var securityEngine = SecureEngine()
    
    var body: some Scene {
        WindowGroup {
            TabsView()
                .environmentObject(securityEngine)
        }
    }
}

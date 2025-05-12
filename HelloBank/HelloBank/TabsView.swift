//
//  TabsView.swift
//  HelloBank
//
//  Created by Jaromir Jagieluk on 05/05/2025.
//

import SwiftUI

struct TabsView: View {
    @State private var selectedTab: Int = 1
    var body: some View {
        TabView(selection: $selectedTab) {
            Tab("Accounts", systemImage: "eurosign.bank.building.fill", value: 1) {
                AccountsInformation()
            }
            Tab("Payments", systemImage: "rectangle.portrait.and.arrow.right", value: 2) {
                PaymentView()
            }
            Tab("Settings", systemImage: "gear", value: 3) {
                SettingsView()
            }
        }
        .toolbar {
            ToolbarItem(placement: .confirmationAction){
                Button("Settings"){
                }
            }
        }
    }
}

#Preview {
    TabsView()
}

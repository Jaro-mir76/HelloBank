//
//  MainView.swift
//  HelloBank
//
//  Created by Jaromir Jagieluk on 05/05/2025.
//

import SwiftUI

struct AccountsInformation: View {
    var body: some View {
        VStack{
            Label("Bank" ,systemImage: "eurosign.bank.building")
                .labelStyle(.iconOnly)
            Text("Hello, Bank!")
        }
        .toolbar {
            ToolbarItem {
                Button("Settings", systemImage: "gear") {
                    
                }
            }
        }
    }
}

#Preview {
    AccountsInformation()
}

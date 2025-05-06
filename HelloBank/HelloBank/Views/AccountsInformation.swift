//
//  MainView.swift
//  HelloBank
//
//  Created by Jaromir Jagieluk on 05/05/2025.
//

import SwiftUI

struct AccountsInformation: View {
    var body: some View {
        NavigationStack {
            VStack{
                Text("Accounts information")
                    .font(.title)
                Spacer()
            }
        }
        .toolbar {
            ToolbarItem(placement: .confirmationAction){
                Button("Settings", systemImage: "gear") {
                    
                }
            }
        }
    }
}

#Preview {
    AccountsInformation()
}

//
//  ContentView.swift
//  HelloBank
//
//  Created by Jaromir Jagieluk on 05/05/2025.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "eurosign.bank.building.fill")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, Bank!")
        }
        .padding()
    }
}

#Preview {
    ContentView()
}

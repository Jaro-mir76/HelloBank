//
//  SettingsView.swift
//  HelloBank
//
//  Created by Jaromir Jagieluk on 05/05/2025.
//

import SwiftUI

struct SettingsView: View {
    @State private var publicCert: String? = nil
    @State private var privateKey: String? = nil
    var body: some View {
        VStack {
            Text("Settings")
                .font(.title)
            Form {
                Section {
                    HStack{
                        Text(publicCert ?? "Missing")
                            .foregroundStyle(privateKey == nil ? .red : .black)
                        Spacer()
                        Button {
                            
                        } label: {
                            Text("Add")
                        }
                        .buttonStyle(.bordered)
                    }
                } header: {
                    Text("Public certificate")
                }
                Section {
                    HStack{
                        Text(privateKey ?? "Missing")
                            .foregroundStyle(privateKey == nil ? .red : .black)
                        Spacer()
                        Button {
                            
                        } label: {
                            Text("Add")
                        }
                        .buttonStyle(.bordered)
                    }
                } header: {
                    Text("Private key")
                }
            }
//            Spacer()
        }
    }
}

#Preview {
    SettingsView()
}

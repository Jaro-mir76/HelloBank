//
//  SettingsView.swift
//  HelloBank
//
//  Created by Jaromir Jagieluk on 05/05/2025.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject private var httpsEngine: HttpsEngine
    @EnvironmentObject private var secutiryInfo: SecureInformation
    @State private var publicCert: String? = nil
    @State private var privateKey: String? = nil
    @State private var clientID: String? = nil
    @State private var clientSecret: String? = nil
    var body: some View {
        VStack {
            Text("Settings")
                .font(.title)
            Form {
                Section {
                    HStack{
                        Text(secutiryInfo.clientId ?? "Missing")
                            .foregroundStyle(secutiryInfo.clientId != nil ? .green : .red)
                        Spacer()
                        Button {
                            
                        } label: {
                            Text("Add")
                        }
                        .buttonStyle(.bordered)
                    }
                } header: {
                    Text("Client Id")
                }
                Section {
                    HStack{
                        Text(secutiryInfo.clientSecret ?? "Missing")
                            .foregroundStyle(secutiryInfo.clientSecret != nil ? .green : .red)
                        Spacer()
                        Button {
                            
                        } label: {
                            Text("Add")
                        }
                        .buttonStyle(.bordered)
                    }
                } header: {
                    Text("Client secret")
                }
                
                Section {
                    HStack{
                        Text(secutiryInfo.publicCertificate != nil ? "OK" : "Missing")
                            .foregroundStyle(secutiryInfo.publicCertificate != nil ? .green : .red)
                        Spacer()
                        Button {
                            let pubCert = try? secutiryInfo.getCertFromFile()
                            secutiryInfo.publicCertificate = pubCert
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
                        Text(secutiryInfo.privateKey != nil ? "OK" : "Missing")
                            .foregroundStyle(secutiryInfo.privateKey != nil ? .green : .red)
                        Spacer()
                        Button {
                            let privKey = try? secutiryInfo.getPrivKeyFromFile()
                            secutiryInfo.privateKey = privKey
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
        .environmentObject(HttpsEngine())
        .environmentObject(SecureInformation())
}

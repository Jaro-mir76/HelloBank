//
//  SettingsView.swift
//  HelloBank
//
//  Created by Jaromir Jagieluk on 05/05/2025.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject private var securityEngine: SecureEngine
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
                        Text(securityEngine.clientId ?? "Missing")
                            .foregroundStyle(securityEngine.clientId != nil ? .green : .red)
                        Spacer()
                        Button {
                            if let clientId = securityEngine.getClientId(){
                                securityEngine.clientId = clientId
                            }
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
                        Text(securityEngine.clientSecret != nil ? "OK" : "Missing")
                            .foregroundStyle(securityEngine.clientSecret != nil ? .green : .red)
                        Spacer()
                        Button {
                            if let clientSecret = securityEngine.getclientSecret(){
                                securityEngine.clientSecret = clientSecret
                            }
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
                        Text(securityEngine.publicCertificate != nil ? "OK" : "Missing")
                            .foregroundStyle(securityEngine.publicCertificate != nil ? .green : .red)
                        Spacer()
                        Button {
                            if let pubCert = securityEngine.getCertFromFile(){
                                securityEngine.publicCertificate = pubCert
                            }
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
                        Text(securityEngine.privateKey != nil ? "OK" : "Missing")
                            .foregroundStyle(securityEngine.privateKey != nil ? .green : .red)
                        Spacer()
                        Button {
                            if let privKey = securityEngine.getPrivKeyFromFile(){
                                securityEngine.privateKey = privKey
                            }
                        } label: {
                            Text("Add")
                        }
                        .buttonStyle(.bordered)
                    }
                } header: {
                    Text("Private key")
                }
                Section {
                    HStack{
                        Text(securityEngine.walletId != nil ? "OK" : "Missing")
                            .foregroundStyle(securityEngine.walletId != nil ? .green : .red)
                        Spacer()
                        Button {
                            securityEngine.requestWalletId()
                        } label: {
                            Text("Get")
                        }
                        .buttonStyle(.bordered)
                    }
                } header: {
                    Text("Wallet")
                }
            }
        }
    }
}

#Preview {
    SettingsView()
        .environmentObject(SecureEngine())
}

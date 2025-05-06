//
//  SecureInformation.swift
//  HelloBank
//
//  Created by Jaromir Jagieluk on 06/05/2025.
//

import Foundation

class SecureInformation: ObservableObject {
    var securityIdentiry: SecIdentity? = nil
    var publicCertificate: SecCertificate? = nil
    var privateKey: SecKey? = nil
    var apiKey: String? = nil
    var clientId: String? = nil
    var clientSecret: String? = nil
    var walletId: String? = nil
    var walletSecret: String? = nil
    var accessToken: String? = nil
    
    
    func addCertificatetoKeychain() {
        
    }
    
    func addPrivKeytoKeychain() {
        
    }
    
    func checkCertKeyConsistency(_ cert: SecCertificate, _ privKey: SecKey) -> Bool {
        
        return false
    }
    
    func createSecIdentity() {
        
    }
}

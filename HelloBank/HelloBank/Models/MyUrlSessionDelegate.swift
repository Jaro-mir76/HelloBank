//
//  MyUrlSessionDelegate.swift
//  HelloBank
//
//  Created by Jaromir Jagieluk on 09/05/2025.
//

import Foundation

class MyUrlSessionDelegate: NSObject, URLSessionDelegate {
    var identity: SecIdentity
    
    init(identity: SecIdentity) {
        self.identity = identity
    }
    
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        
        let sessionCredentials = URLCredential(identity: self.identity, certificates: nil, persistence: .forSession)
        completionHandler(.useCredential, sessionCredentials)
    }
}

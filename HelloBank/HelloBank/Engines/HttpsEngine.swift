//
//  HttpsEngine.swift
//  HelloBank
//
//  Created by Jaromir Jagieluk on 06/05/2025.
//

import Foundation

class HttpsEngine {
    var secureEngine: SecureEngine
    
    init(secureEngine: SecureEngine) {
        self.secureEngine = secureEngine
    }
 
    func getWallet(completionHandler: @escaping (Wallet) -> Void)throws {
        var request = URLRequest(url: makeUrl(from: .createWallet))
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let session = URLSession(configuration: .default, delegate: MyUrlSessionDelegate(identity: secureEngine.securityIdentity!), delegateQueue: nil)
        let requestParam: [String : String] = [
            "clientId" : secureEngine.clientId!,
            "clientSecret" : secureEngine.clientSecret!
        ]
        let jsonData = try JSONEncoder().encode(requestParam)
        request.httpBody = jsonData
        let task = session.dataTask(with: request) { [self] data, response, error in
            if let response = response as? HTTPURLResponse, !(200...299).contains(response.statusCode) {
                secureEngine.error = .badServerResponse
            }
            if let error = error {
                secureEngine.error = .otherError(innerError: error)
            }else if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let wallet = try decoder.decode(Wallet.self, from: data)
                    completionHandler(wallet)
                } catch {
                    secureEngine.error = .otherError(innerError: error)
                }
            }
        }
        task.resume()
    }
    
    func getAccessToken() {
        
    }
    
    func makeRequest() {
        
    }
    
    func makeUrl(from query: HttpQueries) -> URL {
        return URL(string: query.httpsQuery)!
    }
}

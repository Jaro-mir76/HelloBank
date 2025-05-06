//
//  CustomError.swift
//  HelloBank
//
//  Created by Jaromir Jagieluk on 06/05/2025.
//

import Foundation

enum CustomError: Error, LocalizedError {
    case certKeyMissing
    case certKeyInconsistent
    case badServerResponse
    case clientDetailsMissing
    
    var errorDescription: String {
        switch self {
        case .certKeyMissing:
            return "Public certificate and/or Private key are missing!"
        case .certKeyInconsistent:
            return "Public certificate andr Private key are inconsistent!"
        case .badServerResponse:
            return "Bad server response!"
        case .clientDetailsMissing:
            return "Client details are missing!"
        }
    }
    
    var recoverySuggestion: String {
        switch self {
        case .certKeyMissing:
            return "Please upload certificate/key."
        case .certKeyInconsistent:
            return "Please upload correct certificate and corresponding Private key."
        case .badServerResponse:
            return "Please try again."
        case .clientDetailsMissing:
            return "Please provide client details."
        }
    }
}

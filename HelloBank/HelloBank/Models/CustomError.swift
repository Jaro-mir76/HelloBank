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
    case wrongCertificateFile
    case wrongKeyFile
    case cannotReadFile
    case otherError(innerError: Error)
    
    var errorDescription: String {
        switch self {
        case .certKeyMissing:
            return "Public certificate or private key are missing!"
        case .certKeyInconsistent:
            return "Public certificate and private key are inconsistent!"
        case .badServerResponse:
            return "Bad server response!"
        case .clientDetailsMissing:
            return "Client details are missing!"
        case .wrongCertificateFile:
            return "Certificate file is corrupted!"
        case .wrongKeyFile:
            return "Private key file is corrupted!"
        case .cannotReadFile:
            return "Cannot read provided file!"
        case .otherError:
            return "Something went wrong!"
        }
    }
    
    var recoverySuggestion: String {
        switch self {
        case .certKeyMissing:
            return "Please upload certificate/key."
        case .certKeyInconsistent:
            return "Please upload correct certificate and corresponding private key."
        case .badServerResponse:
            return "Please try again."
        case .clientDetailsMissing:
            return "Please provide client details."
        case .wrongCertificateFile:
            return "Please provide correct certificate file."
        case .wrongKeyFile:
            return "Please provide correct private key file."
        case .cannotReadFile:
            return "Please provide different file."
        case .otherError:
            return "Please try again."
        }
    }
}

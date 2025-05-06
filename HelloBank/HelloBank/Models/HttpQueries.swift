//
//  HttpQueries.swift
//  HelloBank
//
//  Created by Jaromir Jagieluk on 06/05/2025.
//

import Foundation

enum HttpQueries {
    case createWallet
    case getAccessToken(String)
    case addBankToWallet
    case getAccountsInformation
    case transactionsHistory
    case initiatePayment
    
    var httpsQuery: String {
        switch self {
        case .createWallet:
            return "https://webapi.developers.erstegroup.com/api/egb/sandbox/v1/sandbox-idp/wallets"
        case .getAccessToken(let value):
            return "https://webapi.developers.erstegroup.com/api/egb/sandbox/v1/sandbox-idp/wallets/" + value + "/tokens"
        case .addBankToWallet:
            return "https://webapi.developers.erstegroup.com/api/egb/sandbox/v1/wallet/v1/banks"
        case .getAccountsInformation:
            return "https://webapi.developers.erstegroup.com/api/egb/sandbox/v1/aisp/v1/accounts"
        case .transactionsHistory:
            return ""
        case .initiatePayment:
            return ""
        }
    }
}

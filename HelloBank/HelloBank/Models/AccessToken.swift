//
//  AccessToken.swift
//  HelloBank
//
//  Created by Jaromir Jagieluk on 06/05/2025.
//

import Foundation

struct AccessToken: Decodable {
    var accessToken: String? = nil
    var tokenType: String? = nil
    var expiresIn: Int? = nil
}

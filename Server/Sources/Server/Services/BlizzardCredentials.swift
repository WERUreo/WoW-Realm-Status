//
//  BlizzardCredentials.swift
//  Server
//
//  Created by Keli'i Martin on 11/10/26.
//

import Foundation

struct BlizzardCredentials {
    let clientID: String
    let clientSecret: String
    
    init(clientID: String?, clientSecret: String?) throws {
        guard let clientID, !clientID.isEmpty else {
            throw BlizzardCredentialsError.missingClientID
        }
        
        guard let clientSecret, !clientSecret.isEmpty else {
            throw BlizzardCredentialsError.missingClientSecret
        }
        
        self.clientID = clientID
        self.clientSecret = clientSecret
    }
}

enum BlizzardCredentialsError: Error, Equatable {
    case missingClientID
    case missingClientSecret
}

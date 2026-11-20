//
//  RealmAPIService.swift
//  Realm Status
//
//  Created by Keli'i Martin on 11/19/26.
//

import Foundation

enum RealmAPIError: Error {
    case invalidResponse
}

nonisolated struct RealmAPIService {
    private let baseURL: URL
    
    init(baseURL: URL) {
        self.baseURL = baseURL
    }
    
    func fetchRealms() async throws -> [Realm] {
        let url = baseURL.appending(
            path: "realms/aggregated"
        )
        
        let (data, response) = try await URLSession.shared.data(
            from: url
        )
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw RealmAPIError.invalidResponse
        }
        
        return try JSONDecoder().decode(
            [Realm].self,
            from: data
        )
    }
}

//
//  RealmListViewModel.swift
//  Realm Status
//
//  Created by Keli'i Martin on 11/20/26.
//

import Foundation
import Observation

@MainActor
@Observable
final class RealmListViewModel {
    var realms: [Realm] = []
    var isLoading = false
    var errorMessage: String?
    var searchText = ""
    
    var filteredRealms: [Realm] {
        guard !searchText.isEmpty else {
            return realms
        }
        
        return realms.filter {
            $0.name.localizedStandardContains(searchText)
        }
    }
    
    func loadRealms() async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }
        
        do {
            let service = RealmAPIService(
                baseURL: URL(string: "http://127.0.0.1:8080")!
            )
            
            realms = try await service.fetchRealms()
            realms.sort {
                $0.name.localizedStandardCompare($1.name) == .orderedAscending
            }
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}

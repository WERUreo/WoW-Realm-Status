//
//  BlizzardTokenManager.swift
//  Server
//
//  Created by Keli'i Martin on 11/12/26.
//

import Foundation

actor BlizzardTokenManager {
    private let authService: BlizzardAuthService
    
    private var accessToken: String?
    private var expirationDate: Date?
    private var refreshTask: Task<BlizzardTokenResponse, any Error>?
    private var refreshID: UUID?
    
    init(authService: BlizzardAuthService) {
        self.authService = authService
    }
    
    private func hasValidToken() -> Bool {
        guard accessToken != nil,
              let expirationDate else {
            return false
        }
        
        return Date().addingTimeInterval(50) < expirationDate
    }
    
    func getAccessToken() async throws -> String {
        if hasValidToken(), let accessToken {
            return accessToken
        }
        
        let task: Task<BlizzardTokenResponse, any Error>
        let taskID: UUID
        
        if let refreshTask, let refreshID {
            task = refreshTask
            taskID = refreshID
        } else {
            taskID = UUID()
            
            task = Task {
                try await authService.requestAccessToken()
            }
            
            refreshTask = task
            refreshID = taskID
        }
        
        let response: BlizzardTokenResponse
        
        do {
            response = try await task.value
        } catch {
            if refreshID == taskID {
                refreshTask = nil
                refreshID = nil
            }
            
            throw error
        }
        
        if refreshID == taskID {
            refreshTask = nil
            refreshID = nil

            accessToken = response.accessToken
            expirationDate = Date().addingTimeInterval(
                TimeInterval(response.expiresIn)
            )
        }

        return response.accessToken
    }
}

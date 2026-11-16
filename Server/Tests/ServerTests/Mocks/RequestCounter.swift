//
//  RequestCounter.swift
//  Server
//
//  Created by Keli'i Martin on 11/12/26.
//

import NIOConcurrencyHelpers

final class RequestCounter: @unchecked Sendable {
    private let count = NIOLockedValueBox(0)
    
    func increment() {
        count.withLockedValue { value in
            value += 1
        }
    }
    
    var value: Int {
        count.withLockedValue { $0 }
    }
}

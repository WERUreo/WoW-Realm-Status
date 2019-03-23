//
//  AccessTokenRequestAdapter.swift
//  WoW-Realm-Status
//
//  Created by Kelii Martin on 3/23/19.
//  Copyright © 2019 WERUreo. All rights reserved.
//

import Foundation
import Alamofire

final class AccessTokenRequestAdapter : RequestAdapter
{
    private let accessToken: String
    
    init(accessToken: String)
    {
        self.accessToken = accessToken
    }
    
    func adapt(_ urlRequest: URLRequest) throws -> URLRequest
    {
        var urlRequest = urlRequest
        
        if let urlString = urlRequest.url?.absoluteString, urlString.hasPrefix("https://us.api.blizzard.com")
        {
            urlRequest.setValue("Bearer " + accessToken, forHTTPHeaderField: "Authorization")
        }
        
        return urlRequest
    }
}

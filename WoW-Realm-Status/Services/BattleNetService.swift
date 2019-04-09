//
//  BattleNetService.swift
//  WoW Database
//
//  Created by Keli'i Martin on 3/19/16.
//  Copyright © 2016 WERUreo. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

let BASE_URL = "https://us.api.blizzard.com/wow/"

typealias RetrieveAllRealmsCompletion = (_ realms: [Realm]?, _ favoriteRealms: [Realm]?, _ error: Error?) -> Void
typealias RequestAccessTokenCompletion = (_ accessToken: String?, _ error: Error?) -> Void

final class BattleNetService
{
    static let sharedInstance = BattleNetService()
    fileprivate var accessToken: String?
    fileprivate let sessionManager: SessionManager =
    {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
        
        return SessionManager(configuration: configuration)
    }()
    
    private init()
    {
        sessionManager.adapter = self
        sessionManager.retrier = self
    }
    
    let realmStatusUrl = "\(BASE_URL)realm/status"

    ////////////////////////////////////////////////////////////
    
    func getAPIKey() -> String?
    {
        var keys: NSDictionary?

        if let path = Bundle.main.path(forResource: "APIKey", ofType: "plist")
        {
            keys = NSDictionary(contentsOfFile: path)
        }

        if let dict = keys
        {
            let apiKey = dict["key"] as? String
            return apiKey
        }

        return nil
    }
    
    ////////////////////////////////////////////////////////////

    fileprivate func getClientIdAndSecret() -> (String, String)?
    {
        var keys: NSDictionary?
        
        if let path = Bundle.main.path(forResource: "APIKey", ofType: "plist")
        {
            keys = NSDictionary(contentsOfFile: path)
        }
        
        if let dict = keys
        {
            let id = dict["client_id"] as! String
            let secret = dict["client_secret"] as! String
            return (id, secret)
        }
        
        return nil
    }
    
    ////////////////////////////////////////////////////////////

    fileprivate func requestAccessToken(_ completion: @escaping RequestAccessTokenCompletion)
    {        
        let parameters: Parameters =
        [
            "grant_type" : "client_credentials"
        ]
        
        if let (id, secret) = getClientIdAndSecret()
        {
            let credentialData = "\(id):\(secret)".data(using: .utf8)!
            let base64Credentials = credentialData.base64EncodedString()
            let headers = ["Authorization": "Basic \(base64Credentials)"]
            let url = "https://us.battle.net/oauth/token"
            Alamofire.request(url, method: .post, parameters: parameters, headers: headers)
                .validate()
                .responseJSON
            { response in
                switch response.result
                {
                case .success:
                    if let value = response.result.value
                    {
                        let json = JSON(value)
                        let token = json["access_token"].stringValue
                        completion(token, nil)
                    }
                case .failure(let error):
                    completion(nil, error)
                }
            }
        }
    }
    
    ////////////////////////////////////////////////////////////

    func retrieveAllRealms(_ completion: @escaping RetrieveAllRealmsCompletion)
    {
        sessionManager.request(realmStatusUrl,
                               method: .get,
                               parameters: nil,
                               encoding: JSONEncoding.default,
                               headers: nil)
            .validate()
            .responseJSON
        { response in
            switch response.result
            {
                case .success:
                    if let value = response.result.value
                    {
                        var realms = [Realm]()
                        var favoriteRealms = [Realm]()
                        
                        let json = JSON(value)
                        for (_, subJson) in json["realms"]
                        {
                            let realm = Realm(json: subJson)
                            realms.append(realm)
                            if realm.favorite
                            {
                                favoriteRealms.append(realm)
                            }
                        }
                        
                        print("**** Sending realms from service ****")
                        completion(realms, favoriteRealms, nil)
                    }
                case .failure(let error):
                    print("**** Error: \(error.localizedDescription) ****")
                    completion(nil, nil, error)
            }
        }
    }
}

////////////////////////////////////////////////////////////
// MARK: - RequestAdapter
////////////////////////////////////////////////////////////

extension BattleNetService : RequestAdapter
{
    func adapt(_ urlRequest: URLRequest) throws -> URLRequest
    {
        var urlRequest = urlRequest
        
        if let urlString = urlRequest.url?.absoluteString,
            urlString.hasPrefix(BASE_URL),
            let accessToken = self.accessToken
        {
            urlRequest.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        }
        
        return urlRequest
    }
}

////////////////////////////////////////////////////////////
// MARK: - RequestRetrier
////////////////////////////////////////////////////////////

extension BattleNetService : RequestRetrier
{
    func should(_ manager: SessionManager, retry request: Request, with error: Error, completion: @escaping RequestRetryCompletion)
    {
        guard let response = request.task?.response as? HTTPURLResponse,
            response.statusCode == 401 else
        {
            completion(false, 0.0)
            return
        }
        
        requestAccessToken
        { [weak self] accessToken, error in
            guard let strongSelf = self else { return }
            
            if let accessToken = accessToken
            {
                strongSelf.accessToken = accessToken
                completion(true, 0.0)
            }
        }
    }
    
    
}

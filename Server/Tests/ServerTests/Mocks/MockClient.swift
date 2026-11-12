//
//  MockClient.swift
//  Server
//
//  Created by Keli'i Martin on 11/10/26.
//

import Vapor

struct MockClient: Client {
    let eventLoop: any EventLoop
    let responseStatus: HTTPResponseStatus
    
    init(
        eventLoop: any EventLoop,
        responseStatus: HTTPResponseStatus = .ok
    ) {
        self.eventLoop = eventLoop
        self.responseStatus = responseStatus
    }
    
    func send(_ request: Vapor.ClientRequest) -> NIOCore.EventLoopFuture<Vapor.ClientResponse> {
        guard request.method == .POST else {
            return eventLoop.makeFailedFuture(
                Abort(.badRequest, reason: "Expected POST request")
            )
        }
        
        guard request.url.string == "https://oauth.battle.net/token" else {
            return eventLoop.makeFailedFuture(
                Abort(.badRequest, reason: "Unexpected OAuth URL")
            )
        }
        
        guard request.headers.basicAuthorization?.username == "test-client-id",
              request.headers.basicAuthorization?.password == "test-client-secret" else {
            return eventLoop.makeFailedFuture(
                Abort(.badRequest, reason: "Invalid Basic Authorization")
            )
        }
        
        guard request.headers.contentType == .urlEncodedForm,
              let body = request.body,
              let bodyString = body.getString(
                at: body.readerIndex,
                length: body.readableBytes
              ),
              bodyString == "grant_type=client_credentials" else {
            return eventLoop.makeFailedFuture(
                Abort(.badRequest, reason: "Invalid OAuth request body")
            )
        }
        
        let response = ClientResponse(
            status: responseStatus,
            headers: HTTPHeaders([
                ("content-type", "application/json")
            ]),
            body: ByteBuffer(string: """
                {
                    "access_token": "test-access-token",
                    "token_type": "bearer",
                    "expires_in": 3600
                }
                """)
        )
        
        return eventLoop.makeSucceededFuture(response)
    }
    
    func delegating(to eventLoop: any NIOCore.EventLoop) -> any Vapor.Client {
        MockClient(
            eventLoop: eventLoop,
            responseStatus: responseStatus
        )
    }
}

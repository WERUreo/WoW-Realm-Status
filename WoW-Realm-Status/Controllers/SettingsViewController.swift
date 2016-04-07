//
//  SettingsViewController.swift
//  WoW-Realm-Status
//
//  Created by Keli'i Martin on 4/5/16.
//  Copyright © 2016 WERUreo. All rights reserved.
//

import UIKit
import StoreKit

class SettingsViewController: UIViewController, SKProductsRequestDelegate
{
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }

    ////////////////////////////////////////////////////////////

    func requestProducts()
    {
        let productIDs: Set<String> = ["com.werureo.wow_realm_status.removeads"]
        let productsRequest = SKProductsRequest(productIdentifiers: productIDs)
        productsRequest.delegate = self
        productsRequest.start()
    }

    ////////////////////////////////////////////////////////////
    // MARK: - SKProductsRequestDelegate
    ////////////////////////////////////////////////////////////

    func productsRequest(request: SKProductsRequest, didReceiveResponse response: SKProductsResponse)
    {
        print("test")
    }
}

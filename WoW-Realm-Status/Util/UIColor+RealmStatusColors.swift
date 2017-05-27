//
//  UIColor+RealmStatusColors.swift
//  WoW-Realm-Status
//
//  Created by Keli'i Martin on 3/29/16.
//  Copyright © 2016 WERUreo. All rights reserved.
//

import Foundation
import UIKit

extension UIColor
{
    @nonobjc class var realmOnlineColor: UIColor
    {
        get { return UIColor(red:0.30, green:0.69, blue:0.31, alpha:1.00) }
    }

    ////////////////////////////////////////////////////////////

    @nonobjc class var realmOfflineColor: UIColor
    {
        get { return UIColor(red:0.96, green:0.26, blue:0.21, alpha:1.00) }
    }
}

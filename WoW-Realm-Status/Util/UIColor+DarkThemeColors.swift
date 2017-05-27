//
//  UIColor+DarkThemeColors.swift
//  WoW-Realm-Status
//
//  Created by Keli'i Martin on 3/29/16.
//  Copyright © 2016 WERUreo. All rights reserved.
//

import Foundation
import UIKit

extension UIColor
{
    @nonobjc class var navBackgroundColor: UIColor
    {
        get { return UIColor(red:0.10, green:0.18, blue:0.23, alpha:1.00) }
    }

    ////////////////////////////////////////////////////////////

    @nonobjc class var viewBackgroundColor: UIColor
    {
        get { return UIColor(red:0.13, green:0.23, blue:0.30, alpha:1.00) }
    }

    ////////////////////////////////////////////////////////////

    @nonobjc class var cellBackgroundColor1: UIColor
    {
        get { return UIColor(red:0.12, green:0.20, blue:0.27, alpha:1.00) }
    }

    ////////////////////////////////////////////////////////////

    @nonobjc class var cellBackgroundColor2: UIColor
    {
        get { return UIColor(red:0.15, green:0.24, blue:0.31, alpha:1.00) }
    }

    ////////////////////////////////////////////////////////////

    @nonobjc class var mirageColor: UIColor
    {
        get { return UIColor(red:0.05, green:0.11, blue:0.16, alpha:1.00) }
    }
}


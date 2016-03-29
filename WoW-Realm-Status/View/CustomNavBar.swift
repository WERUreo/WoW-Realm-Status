//
//  CustomNavBar.swift
//  WoW Database
//
//  Created by Keli'i Martin on 3/25/16.
//  Copyright © 2016 WERUreo. All rights reserved.
//

import UIKit

class CustomNavBar: UINavigationBar
{
    override func drawRect(rect: CGRect)
    {
        // Change the font and size of nav bar text
        if let navBarFont = UIFont(name: "NotoSans", size: 16.0)
        {
            let navBarAttributesDictionary: [String: AnyObject]? = [
                NSForegroundColorAttributeName: UIColor(red:0.94, green:0.77, blue:0.50, alpha:1.00),
                NSFontAttributeName: navBarFont
            ]

            self.titleTextAttributes = navBarAttributesDictionary
        }

        self.backgroundColor = UIColor(red:0.11, green:0.06, blue:0.04, alpha:1.00)
    }
}

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
    override func draw(_ rect: CGRect)
    {
        // Change the font and size of nav bar text
        if let navBarFont = UIFont(name: "NotoSans", size: 16.0)
        {
            let navBarAttributesDictionary: [NSAttributedStringKey: Any]? = [
                NSAttributedStringKey.foregroundColor: UIColor.white,
                NSAttributedStringKey.font: navBarFont
            ]

            self.titleTextAttributes = navBarAttributesDictionary
        }

        self.tintColor = UIColor.white
    }
}

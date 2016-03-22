//
//  MaterialView.swift
//  WoW Database
//
//  Created by Keli'i Martin on 3/21/16.
//  Copyright © 2016 WERUreo. All rights reserved.
//

import UIKit

@IBDesignable
class MaterialView: UIView
{
    @IBInspectable var cornerRadius: CGFloat = 2.0
    {
        didSet
        {
            self.layer.cornerRadius = cornerRadius
        }
    }

    ////////////////////////////////////////////////////////////

    override func awakeFromNib()
    {
        self.setupView()
    }

    ////////////////////////////////////////////////////////////

    func setupView()
    {
        layer.cornerRadius = cornerRadius
        layer.shadowColor = UIColor(red: SHADOW_COLOR, green: SHADOW_COLOR, blue: SHADOW_COLOR, alpha: 0.5).CGColor
        layer.shadowOpacity = 0.8
        layer.shadowRadius = 5.0
        layer.shadowOffset = CGSizeMake(0.0, 2.0)
    }
}

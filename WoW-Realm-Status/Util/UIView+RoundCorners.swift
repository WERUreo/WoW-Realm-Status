//
//  UIView+RoundCorners.swift
//  WoW Database
//
//  Created by Keli'i Martin on 3/22/16.
//  Copyright © 2016 WERUreo. All rights reserved.
//

import Foundation
import UIKit

extension UIView
{
    /**
     Rounds the given set of corners to the specified radius

     - parameter corners: Corners to round
     - parameter radius:  Radius to round to
     */
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat)
    {
        _ = _roundCorners(corners, radius: radius)
    }

    /**
     Rounds the given set of corners to the specified radius with a border

     - parameter corners:     Corners to round
     - parameter radius:      Radius to round to
     - parameter borderColor: The border color
     - parameter borderWidth: The border width
     */
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat, borderColor: UIColor, borderWidth: CGFloat)
    {
        let mask = _roundCorners(corners, radius: radius)
        addBorder(mask, borderColor: borderColor, borderWidth: borderWidth)
    }

}

private extension UIView
{
    func _roundCorners(_ corners: UIRectCorner, radius: CGFloat) -> CAShapeLayer
    {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
        return mask
    }

    func addBorder(_ mask: CAShapeLayer, borderColor: UIColor, borderWidth: CGFloat)
    {
        let borderLayer = CAShapeLayer()
        borderLayer.path = mask.path
        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.strokeColor = borderColor.cgColor
        borderLayer.lineWidth = borderWidth
        borderLayer.frame = bounds
        layer.addSublayer(borderLayer)
    }
    
}

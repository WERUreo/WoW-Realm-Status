//
//  RealmStatusSplitViewController.swift
//  WoW Database
//
//  Created by Keli'i Martin on 3/24/16.
//  Copyright © 2016 WERUreo. All rights reserved.
//

import UIKit

class RealmStatusSplitViewController: UISplitViewController, UISplitViewControllerDelegate
{
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.delegate = self
        self.preferredDisplayMode = .AllVisible
    }

    ////////////////////////////////////////////////////////////

    override func preferredStatusBarStyle() -> UIStatusBarStyle
    {
        return .LightContent
    }

    ////////////////////////////////////////////////////////////

    func splitViewController(splitViewController: UISplitViewController, collapseSecondaryViewController secondaryViewController: UIViewController, ontoPrimaryViewController primaryViewController: UIViewController) -> Bool
    {
        return true
    }
}

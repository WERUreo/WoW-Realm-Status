//
//  RealmCell.swift
//  WoW Database
//
//  Created by Keli'i Martin on 3/21/16.
//  Copyright © 2016 WERUreo. All rights reserved.
//

import UIKit
import MGSwipeTableCell

@IBDesignable
class RealmCell: MGSwipeTableCell
{
    @IBOutlet weak var realmName: UILabel!
    @IBOutlet weak var realmStatusView: UIView!
    @IBOutlet weak var realmPopulation: UILabel!
    @IBOutlet weak var realmType: UILabel!

    ////////////////////////////////////////////////////////////

    override func awakeFromNib()
    {
        super.awakeFromNib()
    }

    ////////////////////////////////////////////////////////////

    override func setSelected(selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    ////////////////////////////////////////////////////////////

    func configureCell(realm: Realm)
    {
        realmName.text = realm.name
        realmStatusView.backgroundColor = realm.status ? UIColor.realmOnlineColor() : UIColor.realmOfflineColor()
        realmStatusView.roundCorners([.TopLeft, .BottomLeft], radius: 2.0)
        realmPopulation.text = realm.population
        realmType.text = realm.type.toString()
    }
}

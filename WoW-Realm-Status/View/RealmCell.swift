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
    @IBOutlet weak var favoriteIcon: UIImageView!

    ////////////////////////////////////////////////////////////

    override func awakeFromNib()
    {
        super.awakeFromNib()
    }

    ////////////////////////////////////////////////////////////

    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    ////////////////////////////////////////////////////////////

    func configureCell(_ realm: Realm)
    {
        realmName.text = realm.name
        realmStatusView.backgroundColor = realm.status ? UIColor(named: "realmOnline")! : UIColor(named: "realmOffline")!
        realmStatusView.roundCorners([.topLeft, .bottomLeft], radius: 2.0)
        realmPopulation.text = realm.population
        realmType.text = realm.type.toString()
        favoriteIcon.image = realm.favorite ? UIImage(named: "Favorite Filled") : nil
    }
}

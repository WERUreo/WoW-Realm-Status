//
//  RealmDetailVC.swift
//  WoW Database
//
//  Created by Keli'i Martin on 3/24/16.
//  Copyright © 2016 WERUreo. All rights reserved.
//

import UIKit

class RealmDetailVC: UIViewController
{
    // MARK: - Outlets
    @IBOutlet weak var realmName: UILabel!
    @IBOutlet weak var realmType: UILabel!
    @IBOutlet weak var battlegroup: UILabel!
    @IBOutlet weak var wintergraspFaction: UILabel!
    @IBOutlet weak var wintergraspStatus: UILabel!
    @IBOutlet weak var wintergraspNext: UILabel!
    @IBOutlet weak var tolBaradFaction: UILabel!
    @IBOutlet weak var tolBaradStatus: UILabel!
    @IBOutlet weak var tolBaradNext: UILabel!

    // MARK: - Properties
    var realm: Realm?

    ////////////////////////////////////////////////////////////

    override func viewDidLoad()
    {
        super.viewDidLoad()
        configureView()
    }

    ////////////////////////////////////////////////////////////

    func configureView()
    {
        if let realm = realm
        {
            realmName.text = realm.name
            realmType.text = realm.type.toString()
            battlegroup.text =  "Battlegroup: \(realm.battlegroup)"

            let formatter = NSDateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

            wintergraspFaction.text = realm.wintergrasp.controllingFaction.toString()
            wintergraspStatus.text = realm.wintergrasp.status.toString()
            wintergraspNext.text = formatter.stringFromDate(realm.wintergrasp.next)

            tolBaradFaction.text = realm.tolBarad.controllingFaction.toString()
            tolBaradStatus.text = realm.tolBarad.status.toString()
            tolBaradNext.text = formatter.stringFromDate(realm.tolBarad.next)

        }
    }
}

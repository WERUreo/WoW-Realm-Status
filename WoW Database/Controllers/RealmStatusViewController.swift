//
//  RealmStatusViewController.swift
//  WoW Database
//
//  Created by Keli'i Martin on 3/20/16.
//  Copyright © 2016 WERUreo. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import iAd

class RealmStatusViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate
{
    @IBOutlet weak var tableView: UITableView!

    let realmSegueIdentifier = "RealmDetailSegue"
    var realms = [Realm]()

    ////////////////////////////////////////////////////////////

    override func viewDidLoad()
    {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self

        self.canDisplayBannerAds = true

        let parameters =
        [
            "locale" : "en-US",
            "apikey" : BattleNetService.sharedInstance.getAPIKey()!
        ]

        Alamofire.request(.GET, BattleNetService.sharedInstance.realmStatusUrl, parameters: parameters).validate().responseJSON { response in
            switch response.result
            {
            case .Success:
                if let value = response.result.value
                {
                    let json = JSON(value)
                    for (_, subJson) in json["realms"]
                    {
                        self.realms.append(Realm(json: subJson))
                    }

                    self.tableView.reloadData()

                }
            case .Failure(let error):
                print(error)
            }
        }
    }

    ////////////////////////////////////////////////////////////

    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(animated)
    }

    ////////////////////////////////////////////////////////////

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    ////////////////////////////////////////////////////////////

    // MARK: - Table view data source

    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }

    ////////////////////////////////////////////////////////////

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return realms.count
    }

    ////////////////////////////////////////////////////////////

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let realm = realms[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier("RealmCell", forIndexPath: indexPath) as? RealmCell
        if let realmCell = cell
        {
            realmCell.configureCell(realm)
            return realmCell
        }
        else
        {
            return RealmCell()
        }
    }

    ////////////////////////////////////////////////////////////

    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if segue.identifier == realmSegueIdentifier
        {
            if let destination = segue.destinationViewController as? RealmDetailVC
            {
                if let indexPathRow = tableView.indexPathForSelectedRow?.row
                {
                    destination.realm = realms[indexPathRow]
                }
            }
        }
    }
}

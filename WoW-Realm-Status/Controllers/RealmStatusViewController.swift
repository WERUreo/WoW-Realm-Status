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
    var sections: [(index: Int, length: Int, title: String)] = Array()

    ////////////////////////////////////////////////////////////

    override func viewDidLoad()
    {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self

        tableView.sectionIndexBackgroundColor = UIColor.viewBackgroundColor()
        tableView.sectionIndexColor = UIColor.whiteColor()

        // Set up iAD banner
        canDisplayBannerAds = true

        // FIXME: - remove this from the view controller
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

                    self.createSections(self.realms)

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

    func createSections(realms: [Realm])
    {
        // clear sections
        sections.removeAll()

        var index = 0
        for i in 0..<realms.count
        {
            let commonPrefix = realms[i].name.commonPrefixWithString(realms[index].name, options: .CaseInsensitiveSearch)
            if commonPrefix.characters.count == 0
            {
                let string = realms[index].name.uppercaseString
                let firstCharacter = string[string.startIndex]
                let title = "\(firstCharacter)"
                let newSection = (index: index, length: i - index, title: title)
                sections.append(newSection)
                index = i
            }
        }
    }

    ////////////////////////////////////////////////////////////

    // MARK: - Table view data source

    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return sections.count
    }

    ////////////////////////////////////////////////////////////

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return sections[section].length
    }

    ////////////////////////////////////////////////////////////

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let indexPathRow = sections[indexPath.section].index + indexPath.row
        let realm = realms[indexPathRow]

        let cell = tableView.dequeueReusableCellWithIdentifier("RealmCell", forIndexPath: indexPath) as? RealmCell
        if let realmCell = cell
        {
            realmCell.configureCell(realm)
            realmCell.backgroundColor = indexPathRow % 2 == 0 ? UIColor.cellBackgroundColor1() : UIColor.cellBackgroundColor2()
            return realmCell
        }
        else
        {
            return RealmCell()
        }
    }

    ////////////////////////////////////////////////////////////

    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        return sections[section].title
    }

    ////////////////////////////////////////////////////////////

    func sectionIndexTitlesForTableView(tableView: UITableView) -> [String]?
    {
        return sections.map { $0.title }
    }

    ////////////////////////////////////////////////////////////

    func tableView(tableView: UITableView, sectionForSectionIndexTitle title: String, atIndex index: Int) -> Int
    {
        return index
    }

    ////////////////////////////////////////////////////////////

    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if segue.identifier == realmSegueIdentifier
        {
            if let topNav = segue.destinationViewController as? UINavigationController,
                let destination = topNav.topViewController as? RealmDetailVC
            {
                if let indexPathRow = tableView.indexPathForSelectedRow?.row,
                    let indexPathSection = tableView.indexPathForSelectedRow?.section
                {
                    destination.realm = realms[sections[indexPathSection].index + indexPathRow]
                }
            }
        }
    }

    ////////////////////////////////////////////////////////////
}

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
import MGSwipeTableCell

class RealmStatusViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate, MGSwipeTableCellDelegate
{
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var favoritesBarButton: UIBarButtonItem!

    var realms = [Realm]()
    var favorites = [String]()
    var favoriteRealms = [Realm]()
    var filterOnFavorites = false
    var sections: [(index: Int, length: Int, title: String)] = Array()
    lazy var refreshControl: UIRefreshControl =
    {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(RealmStatusViewController.handleRefresh), forControlEvents: .ValueChanged)

        return refreshControl
    }()

    ////////////////////////////////////////////////////////////

    override func viewDidLoad()
    {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.addSubview(refreshControl)

        tableView.sectionIndexBackgroundColor = UIColor.viewBackgroundColor()
        tableView.sectionIndexColor = UIColor.whiteColor()

        if let favRealms = USER_DEFAULTS.arrayForKey(FAVORITE_REALMS_KEY) as? [String]
        {
            favorites = favRealms
        }

        // Set up iAD banner
        canDisplayBannerAds = true

        retrieveRealms()
    }

    ////////////////////////////////////////////////////////////

    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(animated)
    }

    ////////////////////////////////////////////////////////////

    override func preferredStatusBarStyle() -> UIStatusBarStyle
    {
        return .LightContent
    }

    ////////////////////////////////////////////////////////////

    func retrieveRealms()
    {
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
                    // If the realms array has been populated before (we are refreshing the table view),
                    // we must clear the array before re-populating it.
                    self.realms.removeAll()
                    self.favoriteRealms.removeAll()
                    
                    let json = JSON(value)
                    for (_, subJson) in json["realms"]
                    {
                        let realm = Realm(json: subJson)
                        self.realms.append(realm)
                        if realm.favorite
                        {
                            self.favoriteRealms.append(realm)
                        }
                    }

                    dispatch_async(dispatch_get_main_queue())
                    {
                        if !self.filterOnFavorites
                        {
                            self.createSections(self.realms)
                        }
                        self.tableView.reloadData()
                        self.refreshControl.endRefreshing()
                    }
                }
                else
                {
                    self.showErrorAlert("No realms found", msg: "There appears to be a problem retrieving realms from Battle.net.  Please try again later.")
                }
            case .Failure(let error):
                print(error)
                self.showErrorAlert("Connection error", msg: "There appears to be a problem with the connection to Battle.net.  Please try again later.")
            }
        }
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

    func showErrorAlert(title: String, msg: String)
    {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .Alert)
        let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alert.addAction(action)
        presentViewController(alert, animated: true, completion: nil)
    }

    ////////////////////////////////////////////////////////////

    func handleRefresh(refreshControl: UIRefreshControl)
    {
        retrieveRealms()
    }

    ////////////////////////////////////////////////////////////

    func addToFavorites(realm: Realm)
    {
        favorites.append(realm.slug)
        USER_DEFAULTS.setObject(favorites, forKey: FAVORITE_REALMS_KEY)
        favoriteRealms.append(realm)
    }

    ////////////////////////////////////////////////////////////

    func removeFromFavorites(realm: Realm)
    {
        if let index = favorites.indexOf(realm.slug)
        {
            favorites.removeAtIndex(index)
            USER_DEFAULTS.setObject(favorites, forKey: FAVORITE_REALMS_KEY)

            if let realmIndex = favoriteRealms.indexOf({$0.slug == realm.slug})
            {
                favoriteRealms.removeAtIndex(realmIndex)
            }
        }
    }

    ////////////////////////////////////////////////////////////

    @IBAction func toggleFavorites(sender: UIBarButtonItem)
    {
        favoritesBarButton.image = filterOnFavorites ? UIImage(named: "Favorite Outline")! : UIImage(named: "Favorite Filled")!
        filterOnFavorites = !filterOnFavorites

        tableView.reloadData()
    }

    ////////////////////////////////////////////////////////////
    // MARK: - Table view data source
    ////////////////////////////////////////////////////////////

    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return filterOnFavorites ? 1 : sections.count
    }

    ////////////////////////////////////////////////////////////

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return filterOnFavorites ? favoriteRealms.count : sections[section].length
    }

    ////////////////////////////////////////////////////////////

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let indexPathRow = filterOnFavorites ? indexPath.row : sections[indexPath.section].index + indexPath.row
        let realm = filterOnFavorites ? favoriteRealms[indexPathRow] : realms[indexPathRow]

        let cell = tableView.dequeueReusableCellWithIdentifier("RealmCell", forIndexPath: indexPath) as? RealmCell
        if let realmCell = cell
        {
            realmCell.delegate = self
            realmCell.configureCell(realm)
            realmCell.backgroundColor = (indexPathRow % 2 == 0) ? UIColor.cellBackgroundColor1() : UIColor.cellBackgroundColor2()
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
        return filterOnFavorites ? nil : sections[section].title
    }

    ////////////////////////////////////////////////////////////

    func sectionIndexTitlesForTableView(tableView: UITableView) -> [String]?
    {
        return filterOnFavorites ? nil : sections.map { $0.title }
    }

    ////////////////////////////////////////////////////////////

    func tableView(tableView: UITableView, sectionForSectionIndexTitle title: String, atIndex index: Int) -> Int
    {
        return filterOnFavorites ? 0 : index
    }

    ////////////////////////////////////////////////////////////
    // MARK: - MGSwipeTableCellDelegate
    ////////////////////////////////////////////////////////////

    func swipeTableCell(cell: MGSwipeTableCell!, canSwipe direction: MGSwipeDirection) -> Bool
    {
        return true
    }

    ////////////////////////////////////////////////////////////

    func swipeTableCell(cell: MGSwipeTableCell!, swipeButtonsForDirection direction: MGSwipeDirection, swipeSettings: MGSwipeSettings!, expansionSettings: MGSwipeExpansionSettings!) -> [AnyObject]!
    {
        swipeSettings.transition = .Drag
        expansionSettings.buttonIndex = 0

        let indexPath = tableView.indexPathForCell(cell)
        let indexPathRow = filterOnFavorites ? indexPath!.row : sections[indexPath!.section].index + indexPath!.row
        let realm = filterOnFavorites ? favoriteRealms[indexPathRow] : realms[indexPathRow]

        if (direction == .LeftToRight)
        {
            expansionSettings.fillOnTrigger = false
            expansionSettings.threshold = 2

            if (!realm.favorite)
            {
                let addFavoriteButton = MGSwipeButton(title: "", icon: UIImage(named: "Favorite Outline"), backgroundColor: UIColor.realmOnlineColor())
                { cell -> Bool in
                    realm.favorite = true
                    self.addToFavorites(realm)
                    self.tableView.reloadData()
                    return true
                }

                return [addFavoriteButton]
            }
            else
            {
                let removeFavoriteButton = MGSwipeButton(title: "", icon: UIImage(named: "Remove"), backgroundColor: UIColor.realmOfflineColor())
                { cell -> Bool in
                    realm.favorite = false
                    self.removeFromFavorites(realm)
                    self.tableView.reloadData()
                    return true
                }

                return [removeFavoriteButton]
            }
        }

        return nil
    }
}

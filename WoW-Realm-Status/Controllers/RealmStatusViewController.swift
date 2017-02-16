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
import GoogleMobileAds
import MGSwipeTableCell

class RealmStatusViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate
{
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var favoritesBarButton: UIBarButtonItem!
    @IBOutlet weak var bannerView: GADBannerView!

    var realms = [Realm]()
    var favorites = [String]()
    var favoriteRealms = [Realm]()
    var filterOnFavorites = false
    var sections: [(index: Int, length: Int, title: String)] = Array()
    var adReceived: Bool = false

    lazy var refreshControl: UIRefreshControl =
    {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(RealmStatusViewController.handleRefresh), for: .valueChanged)

        return refreshControl
    }()

    ////////////////////////////////////////////////////////////

    override func viewDidLoad()
    {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.addSubview(refreshControl)

        tableView.sectionIndexBackgroundColor = UIColor.viewBackgroundColor
        tableView.sectionIndexColor = UIColor.white

        if let favRealms = Constants.UserDefaults.array(forKey: Constants.FavoriteRealmsKey) as? [String]
        {
            favorites = favRealms
        }

        bannerView.adSize = kGADAdSizeSmartBannerPortrait
        bannerView.adUnitID = "ca-app-pub-9741170647819017/2972782284"
        bannerView.rootViewController = self
        bannerView.delegate = self
        bannerView.load(GADRequest())

        retrieveRealms()
    }

    ////////////////////////////////////////////////////////////

    override var preferredStatusBarStyle : UIStatusBarStyle
    {
        return .lightContent
    }

    ////////////////////////////////////////////////////////////

    func retrieveRealms()
    {
        let parameters =
        [
            "locale" : "en-US",
            "apikey" : BattleNetService.sharedInstance.getAPIKey()!
        ]

        Alamofire.request(BattleNetService.sharedInstance.realmStatusUrl, method: .get, parameters: parameters).validate().responseJSON
        { response in
            switch response.result
            {
            case .success:
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

                    DispatchQueue.main.async
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
            case .failure(let error):
                print(error)
                self.showErrorAlert("Connection error", msg: "There appears to be a problem with the connection to Battle.net.  Please try again later.")
            }
        }
    }

    ////////////////////////////////////////////////////////////

    func createSections(_ realms: [Realm])
    {
        // clear sections
        sections.removeAll()

        var index = 0
        for i in 0..<realms.count
        {
            let commonPrefix = realms[i].name.commonPrefix(with: realms[index].name, options: .caseInsensitive)
            if commonPrefix.characters.count == 0
            {
                let string = realms[index].name.uppercased()
                let firstCharacter = string[string.startIndex]
                let title = "\(firstCharacter)"
                let newSection = (index: index, length: i - index, title: title)
                sections.append(newSection)
                index = i
            }
        }
    }

    ////////////////////////////////////////////////////////////

    func showErrorAlert(_ title: String, msg: String)
    {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }

    ////////////////////////////////////////////////////////////

    func handleRefresh(_ refreshControl: UIRefreshControl)
    {
        retrieveRealms()
    }

    ////////////////////////////////////////////////////////////

    func addToFavorites(_ realm: Realm)
    {
        favorites.append(realm.slug)
        Constants.UserDefaults.set(favorites, forKey: Constants.FavoriteRealmsKey)
        favoriteRealms.append(realm)
    }

    ////////////////////////////////////////////////////////////

    func removeFromFavorites(_ realm: Realm)
    {
        if let index = favorites.index(of: realm.slug)
        {
            favorites.remove(at: index)
            Constants.UserDefaults.set(favorites, forKey: Constants.FavoriteRealmsKey)

            if let realmIndex = favoriteRealms.index(where: {$0.slug == realm.slug})
            {
                favoriteRealms.remove(at: realmIndex)
            }
        }
    }

    ////////////////////////////////////////////////////////////

    @IBAction func toggleFavorites(_ sender: UIBarButtonItem)
    {
        favoritesBarButton.image = filterOnFavorites ? UIImage(named: "Favorite Outline")! : UIImage(named: "Favorite Filled")!
        filterOnFavorites = !filterOnFavorites

        tableView.reloadData()
    }

    ////////////////////////////////////////////////////////////
    // MARK: - Table view data source
    ////////////////////////////////////////////////////////////

    func numberOfSections(in tableView: UITableView) -> Int
    {
        return filterOnFavorites ? 1 : sections.count
    }

    ////////////////////////////////////////////////////////////

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return filterOnFavorites ? favoriteRealms.count : sections[section].length
    }

    ////////////////////////////////////////////////////////////

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let indexPathRow = filterOnFavorites ? (indexPath as NSIndexPath).row : sections[(indexPath as NSIndexPath).section].index + (indexPath as NSIndexPath).row
        let realm = filterOnFavorites ? favoriteRealms[indexPathRow] : realms[indexPathRow]

        let cell = tableView.dequeueReusableCell(withIdentifier: "RealmCell", for: indexPath) as? RealmCell
        if let realmCell = cell
        {
            realmCell.delegate = self
            realmCell.configureCell(realm)
            realmCell.backgroundColor = (indexPathRow % 2 == 0) ? UIColor.cellBackgroundColor1 : UIColor.cellBackgroundColor2
            return realmCell
        }
        else
        {
            return RealmCell()
        }
    }

    ////////////////////////////////////////////////////////////

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        return filterOnFavorites ? nil : sections[section].title
    }

    ////////////////////////////////////////////////////////////

    func sectionIndexTitles(for tableView: UITableView) -> [String]?
    {
        return filterOnFavorites ? nil : sections.map { $0.title }
    }

    ////////////////////////////////////////////////////////////

    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int
    {
        return filterOnFavorites ? 0 : index
    }
}

////////////////////////////////////////////////////////////
// MARK: - GADBannerViewDelegate
////////////////////////////////////////////////////////////

extension RealmStatusViewController : GADBannerViewDelegate
{
    func adViewDidReceiveAd(_ bannerView: GADBannerView!)
    {
        if !adReceived
        {
            var currentRect = tableView.frame
            currentRect.size.height -= bannerView.frame.height
            tableView.frame = currentRect
            adReceived = true
        }
    }

    ////////////////////////////////////////////////////////////

    func adView(_ bannerView: GADBannerView!, didFailToReceiveAdWithError error: GADRequestError!)
    {
        print("adView:didFailToReceiveAdWIthError: \(error.localizedDescription)")
    }
}

////////////////////////////////////////////////////////////
// MARK: - MGSwipeTableCellDelegate
////////////////////////////////////////////////////////////

extension RealmStatusViewController : MGSwipeTableCellDelegate
{
    func swipeTableCell(_ cell: MGSwipeTableCell!, canSwipe direction: MGSwipeDirection) -> Bool
    {
        return true
    }

    ////////////////////////////////////////////////////////////

    func swipeTableCell(_ cell: MGSwipeTableCell!, swipeButtonsFor direction: MGSwipeDirection, swipeSettings: MGSwipeSettings!, expansionSettings: MGSwipeExpansionSettings!) -> [Any]!
    {
        swipeSettings.transition = .drag
        expansionSettings.buttonIndex = 0

        let indexPath = tableView.indexPath(for: cell)
        let indexPathRow = filterOnFavorites ? (indexPath! as NSIndexPath).row : sections[(indexPath! as NSIndexPath).section].index + (indexPath! as NSIndexPath).row
        let realm = filterOnFavorites ? favoriteRealms[indexPathRow] : realms[indexPathRow]

        if (direction == .leftToRight)
        {
            expansionSettings.fillOnTrigger = false
            expansionSettings.threshold = 2

            if (!realm.favorite)
            {
                let addFavoriteButton = MGSwipeButton(title: "", icon: UIImage(named: "Favorite Outline"), backgroundColor: UIColor.realmOnlineColor)
                { cell -> Bool in
                    realm.favorite = true
                    self.addToFavorites(realm)
                    self.tableView.reloadData()
                    return true
                }

                return [addFavoriteButton!]
            }
            else
            {
                let removeFavoriteButton = MGSwipeButton(title: "", icon: UIImage(named: "Remove"), backgroundColor: UIColor.realmOfflineColor)
                { cell -> Bool in
                    realm.favorite = false
                    self.removeFromFavorites(realm)
                    self.tableView.reloadData()
                    return true
                }

                return [removeFavoriteButton!]
            }
        }
        
        return nil
    }
}

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

class RealmStatusViewController: UIViewController, UITableViewDelegate, UINavigationControllerDelegate
{
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var favoritesBarButton: UIBarButtonItem!
    @IBOutlet weak var bannerView: GADBannerView!

    var realms = [Realm]()
    var favorites = [String]()
    var favoriteRealms = [Realm]()
    var filterOnFavorites = false
    var sortedSections = [RealmSection]()
    var adReceived: Bool = false

    lazy var refreshControl: UIRefreshControl =
    {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self,
                                 action: #selector(RealmStatusViewController.handleRefresh),
                                 for: .valueChanged)

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
        tableView.sectionIndexColor = UIColor.white

        if let favRealms = Constants.UserDefaults.array(forKey: Constants.FavoriteRealmsKey) as? [String]
        {
            favorites = favRealms
        }
        
        retrieveRealms()

        bannerView.adSize = kGADAdSizeSmartBannerPortrait
        bannerView.adUnitID = "ca-app-pub-9741170647819017/2972782284"
        bannerView.rootViewController = self
        bannerView.delegate = self
        bannerView.load(GADRequest())
    }

    ////////////////////////////////////////////////////////////

    override var preferredStatusBarStyle : UIStatusBarStyle
    {
        return .lightContent
    }

    ////////////////////////////////////////////////////////////

    func retrieveRealms()
    {
        BattleNetService.sharedInstance.retrieveAllRealms
        { (realms, favoriteRealms, error) in
            if error == nil
            {
                // If the realms array has been populated before (we are refreshing the table view),
                // we must clear the array before re-populating it.
                self.realms.removeAll()
                self.favoriteRealms.removeAll()
                
                if let realms = realms
                {
                    self.realms = realms
                }
                
                if let favoriteRealms = favoriteRealms
                {
                    self.favoriteRealms = favoriteRealms
                }

                DispatchQueue.main.async
                {
                    if !self.filterOnFavorites
                    {
                        print("**** Creating sections ****")
                        self.createSections(self.realms)
                    }
                    self.tableView.reloadData()
                    self.refreshControl.endRefreshing()
                }
            }
            else
            {
                if let error = error
                {
                    print(error.localizedDescription)
                }
            }
        }
    }

    ////////////////////////////////////////////////////////////

    func createSections(_ realms: [Realm])
    {
        let sections = Dictionary(grouping: realms) { String($0.name.prefix(1)) }
        self.sortedSections = sections.map(RealmSection.init(index:realms:)).sorted()
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

    @objc func handleRefresh(_ refreshControl: UIRefreshControl)
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
        if let index = favorites.firstIndex(of: realm.slug)
        {
            favorites.remove(at: index)
            Constants.UserDefaults.set(favorites, forKey: Constants.FavoriteRealmsKey)

            if let realmIndex = favoriteRealms.firstIndex(where: {$0.slug == realm.slug})
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
}

////////////////////////////////////////////////////////////
// MARK: - UITableViewDataSource
////////////////////////////////////////////////////////////

extension RealmStatusViewController : UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return filterOnFavorites ? 1 : sortedSections.count
    }
    
    ////////////////////////////////////////////////////////////
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return filterOnFavorites ? favoriteRealms.count : sortedSections[section].realms.count
    }
    
    ////////////////////////////////////////////////////////////
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let realm = filterOnFavorites ? favoriteRealms[indexPath.row] : sortedSections[indexPath.section].realms[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "RealmCell", for: indexPath) as? RealmCell
        if let realmCell = cell
        {
            realmCell.delegate = self
            realmCell.configureCell(realm)
            realmCell.backgroundColor = (indexPath.row % 2 == 0) ? UIColor(named: "cellBackground1")! : UIColor(named: "cellBackground2")!
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
        return filterOnFavorites ? nil : sortedSections[section].index
    }
    
    ////////////////////////////////////////////////////////////
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]?
    {
        return filterOnFavorites ? nil : sortedSections.map { $0.index }
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
    func adViewDidReceiveAd(_ bannerView: GADBannerView)
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

    func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError)
    {
        print("adView:didFailToReceiveAdWIthError: \(error.localizedDescription)")
    }
}

////////////////////////////////////////////////////////////
// MARK: - MGSwipeTableCellDelegate
////////////////////////////////////////////////////////////

extension RealmStatusViewController : MGSwipeTableCellDelegate
{
    func swipeTableCell(_ cell: MGSwipeTableCell, canSwipe direction: MGSwipeDirection) -> Bool
    {
        return true
    }

    ////////////////////////////////////////////////////////////

    func swipeTableCell(_ cell: MGSwipeTableCell, swipeButtonsFor direction: MGSwipeDirection, swipeSettings: MGSwipeSettings, expansionSettings: MGSwipeExpansionSettings) -> [UIView]?
    {
        swipeSettings.transition = .drag
        expansionSettings.buttonIndex = 0
        
        guard let indexPath = tableView.indexPath(for: cell) else { return nil }
        let realm = filterOnFavorites ? favoriteRealms[indexPath.row] : sortedSections[indexPath.section].realms[indexPath.row]
        
        if direction == .leftToRight
        {
            expansionSettings.fillOnTrigger = false
            expansionSettings.threshold = 2
            
            if !realm.favorite
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

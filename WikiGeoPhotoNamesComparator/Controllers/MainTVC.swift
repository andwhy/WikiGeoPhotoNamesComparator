//
//  MainTVC.swift
//  WikiGeoPhotoNamesComparator
//
//  Created by Андрей Рожков on 08.03.17.
//  Copyright © 2017 AndreyRozhkov. All rights reserved.
//

import UIKit

class MainTVC: UITableViewController {
    
    
    // MARK: Lifecycle
    
    var activityView:UIActivityIndicatorView?
    
    var imagesGroupsArray:[Groups]? = [] {
        didSet {
            DispatchQueue.main.sync {
                self.activityView!.stopAnimating()
                self.tableView.reloadData()
            }
        }
    }
    
    func getDataToShow() {
        
        activityView?.startAnimating()
        DataManager().getImagesGroups{ result in
            self.imagesGroupsArray = result
        }
    }
    
    // MARK: View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Separate words counter"
        self.refreshControl?.addTarget(self, action: #selector(actionRefresh), for: UIControlEvents.valueChanged)
        activityView = UIActivityIndicatorView.bindActivityIndicatorTo(viewController: (self.navigationController)!)
    }

    override func viewWillAppear(_ animated: Bool) {
        getDataToShow()
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return (imagesGroupsArray?.count)!
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Array(imagesGroupsArray![section].images!).count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "\(imagesGroupsArray![section].word_counter) words"
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "basicCell", for: indexPath)
        
        if let images = self.imagesGroupsArray![indexPath.section].images?.allObjects {
        let image = images[indexPath.row] as! Images
        cell.textLabel?.text = image.name
        }
        return cell
    }

    
    // MARK: User Interaction

    func actionRefresh() {
        getDataToShow()
        self.refreshControl?.endRefreshing()
    }

}

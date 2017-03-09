//
//  MainTVC.swift
//  WikiGeoPhotoNamesComparator
//
//  Created by Андрей Рожков on 08.03.17.
//  Copyright © 2017 AndreyRozhkov. All rights reserved.
//

import UIKit

class GroupsTVC: UITableViewController {
    
    
    var activityView:UIActivityIndicatorView?
    var dataSourse:GroupsTableDataSource?
    

    // MARK: View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        activityView = UIActivityIndicatorView.bindActivityIndicatorTo(viewController: (self.navigationController)!)
        tableView.dataSource = GroupsTableDataSource(tableView: tableView, activityView: activityView)
        self.title = "Separate words counter"
        self.refreshControl?.addTarget(self, action: #selector(actionRefresh), for: UIControlEvents.valueChanged)
    }

    override func viewWillAppear(_ animated: Bool) {
        dataSourse?.reloadData()
    }

    
    // MARK: User Interaction

    func actionRefresh() {
        dataSourse?.reloadData()
        self.refreshControl?.endRefreshing()
    }

}

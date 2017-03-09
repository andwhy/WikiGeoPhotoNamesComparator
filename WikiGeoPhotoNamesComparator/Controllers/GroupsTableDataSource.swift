//
//  TableDataSourse.swift
//  WikiGeoPhotoNamesComparator
//
//  Created by Андрей Рожков on 09.03.17.
//  Copyright © 2017 AndreyRozhkov. All rights reserved.
//

import UIKit

class GroupsTableDataSource: NSObject, UITableViewDataSource {
    
    var table:UITableView
    var activity:UIActivityIndicatorView?
    
    var imagesGroupsArray:[Groups]? = [] {
        didSet {
            DispatchQueue.main.sync {
                self.activity!.stopAnimating()
                self.table.reloadData()
            }
        }
    }
    
    // MARK: Lifecycle
    
    required init(tableView:UITableView, activityView:UIActivityIndicatorView?) {
        table = tableView
        activity = activityView
        super.init()
        self.reloadData()
    }
    
    func reloadData() {
        activity?.startAnimating()
        DataManager().getImagesGroups{ result in
            self.imagesGroupsArray = result
        }
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return (imagesGroupsArray?.count)!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Array(imagesGroupsArray![section].images!).count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "\(imagesGroupsArray![section].word_counter) words"
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "basicCell", for: indexPath)
        
        if let images = self.imagesGroupsArray![indexPath.section].images?.allObjects {
            let image = images[indexPath.row] as! Images
            cell.textLabel?.text = image.name
        }
        return cell
    }
    
}

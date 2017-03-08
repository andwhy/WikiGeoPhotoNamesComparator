//
//  DataManager.swift
//  WikiGeoPhotoNamesComparator
//
//  Created by Андрей Рожков on 07.03.17.
//  Copyright © 2017 AndreyRozhkov. All rights reserved.
//

import UIKit
import CoreData

class DataManager {
    
    let locationManager = LocationManager()
    
    var container: NSPersistentContainer? =
        (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
   
    
    //MARK: Data receiving

    func getImagesGroups(completionHandler: @escaping ([Groups]?) -> Void) {
        self.updateDatabase {
            let fetchrequst = NSFetchRequest<NSFetchRequestResult>(entityName: "Groups")
            let sortDescriptor = NSSortDescriptor(key: "word_counter", ascending: false)
            fetchrequst.sortDescriptors = [sortDescriptor]
            do {
                let fetchedGroups = try self.container?.viewContext.fetch(fetchrequst) as! [Groups]
                completionHandler(fetchedGroups)
            } catch {
                completionHandler(nil)
            }
        }
        
    }
    
    //MARK: Data updating

    private func updateDatabase(completionHandler: @escaping () -> Void) {
        
        locationManager.getUserLocation { location in
            guard let location = location else { completionHandler(); return }
            
            NetworkManager().downloadImagesDataWith(location) { rawResult in
                guard let result = rawResult else { completionHandler(); return }
                
                DataManager().mapImagesData(data: result) { result in
                    guard let result = result else { completionHandler(); return }
                    
                    self.container?.performBackgroundTask { context in
                        CoreDataManager().saveImagesFromStrings(array: result, in: context) {
                            completionHandler()
                        }
                    }
                }
            }
        }
    }
    
    private func mapImagesData(data: [String : Any], completionHandler: @escaping ([String]?) -> Void) {
        
        func getPagesDict(withFullJson jsonDict: [String : Any]) -> [String : Any]? {
            if let dataQuery = data["query"] as? [String : Any], let dataPages = dataQuery["pages"] as? [String : Any], dataPages.keys.count != 0 {
                return dataPages
            } else {
                return nil
            }
        }

        DispatchQueue.global(qos: .background).async {

            guard let pagesDict = getPagesDict(withFullJson: data) else { completionHandler(nil); return }
            
            var resultArray:[String] = []
            
            for (_, page) in pagesDict {
                
                let page = page as! [String : Any]
                guard let images = page["images"] as? [[String : Any]] else
                { continue }
                
                for (image) in images {
                    
                    guard let imageTitle = image["title"] as? String else { continue }
                    resultArray.append(imageTitle.cutFileWordFromBeginning())
                }
            }
            completionHandler(resultArray)
        }
        
    }
    

    
}


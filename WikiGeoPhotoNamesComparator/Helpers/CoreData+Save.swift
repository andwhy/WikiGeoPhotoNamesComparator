//
//  CoreDataExtension.swift
//  WikiGeoPhotoNamesComparator
//
//  Created by Андрей Рожков on 07.03.17.
//  Copyright © 2017 AndreyRozhkov. All rights reserved.
//

import Foundation
import CoreData

extension NSManagedObjectContext
{
    public func saveThrows () {
        if self.hasChanges {
            do {
                try save()
            } catch let error  {
                let nserror = error as NSError
                print("Core Data Error:  \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    
}

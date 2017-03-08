//
//  CoreDataManager.swift
//  WikiGeoPhotoNamesComparator
//
//  Created by Андрей Рожков on 08.03.17.
//  Copyright © 2017 AndreyRozhkov. All rights reserved.
//

import UIKit
import CoreData

class CoreDataManager {

    var container: NSPersistentContainer? =
        (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer

    
    //MARK: Data creating
    
    func saveImagesFromStrings(array: [String], in context: NSManagedObjectContext, completionHandler: @escaping () -> Void) {

        CoreDataManager().cleanCoreDataDatabaseWith(context: context)
    
        for imageTitle in array {
            let entity = NSEntityDescription.entity(forEntityName: "Images", in: context)!
            let image = NSManagedObject(entity: entity, insertInto: context) as! Images
            image.name = imageTitle
            image.groups = CoreDataManager().getGroupBy(wordsNumber: imageTitle.countInstances(of: " "), withContext: context)
        }
    
        context.saveThrows()
        completionHandler()
    
    }
    
    
    //MARK: Groups managing
    
    private func getGroupBy(wordsNumber : Int, withContext context: NSManagedObjectContext) -> Groups {
        
        let entityDescription = NSEntityDescription.entity(forEntityName: "Groups", in: context)
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        fetchRequest.entity = entityDescription
        
        let predicate = NSPredicate(format: "(word_counter == %i)", wordsNumber)
        fetchRequest.predicate = predicate
        
        do {
            let result = try context.fetch(fetchRequest)
            
            if result.count == 0 {
                return createGroupBy(wordsNumber: wordsNumber, withContext: context)
            } else {
                return result.first as! Groups
            }
        } catch {
            let fetchError = error as NSError
            print(fetchError)
        }
        
        return createGroupBy(wordsNumber: wordsNumber, withContext: context)
    }
    
    
    private func createGroupBy(wordsNumber : Int, withContext context: NSManagedObjectContext) -> Groups {
        
        let entityDescription = NSEntityDescription.entity(forEntityName: "Groups", in: context)
        let group = Groups(entity: entityDescription!,
                           insertInto: context)
        
        group.word_counter = Int64(wordsNumber)
        
        return group
    }
    
    
    //MARK: Cleaning

    private func cleanCoreDataDatabaseWith(context: NSManagedObjectContext) {
        
        let entityNamesArray = ["Images", "Groups"]
        
        func executeDeleteRecuestWith(entityName: String) {
            
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            
            do {
                try context.execute(deleteRequest)
            } catch let error as NSError {
                print(error)
            }
        }
        
        for name in entityNamesArray {
            executeDeleteRecuestWith(entityName: name)
        }
    }
}

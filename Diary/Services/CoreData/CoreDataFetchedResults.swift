//
//  CoreDataFetchedResults.swift
//  Diary
//
//  Created by Andrew, brody on 2023/05/02.
//

import UIKit
import CoreData

final class CoreDataFetchedResults<T: NSManagedObject> {
    
    public var fetchedResultsController: NSFetchedResultsController<T>
    
    public init(
        ofType: T.Type,
        entityName: String,
        sortDescriptors: [NSSortDescriptor],
        managedContext: NSManagedObjectContext,
        delegate: UIViewController?
    ) {
        let fetchRequest = NSFetchRequest<T>(entityName: entityName)
        fetchRequest.sortDescriptors = sortDescriptors
        
        fetchedResultsController = NSFetchedResultsController (
            fetchRequest: fetchRequest,
            managedObjectContext: managedContext,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        
        fetchedResultsController.delegate = delegate as? NSFetchedResultsControllerDelegate
    }
}

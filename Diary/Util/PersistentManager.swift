//
//  PersistentManager.swift
//  Diary
//
//  Created by Minseong, Lingo on 2022/06/22.
//

import Foundation
import CoreData

final class PersistentManager {
  static let shared = PersistentManager()

  private lazy var persistentContainer: NSPersistentContainer = {
    let container = NSPersistentContainer(name: "Diary")
    container.loadPersistentStores(completionHandler: { (_, error) in
      if let error = error as NSError? {
        fatalError("Unresolved error \(error), \(error.userInfo)")
      }
    })
    return container
  }()

  private var context: NSManagedObjectContext {
    return persistentContainer.viewContext
  }

  private init() {}

  func saveContext () {
    if context.hasChanges {
      do {
        try context.save()
      } catch {
        let nserror = error as NSError
        fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
      }
    }
  }
}

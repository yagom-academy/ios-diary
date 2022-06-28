//
//  PersistentStore.swift
//  Diary
//
//  Created by Minseong, Lingo on 2022/06/28.
//

import Foundation
import CoreData

final class PersistentStore {
  private let fileName: String

  init(fileName: String) {
    self.fileName = fileName
  }

  private lazy var container: NSPersistentContainer = {
    let container = NSPersistentContainer(name: fileName)
    container.loadPersistentStores { _, error in
      if let error = error {
        print("Can't load PersistentStore \(error)")
      }
    }
    return container
  }()

  var context: NSManagedObjectContext {
    return container.viewContext
  }

  func saveContext() {
    if context.hasChanges {
      do {
        try context.save()
      } catch {
        print("Can't save context \(error)")
      }
    }
  }
}

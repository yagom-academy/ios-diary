//
//  PersistentContainerManager.swift
//  Diary
//
//  Created by Mangdi on 2022/12/27.
//

import CoreData

struct PersistentContainerManager {
    var context: NSManagedObjectContext {
        return PersistentContainer.shared.viewContext
    }

    var diaryEntity: NSEntityDescription? {
        return NSEntityDescription.entity(forEntityName: "Diary", in: context)
    }
}

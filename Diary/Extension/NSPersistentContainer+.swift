//
//  NSPersistentContainer+.swift
//  Diary
//
//  Created by 이정민 on 2022/12/28.
//

import CoreData
import Foundation

extension NSPersistentContainer {
    func saveContext() {
        let context = self.viewContext
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

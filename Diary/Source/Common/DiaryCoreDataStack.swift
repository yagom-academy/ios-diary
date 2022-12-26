//  Diary - DiaryCoreDataStack.swift
//  Created by Ayaan, zhilly on 2022/12/26

import CoreData

class DiaryCoreDataStack {
    static let shared = DiaryCoreDataStack()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Diary")
        
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        
        return container
    }()
}

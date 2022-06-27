//
//  ContainerManager.swift
//  Diary
//
//  Created by 우롱차, RED on 2022/06/16.
//

import CoreData

protocol ContainerManagerable {
    static var shared: Self { get }
    var persistentContainer: NSPersistentContainer { get }
    func saveContext() throws
}

extension ContainerManagerable {
    func saveContext() throws {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            try context.save()
        }
    }
}

final class DiaryContainerManager: ContainerManagerable {
    
    static let shared =  DiaryContainerManager()
    
    private init() {}
    
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

//
//  CoreDataManager.swift
//  Diary
//
//  Created by bonf, bard on 2022/08/23.
//

import UIKit
import CoreData

class CoreDataManager {
    private let persistentContainer: NSPersistentContainer = {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate
        else { return NSPersistentContainer() }
        let container = appDelegate.persistentContainer
        
        return container
    }()
    
    lazy var context = persistentContainer.viewContext
    
    init() {
        NotificationCenter.default.post(name: .didReceiveData,
                                                    object: self)
    }

    func create(myDiary: Diary) {
        let entity = NSEntityDescription.entity(forEntityName: "DiaryEntity", in: context)

        if let entity = entity {
            let diary = NSManagedObject(entity: entity, insertInto: context)
            diary.setValue(myDiary.body, forKey: "body")
            diary.setValue(myDiary.title, forKey: "title")
            diary.setValue(myDiary.createdAt, forKey: "createdAt")
        }
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
    }

    func fetch() -> [Diary] {
        var myDairyList: [Diary] = []
        do {
            let request = DiaryEntity.fetchRequest()
            let dairyList = try context.fetch(request)
            
            for diary in dairyList {
                guard let title = diary.title,
                      let body = diary.body else { return [] }
                let diary = Diary(title: title, body: body, createdAt: diary.createdAt)
                myDairyList.append(diary)
            }
        } catch {
            print(error.localizedDescription)
        }
        return myDairyList
    }
}


//
//  DiaryCoreDataManager.swift
//  Diary
//
//  Created by bonf, bard on 2022/08/23.
//

import UIKit

final class DiaryCoreDataManager: DiaryManagable {
    // MARK: - properties
    
    var diaryList: [Diary] = []
    private var persistentContainerManager = PersistentContainerManager.shared
    
    
    // MARK: - initializers
    
    init() {
        NotificationCenter.default.post(name: .didReceiveData,
                                                    object: self)
        fetch()
    }

    // MARK: - functions
    
    func fetch() {
        let fetchedRequest = DiaryEntity.fetchRequest()
        diaryList.removeAll()
        
        let sort = NSSortDescriptor(key: "createdAt", ascending: false)
        fetchedRequest.sortDescriptors = [sort]
        let diarys = persistentContainerManager.fetch(request: fetchedRequest)
        
        diarys.forEach { diary in
            guard let uuid = diary.uuid,
                  let title = diary.title,
                  let body = diary.body
            else { return }
            
            
            let newDiary = Diary(uuid: uuid,
                                 title: title,
                                 body: body,
                                 createdAt: diary.createdAt)
            
            diaryList.append(newDiary)
        }
    }
    
    func create(_ diary: Diary) {
        let values: [String: Any] = ["title": diary.title,
                                     "body": diary.body,
                                     "createdAt": diary.createdAt,
                                     "uuid": diary.uuid]
        
        persistentContainerManager.create(entityName: String(describing: DiaryEntity.self),
                                          values: values)
        self.fetch()
        
    }
    
    func update(_ diary: Diary) {
        let fetchedRequest = DiaryEntity.fetchRequest()
        let uuidString = diary.uuid.uuidString
        
        fetchedRequest.predicate = NSPredicate(format: "uuid = %@", uuidString)
        
        let diarys = persistentContainerManager.fetch(request: fetchedRequest,
                                                      predicate: fetchedRequest.predicate)
        
        guard let newDiary = diarys.first else { return }
        
        let values: [String: Any] = ["title": diary.title,
                                     "body": diary.body,
                                     "createdAt": diary.createdAt]
        
        persistentContainerManager.update(object: newDiary, values: values)
        fetch()
    }
    
    func delete(_ diary: Diary) {
        let fetchedRequest = DiaryEntity.fetchRequest()
        let uuid = diary.uuid.uuidString
        
        fetchedRequest.predicate = NSPredicate(format: "uuid = %@", uuid)
        
        let diarys = persistentContainerManager.fetch(request: fetchedRequest,
                                                      predicate: fetchedRequest.predicate)
        
        guard let newDiary = diarys.first else { return }
        
        persistentContainerManager.delete(object: newDiary)
        fetch()
    }
}


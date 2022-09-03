//
//  DiaryCoreDataManager.swift
//  Diary
//
//  Created by bonf, bard on 2022/08/23.
//

import UIKit

final class DiaryCoreDataManager: DiaryManagable {
    // MARK: - properties
    
    private(set) var diaryList: [Diary] = [] {
        didSet {
            NotificationCenter.default.post(name: .didReceiveData,
                                                        object: self)
        }
    }
    
    private let persistentContainerManager: PersistentContainerManager
    
    // MARK: - initializers
    
    init(with persistentContainerManager: PersistentContainerManager) {
        self.persistentContainerManager = persistentContainerManager
    }

    // MARK: - functions
    
    func fetch() {
        let fetchedRequest = DiaryEntity.fetchRequest()
        diaryList.removeAll()
        
        let sort = NSSortDescriptor(key: "createdAt", ascending: false)
        fetchedRequest.sortDescriptors = [sort]
        let diarys = persistentContainerManager.fetch(request: fetchedRequest)
        
        diaryList = diarys.map { diary in
            guard let uuid = diary.uuid,
                  let title = diary.title,
                  let body = diary.body
            else {
                return Diary(uuid: UUID(),
                             title: "",
                             body: "",
                             createdAt: 0.0,
                             icon: "")
            }
            return Diary(uuid: uuid,
                         title: title,
                         body: body,
                         createdAt: diary.createdAt,
                         icon: diary.icon)
        }
    }
    
    func create(_ diary: Diary) {
        let values: [String: Any] = ["title": diary.title,
                                     "body": diary.body,
                                     "createdAt": diary.createdAt,
                                     "uuid": diary.uuid,
                                     "icon": diary.icon as Any]
        
        persistentContainerManager.create(entityName: String(describing: DiaryEntity.self),
                                          values: values)        
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
    }
    
    func delete(_ diary: Diary) {
        let fetchedRequest = DiaryEntity.fetchRequest()
        let uuid = diary.uuid.uuidString
        
        fetchedRequest.predicate = NSPredicate(format: "uuid = %@", uuid)
        
        let diarys = persistentContainerManager.fetch(request: fetchedRequest,
                                                      predicate: fetchedRequest.predicate)
        
        guard let newDiary = diarys.first else { return }
        
        diaryList = diaryList.filter {
            diary != $0
        }
        
        persistentContainerManager.delete(object: newDiary)
    }
}


//
//  CoreDataManager.swift
//  Diary
//
//  Created by unchain, 웡빙 on 2022/08/22.
//
import UIKit
import CoreData

class CoreDataManager {
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    private lazy var context = appDelegate.persistentContainer.viewContext
    static let shared = CoreDataManager()
    private init() {}
    
    func createItem(with model: DiaryModel) {
        let newItem = Diary(context: context)
        newItem.setValue(model.title, forKey: "title")
        newItem.setValue(model.body, forKey: "body")
        newItem.setValue(model.createdAt, forKey: "createdAt")
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func getAllItems() -> [Diary] {
        var diarys: [Diary] = []
        do {
            diarys = try context.fetch(Diary.fetchRequest())
        } catch {
            print(error)
        }
        return diarys
    }
    
    func delete(item: Diary) {
        context.delete(item)
        do {
            try context.save()
        } catch {
            print(error)
        }
    }
}

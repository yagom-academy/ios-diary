//
//  CoreDataManager.swift
//  Diary
//
//  Created by unchain, 웡빙 on 2022/08/22.
//
import UIKit
import CoreData

final class CoreDataManager {
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    private lazy var context = appDelegate.persistentContainer.viewContext
    static let shared = CoreDataManager()
    private init() {}
    
    func saveDiary(with model: DiaryModel) {
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
    
    func fetchDiaries() -> [Diary] {
        var diaries: [Diary] = []
        do {
            diaries = try context.fetch(Diary.fetchRequest())
        } catch {
            print(error)
        }
        return diaries
    }
    
    func delete(diary: Diary) {
        context.delete(diary)
        do {
            try context.save()
        } catch {
            print(error)
        }
    }
    
    func update(diary: DiaryModel, with indexPath: Int) {
        let fetchData = fetchDiaries()
        
        guard fetchData[indexPath].title != diary.title || fetchData[indexPath].body != diary.body || fetchData[indexPath].createdAt != diary.createdAt else { return }
        
        fetchData[indexPath].title = diary.title
        fetchData[indexPath].body = diary.body
        fetchData[indexPath].createdAt = diary.createdAt
        
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
    }
}

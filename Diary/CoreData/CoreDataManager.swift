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
    var fetchedDiaries: [Diary] = [] {
        didSet {
            if fetchedDiaries != oldValue {
                NotificationCenter.default.post(name: .changeDiaries, object: nil)
            }
        }
    }
    static let shared = CoreDataManager()
    private init() {
        fetchDiaries()
    }
    
    func saveDiary(with model: DiaryModel) {
        let newItem = Diary(context: context)
        newItem.setValue(model.title, forKey: "title")
        newItem.setValue(model.body, forKey: "body")
        newItem.setValue(model.createdAt, forKey: "createdAt")
        do {
            try context.save()
            fetchDiaries()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func delete(diary: Diary) {
        context.delete(diary)
        do {
            try context.save()
            fetchDiaries()
        } catch {
            print(error)
        }
    }
    
    func update(diary: DiaryModel, with indexPath: Int) {
        guard fetchedDiaries[indexPath].title != diary.title || fetchedDiaries[indexPath].body != diary.body || fetchedDiaries[indexPath].createdAt != diary.createdAt else { return }
        
        fetchedDiaries[indexPath].title = diary.title
        fetchedDiaries[indexPath].body = diary.body
        fetchedDiaries[indexPath].createdAt = diary.createdAt
        
        do {
            try context.save()
            fetchDiaries()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func fetchDiaries() {
        do {
            fetchedDiaries = try context.fetch(Diary.fetchRequest())
        } catch {
            print(error)
        }
    }
}

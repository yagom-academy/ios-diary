//
//  CoreDataManager.swift
//  Diary
//
//  Created by Toy, Morgan on 1/9/24.
//

import UIKit
import CoreData

final class CoreDataManager {
    static let shared = CoreDataManager()
    
    private init() {}
    
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    private func saveContextData() {
        do {
            try context.save()
        } catch {
            print(error)
        }
    }
    
    func createDiaryData(title: String? = nil, body: String? = nil) {
        let diary = DiaryData(context: context)
        diary.title = title
        diary.date = Date.generateTodayDate()
        diary.body = body
        
        saveContextData()
    }
    
    func readDiaryData() -> [DiaryData] {
        var diaryData: [DiaryData] = []
        let request = DiaryData.fetchRequest()
        
        do {
            diaryData = try context.fetch(request)
        } catch {
            print(error)
        }
        return diaryData
    }
    
    func updateDiaryData(diary: DiaryData?, title: String, body: String) {
        diary?.title = title
        diary?.body = body
        
        saveContextData()
    }
    
    func deleteDiaryData(diary: DiaryData) {
        context.delete(diary)
        
        saveContextData()
    }
}

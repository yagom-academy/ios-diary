//
//  CoreDataManager.swift
//  Diary
//
//  Created by Toy, Morgan on 1/9/24.
//

import UIKit
import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    
    private init() {}
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func createDiaryData(title: String, date: String, body: String) {
        let diary = DiaryData(context: context)
        diary.title = title
        diary.date = date
        diary.body = body
        
        do {
            try context.save()
        } catch {
            print(error)
        }
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
    
    func updateDiaryData(diary: DiaryData, title: String, body: String) {
        diary.title = title
        diary.body = body
        
        do {
           try context.save()
        } catch {
            print(error)
        }
    }
    
}

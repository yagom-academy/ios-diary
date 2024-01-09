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
    
    let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    
    func createDiaryData(title: String, date: String, body: String) {
        let diary = DiaryData(context: context!)
        diary.title = title
        diary.date = date
        diary.body = body
        
        do {
            try context?.save()
        } catch {
            print("error")
        }
    }
    
    func readDiaryData() -> [DiaryData] {
        var diaryData: [DiaryData] = []
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "DiaryData")
        
        do {
            if let data = try context?.fetch(request) as? [DiaryData] {
                diaryData = data
            }
        } catch {
            print("error")
        }
        return diaryData
    }
}

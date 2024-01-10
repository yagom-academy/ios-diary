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
    
    func createDiaryData(title: String = "", body: String = "") {
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
        // 이배열에서 마지막 객체에 접근하면 새로만든 객체가 된다
        // add 마지막에 생성된 객체를 프로퍼티에 끼워줌
        // cell indexPath에 맞는 객체를 끼워줌
    }
    
    func updateDiaryData(diary: DiaryData, title: String, body: String) {
        diary.title = title
        diary.body = body
        
        saveContextData()
    }
    
    func deleteDiaryData(diary: DiaryData) {
        context.delete(diary)
        
        saveContextData()
    }
}

//
//  CoreDataManager.swift
//  Diary
//
//  Created by hyunMac on 1/9/24.
//

import UIKit
import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    
    private init() {}
    
    let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    
    func createDiary(title: String, date: String, body: String) {
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
}

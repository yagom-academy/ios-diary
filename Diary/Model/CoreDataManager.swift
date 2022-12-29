//
//  CoreDataManager.swift
//  Diary
//
//  Created by 서현웅 on 2022/12/29.
//

import CoreData
import UIKit

struct CoreDataManager {
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    lazy private var context = appDelegate?.persistentContainer.viewContext
    
    mutating func fetch() -> [DiaryData] {
        var diaryData = [DiaryData]()
        
        if let context = context {
            let request = DiaryData.fetchRequest()
            
            do {
                diaryData = try context.fetch(request)
            } catch {
                print(error)
            }
        }
        return diaryData
    }
}

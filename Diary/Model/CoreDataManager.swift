//
//  CoreDataManager.swift
//  Diary
//
//  Copyright (c) 2022 woong, jeremy All rights reserved.

import CoreData
import UIKit

struct CoreDataManager {
    private let appDelegate = UIApplication.shared.delegate as? AppDelegate
    private lazy var context = appDelegate?.persistentContainer.viewContext
    
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
    
    mutating func create() {
        if let context = context {
            let newDiary = DiaryData(context: context)
            newDiary.title = nil
            newDiary.body = nil
            newDiary.createdAt = Date()
            newDiary.uuid = UUID()
            update()
        }
    }
    
    mutating func update() {
        if let context = context {
            do {
                try context.save()
            } catch {
                print(error)
            }
        }
    }
    
    mutating func delete(data: DiaryData) {
        if let context = context {
            context.delete(data)
            update()
        }
    }
}

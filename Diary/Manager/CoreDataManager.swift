//
//  CoreDataManager.swift
//  Diary
//
//  Created by 예찬 on 2023/09/04.
//

import UIKit
import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    
    let context = (UIApplication.shared.delegate as? AppDelegate)!.persistentContainer.viewContext
    
    private init() {}
}

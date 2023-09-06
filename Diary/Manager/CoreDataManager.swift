//
//  CoreDataManager.swift
//  Diary
//
//  Created by idinaloq, yetti on 2023/09/04.
//

import UIKit
import CoreData

final class CoreDataManager {
    static let shared: CoreDataManager = CoreDataManager()
    
    private init() {}
    
    let context = (UIApplication.shared.delegate as? AppDelegate)!.persistentContainer.viewContext
    
    
}

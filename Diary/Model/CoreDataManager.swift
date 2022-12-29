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
    
}

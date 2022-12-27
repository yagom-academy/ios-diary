//
//  CoreDataManager.swift
//  Diary
//
//  Created by leewonseok on 2022/12/27.
//

import UIKit
import CoreData

class CoreDataManager {
    
    static var shared = CoreDataManager()
    
    private init() { }
    
    let appdelegate = UIApplication.shared.delegate as? AppDelegate

    lazy var context = appdelegate?.persistentContainer.viewContext
    
    let entityName = "Diary"
    
    
    func createDiary() {
        
    }
    
    func readDiary() {
        
    }
    
    func updateDiary() {
        
    }
    
    func deleteDiary() {
        
    }
    
}

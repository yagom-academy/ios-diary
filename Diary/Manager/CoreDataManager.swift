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
    let fetchRequest: NSFetchRequest<Diary> = Diary.fetchRequest()
    
    func receivePredicateData(uuid: String) -> NSFetchRequest<Diary> {
        fetchRequest.predicate = NSPredicate(format: "identifier == %@", uuid)
        
        return fetchRequest
    }
    
    func receiveFetchData(fetchRequest: NSFetchRequest<Diary>) {
        do {
            let data = try CoreDataManager.shared.context.fetch(fetchRequest)
        } catch {
            print(error.localizedDescription)
        }
    }
}

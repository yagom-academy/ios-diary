//
//  DiaryService.swift
//  Diary
//
//  Created by Andrew, brody on 2023/05/01.
//

import Foundation
import CoreData

public final class DiaryService {
    let coreDataStack: CoreDataStack
    let managedContext = CoreDataStack.shared.managedContext
    let entityName = "Diary"
    
    public init(coreDataStack: CoreDataStack) {
        self.coreDataStack = coreDataStack
    }
}

extension DiaryService {
    @discardableResult
    public func add(title: String, body: String) -> Result<Bool ,CoreDataError> {
        let newDiary = NSEntityDescription.insertNewObject(forEntityName: entityName, into: managedContext)
        newDiary.setValue(title, forKey: "title")
        newDiary.setValue(body, forKey: "body")
        newDiary.setValue(UUID(), forKey: "id")
        newDiary.setValue(Date(), forKey: "createdAt")
        
        let result = CoreDataStack.shared.saveContext()
        return result == true ? .success(true) : .failure(CoreDataError.insertError)
    }
    
    public func getReports() -> [PandemicReport]? {
        let reportFetch: NSFetchRequest<PandemicReport> = PandemicReport.fetchRequest()
        do {
            let results = try managedObjectContext.fetch(reportFetch)
            return results
        } catch let error as NSError {
            print("Fetch error: \(error) description: \(error.userInfo)")
        }
        return nil
    }
    
    @discardableResult
    public func update(_ report: PandemicReport) -> PandemicReport {
        coreDataStack.saveContext(managedObjectContext)
        return report
    }
    
    public func delete(_ report: PandemicReport) {
        managedObjectContext.delete(report)
        coreDataStack.saveContext(managedObjectContext)
    }
}

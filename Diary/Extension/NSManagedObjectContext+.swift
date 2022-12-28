//
//  NSManagedObjectContext+.swift
//  Diary
//
//  Created by JPush, Wonbi on 2022/12/28.
//

import CoreData
import os.log

extension NSManagedObjectContext {
    private var logger: Logger {
        return Logger()
    }
    
    func fetch<T: NSManagedObject>(request: NSFetchRequest<T>) -> [T]? {
        do {
            let fetchResult = try self.fetch(request)
            return fetchResult
        } catch {
            logger.error("\(error.localizedDescription)")
            return nil
        }
    }
    
    @discardableResult
    func insertDiary(_ diary: Diary) -> Bool {
        guard let entity = NSEntityDescription.entity(forEntityName: "Diary", in: self) else {
            return false
        }
        
        let managedObject = NSManagedObject(entity: entity, insertInto: self)
        
        managedObject.setValue(diary.title, forKey: "title")
        managedObject.setValue(diary.body, forKey: "body")
        managedObject.setValue(diary.createdAt, forKey: "createdAt")
        
        do {
            try self.save()
            return true
        } catch {
            logger.error("\(error.localizedDescription)")
            return false
        }
    }
    
    @discardableResult
    func updateDiary(_ diary: Diary) -> Bool {
        let managedObject = self.object(with: diary.objectID)
        
        managedObject.setValue(diary.title, forKey: "title")
        managedObject.setValue(diary.body, forKey: "body")
        managedObject.setValue(diary.createdAt, forKey: "createdAt")
        
        do {
            try self.save()
            return true
        } catch {
            logger.error("\(error.localizedDescription)")
            return false
        }
    }
    
    @discardableResult
    func delete(objectID: NSManagedObjectID) -> Bool {
        let targetObject = self.object(with: objectID)
        
        self.delete(targetObject)
        do {
            try self.save()
            return true
        } catch {
            return false
        }
    }
}

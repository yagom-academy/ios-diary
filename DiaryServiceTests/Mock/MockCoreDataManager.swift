//
//  MockCoreDataManager.swift
//  DiaryServiceTests
//
//  Created by Andrew, brody on 2023/05/08.
//

import Foundation
import CoreData
@testable import Diary

// diaryService만을 테스트하려함
// 1. 기존코드와 테스트코드를 범용적으로 사용하기위해 프로토콜 생성
// 2. 이 프로토콜이 가져야 할 프로퍼티 메서드는 공통적으로 사용되는 부분만.
// 근데 만약 private한 프로퍼티라면 Mock에서도 private

final class MockCoreDataManager: CoreDataManagable {
    
    static let shared = MockCoreDataManager(modelName: "Diary")
    private let modelName: String
    
    private lazy var storeContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: modelName)
        container.loadPersistentStores { _, error in
            if let error = error {
                print(error.localizedDescription)
            }
        }

        return container
    }()
    
    lazy var managedContext: NSManagedObjectContext = {
        return self.storeContainer.viewContext
    }()
    
    private init(modelName: String) {
        self.modelName = modelName
        
        let persistentStoreDescription = NSPersistentStoreDescription()
        persistentStoreDescription.type = NSInMemoryStoreType
        
        storeContainer.persistentStoreDescriptions = [persistentStoreDescription]
    }
}

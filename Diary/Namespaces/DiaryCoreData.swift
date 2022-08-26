//
//  DiaryCoreData.swift
//  Diary
//
//  Created by Finnn, 수꿍 on 2022/08/24.
//

enum DiaryCoreData {
    static let entityName = "Diary"
    static let emptyBody = ""

    enum Key {
        static let title = "title"
        static let body = "body"
        static let createdAt = "createdAt"
        static let id = "id"
    }
    
    enum Predicate {
        static let creationDate = "createdAt = %@"
        static let id = "id = %@"
        static let contatingTitle = "title CONTAINS[c] %@"
        static let containingBody = "body CONTAINS[c] %@"
    }
}

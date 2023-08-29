//
//  Diary.swift
//  Diary
//
//  Created by Dasan, kyungmin on 2023/08/28.
//

struct Diary: Decodable, Hashable {
    let title: String
    let body: String
    let createdDate: Int
    
    private enum CodingKeys: String, CodingKey {
        case title
        case body
        case createdDate = "created_at"
    }
}

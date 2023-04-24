//
//  Contents.swift
//  Diary
//
//  Created by KokkilE, Hyemory on 2023/04/24.
//

struct Contents {
    let title: String
    let body: String
    let date: Int
    
    private enum CodingKeys: String, CodingKey {
        case date = "created_at"
    }
}

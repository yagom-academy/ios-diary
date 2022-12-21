//
//  SampleData.swift
//  Diary
//
//  Copyright (c) 2022 woong, jeremy All rights reserved.
    

import Foundation

struct SampleData: Decodable {
    let title: String
    let body: String
    let createdAt: Int
    
    enum CodingKeys: String, CodingKey {
        case title
        case body
        case createdAt
    }
}

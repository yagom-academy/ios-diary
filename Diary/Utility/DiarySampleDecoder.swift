//
//  DiarySampleDecoder.swift
//  Diary
//
//  Created by Harry on 2023/04/27.
//

import Foundation

struct DiarySampleDecoder {
    private let jsonDecoder = JSONDecoder()
    
    func decode(type: [DiarySample].Type, data: Data) -> Result<[DiarySample], Error> {
        let result = Result { try jsonDecoder.decode(type, from: data) }
        
        return result
    }
}

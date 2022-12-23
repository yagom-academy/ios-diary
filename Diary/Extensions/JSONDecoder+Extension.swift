//
//  JSONDecoder+Extension.swift
//  Diary
//
//  Created by 애종, 애쉬 on 2022/12/20.
//

import Foundation

extension JSONDecoder {
    func decode<T: Decodable>(data: Data) -> Result<T, DiaryError> {
        guard let itemData = try? self.decode(T.self, from: data) else {
            return .failure(.decodeFailed)
        }
        
        return .success(itemData)
    }
}

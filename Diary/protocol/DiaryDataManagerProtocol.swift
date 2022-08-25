//
//  DiaryDataManager.swift
//  Diary
//
//  Created by 변재은 on 2022/08/22.
//

import Foundation

protocol DiaryDataManagerProtocol {
    var diaryItems: [DiaryModel]? { get set }
}

extension DiaryDataManagerProtocol {
    func decode(data: Data) -> [DiaryModel]? {
        guard let decodedData = try? JSONDecoder().decode([DiaryModel].self,
                                                          from: data) else { return nil }

        return decodedData
    }
}

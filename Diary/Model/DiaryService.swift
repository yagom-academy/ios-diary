//
//  DiaryService.swift
//  Diary
//
//  Created by Hugh, Derrick on 2022/08/16.
//

import Foundation

final class DiaryService {
    func convertToDiaryDate(from timeInterval: TimeInterval) -> String {
        return timeInterval.formattedDate
    }
}

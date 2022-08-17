//
//  JsonParser.swift
//  Diary
//
//  Created by unchain, 웡빙 on 2022/08/17.
//

import Foundation
import UIKit

struct JsonParser {
    static func fetchData() -> [DiaryModel]? {
        guard let filePath = NSDataAsset.init(name: "sample") else {
            return nil
        }
        
        let decoder = JSONDecoder()
        var diaryModel: [DiaryModel]?
        do {
            diaryModel = try decoder.decode([DiaryModel].self, from: filePath.data)
        } catch {
            switch error {
            case DecodingError.typeMismatch(let type, let context):
                let descriptionList = context.debugDescription.split(separator: " ")
                print("타입이 \(type) 가 아닙니다. \(descriptionList[descriptionList.count - 2]) 타입을 사용 해주세요.")
            case DecodingError.dataCorrupted(let context):
                print(context.debugDescription)
            case DecodingError.valueNotFound(_, let context):
                print(context.debugDescription)
            case DecodingError.keyNotFound(_, let context):
                print(context.debugDescription)
            default:
                break
            }
        }
        return diaryModel
    }
}

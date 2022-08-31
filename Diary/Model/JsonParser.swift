//
//  JsonParser.swift
//  Diary
//
//  Created by unchain, 웡빙 on 2022/08/17.
//

import UIKit

struct JsonParser {
    static func fetchData() -> [DiaryModel]? {
        guard let filePath = NSDataAsset.init(name: "sample") else {
            return nil
        }
        
        let decoder = JSONDecoder()
        var diaryModels: [DiaryModel]?
        do {
            diaryModels = try decoder.decode([DiaryModel].self, from: filePath.data)
        } catch {
            switch error {
            case DecodingError.typeMismatch(_, let context):
                print(context.debugDescription)
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
        return diaryModels
    }
    
    static func fetch(_ data: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        var weatherModel: WeatherModel?
        do {
            weatherModel = try decoder.decode(WeatherModel.self, from: data)
        } catch {
            print(error.localizedDescription)
        }
        return weatherModel
    }
}

//
//  DiaryData.swift
//  Diary
//
//  Created by 김태현 on 2022/06/14.
//

import Foundation

extension Data {
    func convert<T: Decodable>() -> T? {
        guard let diaryData = T.parse(data: self) else {
            return nil
        }
        
        return diaryData
    }
}

struct WeatherDTO: Decodable {
    let icon: [Icon]
    let description: DescriptionDTO
    
    struct Icon: Decodable {
        let icon: String
    }
    
    struct DescriptionDTO: Decodable {
        let temperature: Double
        let feelsLike: Double
        let minTemperature: Double
        let maxTempaerature: Double
        let pressure: Double
        let humidity: Double
        
        enum CodingKeys: String, CodingKey {
            case temperature = "temp"
            case feelsLike = "feels_like"
            case minTemperature = "temp_min"
            case maxTempaerature = "temp_max"
            case pressure
            case humidity
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case icon = "weather"
        case description = "main"
    }
}

struct DiaryDTO: Decodable, Hashable {
    var identifier = UUID()
    
    var title: String
    var body: String
    let date: Date
    var icon: String? = ""
    
    var dateString: String {
        return Formatter.setUpDate(from: date.timeIntervalSinceReferenceDate)
    }
    
    enum CodingKeys: String, CodingKey {
        case title
        case body
        case date = "created_at"
    }
    
    init(identifier: UUID? = nil, title: String, body: String, date: Date, icon: String? = nil) {
        if let identifier = identifier {
            self.identifier = identifier
        }
        
        self.title = title
        self.body = body
        self.date = date
        self.icon = icon
    }
    
    mutating func editData(_ newData: DiaryDTO) {
        self.title = newData.title
        self.body = newData.body
    }
}

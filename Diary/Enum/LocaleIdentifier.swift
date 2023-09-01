//
//  LocaleIdentifier.swift
//  Diary
//
//  Created by idinaloq, yetti on 2023/08/31.
//

import Foundation

enum LocaleIdentifier: CustomStringConvertible {
    case KOR
    
    var description: String {
        switch self {
        case .KOR:
            return "ko_KR"
        }
    }
}

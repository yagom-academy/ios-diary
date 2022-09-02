//
//  MockData.swift
//  DiaryTests
//
//  Created by Kiwi, Brad. on 2022/09/02.
//

import Foundation

struct MockData {
    let data: Data?

    init(fileName: String) {
        let location = Bundle.main.url(forResource: fileName, withExtension: "json")
        data = try? Data(contentsOf: location!)
    }
}

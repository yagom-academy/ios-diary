//
//  Diary - String+.swift
//  Created by Rhode, 무리.
//  Copyright © yagom. All rights reserved.
//

extension String {
    func removeNewLinePrefix() -> String {
        var text = self
        while text.hasPrefix("\n") {
            text.removeFirst()
        }
        
        return text
    }
}

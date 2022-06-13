//
//  Diary - ViewController.swift
//  Created by safari, Eddy.
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class DiaryListViewController: UITableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

private extension Decodable {
    static func parse(name: String) -> Self? {
        guard let path = Bundle.main.path(forResource: name, ofType: "json") else { return nil }
        guard let jsonString = try? String(contentsOfFile: path) else { return nil }
        guard let data = jsonString.data(using: .utf8) else { return nil }

        return try? JSONDecoder().decode(Self.self, from: data)
    }
}

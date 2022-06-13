//
//  AssetManager.swift
//  Diary
//
//  Created by 김태현 on 2022/06/13.
//

import UIKit

struct AssetManager {
    func convert(fileName: String) -> Data? {
        guard let assetFile = NSDataAsset(name: fileName) else {
            return nil
        }
        return assetFile.data
    }
}

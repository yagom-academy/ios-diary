//
//  DiaryCellViewModel.swift
//  Diary
//
//  Created by mmim, grumpy, mino on 2022/06/28.
//

import Foundation
import UIKit

final class DiaryCellViewModel {
    private(set) var task: URLSessionDataTask?
    private let apiProvider = RequestManager()
    private(set) var image = UIImage()
    
    func prepareForReuse() {
        task?.suspend()
        task?.cancel()
    }
    
    func setUpContents(data: String) {
        requestImage(data: data)
    }
    
    private func requestImage(data: String) {
    }
}

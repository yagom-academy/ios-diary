//
//  IconImageUseCase.swift
//  Diary
//
//  Created by SeoDongyeon on 2022/07/01.
//

import UIKit

struct IconImageUseCase {
    private let network: Network
    private let iconManager: IconManager
    
    init(network: Network, iconManager: IconManager) {
        self.network = network
        self.iconManager = iconManager
    }
    
    func requestWeatherIconImage(
        completionHandler: @escaping (UIImage) -> Void,
        errorHandler: @escaping (Error) -> Void
    ) {
        guard let url = iconManager.currentWeatherIconImageURL else {
            errorHandler(NetworkError.urlError)
            return
        }
        network.requestData(url) { data, response in
            guard let iconData = UIImage(data: data) else {
                errorHandler(NetworkError.dataError)
                return
            }
            completionHandler(iconData)
        } errorHandler: { error in
            errorHandler(error)
        }
    }
}

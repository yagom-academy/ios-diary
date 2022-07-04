//
//  UIImageView+Extension.swift
//  Diary
//
//  Created by 우롱차, RED on 2022/06/28.
//

import UIKit

extension UIImageView {
    func weatherImage(icon: String) {
        guard let url = WeatherApi.image(icon: icon).url else {
            return
        }
        
        Network().requestData(url) { data, _ in
            DispatchQueue.main.async {
                self.image = UIImage(data: data)
            }
        } errorHandler: { _ in
        }
    }
}

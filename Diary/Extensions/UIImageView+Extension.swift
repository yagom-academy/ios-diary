//
//  UIImageView+Extension.swift
//  Diary
//
//  Created by unchain, 웡빙 on 2022/08/31.
//

import UIKit

extension UIImageView {
    func requestWeatherImage(iconId: String) {
        guard let url = URL(string: "http://openweathermap.org/img/wn/\(iconId)@2x.png") else { return }

        let dataTask = URLSession.shared.dataTask(with: url) { data, response, error in
            guard error == nil else { return }
            let successRange = 200..<300
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode,
                  successRange.contains(statusCode) else {
                return
            }
            guard let data = data, let image = UIImage(data: data) else {
                return
            }
            DispatchQueue.main.async {
                self.image = image
            }
        }
        dataTask.resume()
    }
}

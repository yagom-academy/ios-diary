//
//  UIImageView+Extension.swift
//  Diary
//
//  Created by Minseong, Lingo on 2022/06/29.
//

import UIKit

extension UIImageView {
  func setImage(iconID: String) -> Cancellable? {
    let service = NetworkService(session: .shared)
    let endpoint = APIEndpoint.fetchWeatherIcon(iconID: iconID)

    let cancellable = service.request(endpoint: endpoint) { result in
      guard case let .success(data) = result else { return }

      DispatchQueue.main.async {
        self.image = UIImage(data: data)
      }
    }
    return cancellable
  }
}

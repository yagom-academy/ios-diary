//
//  DefaultNetworkProvider.swift
//  Diary
//
//  Created by Andrew, brody on 2023/05/10.
//

import Foundation

final class DefaultNetworkProvider: NetworkProvider {
    let session: URLSession = URLSession.shared
}

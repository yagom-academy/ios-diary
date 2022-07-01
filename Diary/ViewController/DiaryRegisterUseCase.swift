//
//  RegisterDiaryUseCase.swift
//  Diary
//
//  Created by SeoDongyeon on 2022/07/01.
//

import Foundation

struct DiaryRegisterUseCase {
    
    private let network: Networkable
    private let jsonDecoder: JSONDecoder
    private let coordinateManager: CoordinateManager
    
    init(network: Network, jsonDecoder: JSONDecoder, coordinateManager: CoordinateManager) {
        self.network = network
        self.jsonDecoder = jsonDecoder
        self.coordinateManager = coordinateManager
    }
    
    func requestWeatherInformation(
        completionHandler: @escaping (OpenWeatherModel) -> Void,
        errorHandler: @escaping (Error) -> Void
    ) {
        guard let url = coordinateManager.currentCoordinationURL else {
            errorHandler(NetworkError.urlError)
            return
        }
        network.requestData(url) { data, response in
            guard let decodedData = try? jsonDecoder.decode(OpenWeatherModel.self, from: data) else {
                errorHandler(NetworkError.decodingError)
                return
            }
            completionHandler(decodedData)
        } errorHandler: { error in
            errorHandler(error)
        }
    }
}

//
//  NetworkDataFetcher.swift
//  TestTaskAPIKudaGo
//
//  Created by Алексей on 14.05.2023.
//

import Foundation

protocol NetworkProtocol {
    func getEvents(page: Int, comletion: @escaping (Result<EventsList, Error>) -> Void)
}

final class NetworkDataFetcher {
    private let networkService = NetworkService()
    
    func getEvents(page: Int, comletion: @escaping (Result<EventsList, Error>) -> Void) {
        networkService.fetchEvents(page: page) { result in
            switch result {
            case .success(let data):
                do {
                    let images = try JSONDecoder().decode(EventsList.self, from: data)
                    comletion(.success(images))
                } catch let jsonError {
                    print("Error to decode JSON", jsonError.localizedDescription)
                    comletion(.failure(jsonError))
                }
            case .failure(let error):
                print("Error received requesting data: \(error.localizedDescription)")
                comletion(.failure(error))
            }
        }
    }
}

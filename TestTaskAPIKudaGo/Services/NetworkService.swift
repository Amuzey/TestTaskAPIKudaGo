//
//  NetworkService.swift
//  TestTaskAPIKudaGo
//
//  Created by Алексей on 13.05.2023.
//

import Foundation
import UIKit

final class NetworkService {
    func fetchEvents(page: Int, completion: @escaping (Result<Data, Error>) -> Void) {
        let baseURL = "https://kudago.com"
        let endpoint = "/public-api/v1.4/events"
        var components = URLComponents(string: baseURL)!
        components.path = endpoint
        components.queryItems = [
            URLQueryItem(name: "fields", value: "title,dates,description,short_title,images"),
            URLQueryItem(name: "location", value: "ekb"),
            URLQueryItem(name: "page_size", value: "8"),
            URLQueryItem(name: "actual_since", value: "1640970000"),
            URLQueryItem(name: "page", value: "\(page)")
        ]
        guard let url = components.url else { return }
        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                    return
                }
                guard let data = data else { return }
                completion(.success(data))
            }
        }.resume()
    }
}

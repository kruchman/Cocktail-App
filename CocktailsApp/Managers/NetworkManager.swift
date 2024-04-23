//
//  NetworkManager.swift
//  CocktailsApp
//
//  Created by Юрий Кручинин on 3/2/24.
//

import Foundation
import Combine

final class NetworkManager {
    
    static let shared = NetworkManager()
    private init() { }
    
    func download(url: URL) -> AnyPublisher<Data, Error> {
        return URLSession.shared.dataTaskPublisher(for: url)
            .subscribe(on: DispatchQueue.global(qos: .default))
            .tryMap(handleResponse)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
   
    func handleResponse(output: URLSession.DataTaskPublisher.Output) throws -> Data {
        guard let response = output.response as? HTTPURLResponse,
              response.statusCode >= 200 && response.statusCode < 300 else {
            throw URLError(.badServerResponse)
        }
        return output.data
    }
}

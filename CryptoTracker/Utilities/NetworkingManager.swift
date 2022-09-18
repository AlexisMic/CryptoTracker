//
//  NetworkingManager.swift
//  CryptoTracker
//
//  Created by Alexis Schotte on 1/18/22.
//

import Foundation
import Combine

class NetworkingManager {
    
    enum NetworkingError: LocalizedError {
        case badURLResponse(url: URL)
        case unknwon
        
        var errorDescription: String? {
            switch self {
            case .badURLResponse(url: let url): return "[🔥] Bad response from URL: \(url)"
            case .unknwon: return "[⚠️] Unknown error occured."
            
            }
        }
    }
    
    static func networking(url: URL) -> AnyPublisher<Data, Error> {
       return URLSession.shared.dataTaskPublisher(for: url)
//            .subscribe(on: DispatchQueue.global(qos: .default))   -- dataTaskPublisher já é em background thread
            .tryMap({try NetworkingManager.handleURLResponse(output: $0, url: url)})
//            .receive(on: DispatchQueue.main)    -- vamos voltar para main thread apos decoder
            .retry(3)
            .eraseToAnyPublisher()
    
    }
    
    static func handleURLResponse(output: URLSession.DataTaskPublisher.Output, url: URL) throws -> Data {
        guard let response = output.response as? HTTPURLResponse,
              response.statusCode >= 200 && response.statusCode < 300 else {
                  throw NetworkingError.badURLResponse(url: url)
              }
        return output.data
    }
    
    static func handleCompletion(completion: Subscribers.Completion<Error>) {
        switch completion {
        case .finished:
            break
        case .failure(let error):
            print(error.localizedDescription)
        }
    }
    
}

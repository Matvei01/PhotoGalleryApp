//
//  NetworkDataFetcher.swift
//  PhotoGalleryApp
//
//  Created by Matvei Khlestov on 10.06.2024.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case noData
    case decodingError
}

final class NetworkDataFetcher {
    
    static let shared = NetworkDataFetcher()
    
    private init() {}
    
    func fetchData<T: Decodable>(_ type: T.Type, searchTerm: String,
                                 completion: @escaping (Result<T, NetworkError>) -> Void) {
        
        let request = NetworkManager.shared.createRequest(searchTerm: searchTerm)
        
        URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data else {
                completion(.failure(.noData))
                print(error?.localizedDescription ?? "No error description")
                return
            }
            do {
                let decodedObject = try JSONDecoder().decode(T.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(decodedObject))
                }
            } catch {
                completion(.failure(.decodingError))
            }
        }.resume()
    }
}

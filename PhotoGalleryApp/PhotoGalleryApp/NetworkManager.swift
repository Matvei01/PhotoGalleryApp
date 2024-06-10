//
//  NetworkManager.swift
//  PhotoGalleryApp
//
//  Created by Matvei Khlestov on 09.06.2024.
//

import Foundation

final class NetworkManager {
    static let shared = NetworkManager()
    
    private init() {}
    
    func createRequest(searchTerm: String) -> URLRequest {
        let parameters = prepareParameters(searchTerm: searchTerm)
        let url = self.url(parameters: parameters)
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = prepareHeaders()
        request.httpMethod = "GET"
        return request
    }
    
    private func prepareHeaders() -> [String: String]? {
        var headers = [String: String]()
        headers["Authorization"] = "Client-ID 8GZ_zeg2MB8qfQ-FzS5AFe7qjj9W9EAGyub1C0wZYW8"
        return headers
    }
    
    private func prepareParameters(searchTerm: String) -> [String: String] {
        let page: Int = 1
        let perPage: Int = 30
        return [
            "query": searchTerm,
            "page": String(page),
            "per_page": String(perPage)
        ]
    }
    
    private func url(parameters: [String: String]) -> URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.unsplash.com"
        components.path = "/search/photos"
        components.queryItems = parameters.map { URLQueryItem(name: $0, value: $1) }
        
        guard let url = components.url else {
            fatalError("Invalid base URL")
        }
        return url
    }
}

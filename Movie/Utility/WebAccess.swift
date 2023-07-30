//
//  WebAccess.swift
//  Movie
//
//  Created by Elvis on 22/07/2023.
//

import Foundation

class WebAccess {
    enum APIError: Error {
        case NoSuchPath, NoSuchKeys, invalidResponse, invalidData
    }
    
    func getAPIKey() throws -> String {
        guard let path = Bundle.main.path(forResource: "APIKeys", ofType: "plist") else {
            throw APIError.NoSuchPath
        }
        guard let keys = NSDictionary(contentsOfFile: path) else {
            throw APIError.NoSuchKeys
        }
        return keys["TMDB_key"] as? String ?? ""
    }
    
    func fetchMovieFromAPI<T: Decodable>(url: URL, model: T.Type) async throws -> T {
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw APIError.invalidResponse
        }
        
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode(model.self, from: data)
        } catch {
            throw APIError.invalidData
        }
    }
}

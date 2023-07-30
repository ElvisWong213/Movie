//
//  HorizontalScrollViewModel.swift
//  Movie
//
//  Created by Elvis on 30/07/2023.
//

import Foundation

class HorizontalScrollViewModel: ObservableObject {
    private let webAccess = WebAccess()
    
    @Published var movies: [MovieOverview] = []
    var currentPage = 1
    var totalPages = 0
    
    func loadListOfMovies(baseURL: String, page: Int) async {
        do {
            let apiKey = try webAccess.getAPIKey()
            let url = URL(string: "\(baseURL)?api_key=\(apiKey)&page=\(page)")!
            
            let data = try await webAccess.fetchMovieFromAPI(url: url, model: ListOfMovies.self)
            totalPages = data.totalPages
            DispatchQueue.main.async {
                self.movies.append(contentsOf: data.results)
            }
        } catch {
            print(error)
        }
    }
    
    func updateListOfMovies(movie: MovieOverview, baseURL: String) async {
        if movies.last == movie && currentPage <= totalPages {
            currentPage += 1
            await loadListOfMovies(baseURL: baseURL, page: currentPage)
        }
    }
}

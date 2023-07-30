//
//  GridMoviesViewModel.swift
//  Movie
//
//  Created by Elvis on 30/07/2023.
//

import Foundation

class GridMoviesViewModel: ObservableObject {
    private let webAccess = WebAccess()
    
    @Published var movies: [MovieOverview] = []
    var currentPage: Int = 1
    var totalPages: Int = 0
    
    func getBaseURL(selectedCategory: TopMenuCategory) -> String {
        var url = "https://api.themoviedb.org/3/"
        switch selectedCategory {
        case .nowPlaying:
            url += "movie/now_playing"
        case .trending:
            url += "trending/movie/day"
        default:
            url = ""
        }
        return url
    }
    
    func getMoviesList(selectedCategory: TopMenuCategory, page: Int) async {
        do {
            let apiKey = try webAccess.getAPIKey()
            let baseUrl = getBaseURL(selectedCategory: selectedCategory)
            let url = URL(string: "\(baseUrl)?api_key=\(apiKey)&page=\(page)")!
            let respond = try await webAccess.fetchMovieFromAPI(url: url, model: ListOfMovies.self)
            totalPages = respond.totalPages
            DispatchQueue.main.async {
                self.movies.append(contentsOf: respond.results)
            }
        } catch {
            print(error)
        }
    }
    
    func updateMoviesList(selectedCategory: TopMenuCategory, movie: MovieOverview) async {
        if movies.last == movie && currentPage <= totalPages {
            currentPage += 1
            await getMoviesList(selectedCategory: selectedCategory, page: currentPage)
        }
    }
    
    func refreshMovieList(selectedCategory: TopMenuCategory) async {
        currentPage = 1
        DispatchQueue.main.async {
            self.movies.removeAll()
        }
        await getMoviesList(selectedCategory: selectedCategory,page: currentPage)
    }
}

//
//  ReviewsViewModel.swift
//  Movie
//
//  Created by Elvis on 30/07/2023.
//

import Foundation

class ReviewsViewModel: ObservableObject {
    private let webAccess = WebAccess()

    @Published var reviews: [Review] = []
    var reviewTotalPages = 0
    var reviewCurrentPage = 1
    
    func loadReviews(id: Int, page: Int) async {
        do {
            let apiKey = try webAccess.getAPIKey()
            let url = URL(string: "https://api.themoviedb.org/3/movie/\(id)/reviews?api_key=\(apiKey)&page=\(page)")!
            
            let data = try await webAccess.fetchMovieFromAPI(url: url, model: ListOfReview.self)
            reviewTotalPages = data.totalPages
            DispatchQueue.main.async {
                self.reviews.append(contentsOf: data.results)
            }
        } catch {
            print(error)
        }
    }
    
    func updateReviews(review: Review, id: Int) async {
        if reviewCurrentPage <= reviewTotalPages && review == reviews.last {
            reviewCurrentPage += 1
            await loadReviews(id: id, page: reviewCurrentPage)
        }
    }
}

//
//  GridMoviesView.swift
//  Movie
//
//  Created by Elvis on 20/07/2023.
//

import SwiftUI

struct GridMoviesView: View {
    private let webAccess = WebAccess()
    
    @State var movies: [MovieOverview] = []
    @State var presentedMovie: [MovieOverview] = []
    @State var currentPage: Int = 1
    @State var totalPages: Int?
    @Binding var selectedMovie: MovieOverview?
    @State var selectedCategory: TopMenuCategory?
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))]) {
                    ForEach(movies) { movie in
                        NavigationLink {
                            MovieDetailView(id: movie.id)
                        } label: {
                            MoviePreviewView(data: movie)
                                .padding(.bottom)
                        }
                        .task {
                            if movies.last == movie && currentPage <= totalPages! {
                                currentPage += 1
                                await updateMoviesList(page: currentPage)
                            }
                        }
                    }
                }
                .padding(.horizontal)
            }
            .refreshable {
                currentPage = 1
                movies.removeAll()
                await updateMoviesList(page: currentPage)
            }
            .navigationTitle(selectedCategory?.rawValue ?? "Error")
        }
        .task(priority: .userInitiated) {
            await updateMoviesList(page: currentPage)
        }
    }
    
    func getBaseURL() -> String {
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
    
    func updateMoviesList(page: Int) async {
        do {
            let apiKey = try webAccess.getAPIKey()
            let baseUrl = getBaseURL()
            let url = URL(string: "\(baseUrl)?api_key=\(apiKey)&page=\(page)")!
            let respond = try await webAccess.fetchMovieFromAPI(url: url, model: ListOfMovies.self)
            totalPages = respond.totalPages
            movies.append(contentsOf: respond.results)
        } catch {
            print(error)
        }
    }
    
    
}

struct PopularMoviesView_Previews: PreviewProvider {
    static var previews: some View {
        @State var movie: MovieOverview? = MovieOverview(id: 667538, title: "Transformers: Rise of the Beasts", releaseDate: "2023-06-06", overview: "When a new threat capable of destroying the entire planet emerges, Optimus Prime and the Autobots must team up with a powerful faction known as the Maximals. With the fate of humanity hanging in the balance, humans Noah and Elena will do whatever it takes to help the Transformers as they engage in the ultimate battle to save Earth.", voteAverage: 7.3, posterPath: "/gPbM0MK8CP8A174rmUwGsADNYKD.jpg")
        GridMoviesView(selectedMovie: $movie, selectedCategory: .nowPlaying)
    }
}

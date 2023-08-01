//
//  GridMoviesView.swift
//  Movie
//
//  Created by Elvis on 20/07/2023.
//

import SwiftUI

struct GridMoviesView: View {
    @StateObject var gridMoviesViewModel = GridMoviesViewModel()
    var selectedCategory: TopMenuCategory
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))]) {
                    ForEach(gridMoviesViewModel.movies) { movie in
                        NavigationLink {
                            MovieDetailView(id: movie.id)
                        } label: {
                            MoviePreviewView(data: movie)
                                .frame(height: 200)
                        }
                        .task {
                            await gridMoviesViewModel.updateMoviesList(selectedCategory: selectedCategory, movie: movie)
                        }
                    }
                }
                .padding(.horizontal)
            }
            .refreshable {
                await gridMoviesViewModel.refreshMovieList(selectedCategory: selectedCategory)
            }
            .navigationTitle(selectedCategory.rawValue)
        }
        .task(priority: .userInitiated) {
            await gridMoviesViewModel.getMoviesList(selectedCategory: selectedCategory, page: 1)
        }
    }
}

struct PopularMoviesView_Previews: PreviewProvider {
    static var previews: some View {
        @State var movie: MovieOverview? = MovieOverview(id: 667538, title: "Transformers: Rise of the Beasts", releaseDate: "2023-06-06", overview: "When a new threat capable of destroying the entire planet emerges, Optimus Prime and the Autobots must team up with a powerful faction known as the Maximals. With the fate of humanity hanging in the balance, humans Noah and Elena will do whatever it takes to help the Transformers as they engage in the ultimate battle to save Earth.", voteAverage: 7.3, posterPath: "/gPbM0MK8CP8A174rmUwGsADNYKD.jpg")
        GridMoviesView(selectedCategory: .nowPlaying)
    }
}

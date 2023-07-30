//
//  HorizontalScrollView.swift
//  Movie
//
//  Created by Elvis on 30/07/2023.
//

import SwiftUI

struct HorizontalScrollView: View {
    @StateObject var horizontalScrollViewModel = HorizontalScrollViewModel()
    
    var title: String
    var baseURL: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.title)
                .bold()
            ScrollView(.horizontal) {
                LazyHGrid(rows: [GridItem(.fixed(200))], spacing: 20) {
                    ForEach(horizontalScrollViewModel.movies) { movie in
                        NavigationLink {
                            MovieDetailView(id: movie.id)
                        } label: {
                            MoviePreviewView(data: movie)
                        }
                        .task {
                            await horizontalScrollViewModel.updateListOfMovies(movie: movie, baseURL: baseURL)
                        }
                    }
                }
                .frame(height: 200)
            }
        }
        .task {
            await horizontalScrollViewModel.loadListOfMovies(baseURL: baseURL, page: 1)
        }
    }
}

struct HorizontalScrollView_Previews: PreviewProvider {
    static var previews: some View {
        HorizontalScrollView(title: "Similar", baseURL: "https://api.themoviedb.org/3/movie/667538/similar")
    }
}

//
//  MovieDetailView.swift
//  Movie
//
//  Created by Elvis on 19/07/2023.
//

import SwiftUI

struct MovieDetailView: View {
    private let webAccess = WebAccess()
    
    @State var data: MovieDetail? = nil
    @State var id: Int
    @State var selection = 1
    
    var body: some View {
        ScrollView {
            VStack {
                HStack {
                    AsyncImage(url: URL(string: "https://image.tmdb.org/t/p/w300\(data?.posterPath ?? "")")) { phase in
                        if let image = phase.image {
                            image
                                .resizable()
                                .scaledToFit()
                        } else if phase.error != nil {
                            Image(systemName: "photo")
                            Text("There was an error loading an image")
                                .foregroundColor(.red)
                        } else {
                            ProgressView()
                        }
                        
                    }
                    .frame(width: 150)
                    VStack(alignment: .leading) {
                        Text("\(data?.title ?? "")")
                        RatingBar(score: data?.voteAverage ?? 0)
                    }
                    .padding(.horizontal)
                }
                .padding(.bottom)
                Picker(selection: $selection, label: Text("Picker")) {
                    Text("Informations").tag(1)
                    Text("Reviews").tag(2)
                }
                .pickerStyle(.segmented)
                switch(selection) {
                case 1:
                    VStack(alignment: .leading) {
                        HStack {
                            MovieLabel(text: data?.genres.first?.name ?? "")
                            MovieLabel(text: data?.releaseDate ?? "")
                            MovieLabel(text: String(data?.runtime ?? 0))
                        }
                        .padding(.bottom)
                        .font(.footnote)
                        ExpandText(text: data?.overview ?? "")
                            .padding(.bottom)
                        HorizontalScrollView(title: "Similar", baseURL: "https://api.themoviedb.org/3/movie/\(id)/similar")
                        HorizontalScrollView(title: "Recommendations", baseURL: "https://api.themoviedb.org/3/movie/\(id)/recommendations")
                    }
                case 2:
                    ReviewsView(id: id)
                default:
                    Text("Error")
                }
            }
            .padding()
        }
        .navigationTitle(data?.title ?? "Error")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await loadMovieDetails()
        }
    }
    
    func loadMovieDetails() async {
        do {
            let apiKey = try webAccess.getAPIKey()
            let url = URL(string: "https://api.themoviedb.org/3/movie/\(id)?api_key=\(apiKey)")!
            
            data = try await webAccess.fetchMovieFromAPI(url: url, model: MovieDetail.self)
        } catch {
            print(error)
        }
    }
}

struct MovieDetailView_Previews: PreviewProvider {
    static var previews: some View {
        @State var movie: MovieOverview? = MovieOverview(id: 667538, title: "Transformers: Rise of the Beasts", releaseDate: "2023-06-06", overview: "When a new threat capable of destroying the entire planet emerges, Optimus Prime and the Autobots must team up with a powerful faction known as the Maximals. With the fate of humanity hanging in the balance, humans Noah and Elena will do whatever it takes to help the Transformers as they engage in the ultimate battle to save Earth.", voteAverage: 7.3, posterPath: "/gPbM0MK8CP8A174rmUwGsADNYKD.jpg")
        MovieDetailView(id: 667538)
    }
}

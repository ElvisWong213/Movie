//
//  YouTubeView.swift
//  Movie
//
//  Created by Elvis on 31/07/2023.
//

import SwiftUI

struct YouTubeView: View {
    private let webAccess = WebAccess()
    @State var videoKey: String = ""
    var id: Int

    var body: some View {
        VStack(alignment: .leading) {
            Text("Trailer")
                .font(.title)
                .bold()
            ZStack {
                WebView(url: URL(string: "https://www.youtube.com/embed/\(videoKey)")!)
                    .allowsHitTesting(false)
                Link(destination: URL(string: "https://www.youtube.com/watch?v=\(videoKey)")!) {
                    Rectangle()
                        .foregroundColor(.clear)
                }
            }
        }
        .task {
            await getVideoKey()
        }
    }
    
    func getVideoKey() async {
        do {
            let apiKey = try webAccess.getAPIKey()
            let url = URL(string: "https://api.themoviedb.org/3/movie/\(id)/videos?api_key=\(apiKey)")!
            let data = try await webAccess.fetchMovieFromAPI(url: url, model: MovieVideo.self).results
            videoKey = data.filter({ video in
                return video.official == true && video.type == "Trailer"
            }).first?.key ?? ""
        } catch {
            print(error)
        }
    }
}

struct YouTubeView_Previews: PreviewProvider {
    static var previews: some View {
        YouTubeView(id: 667538)
    }
}

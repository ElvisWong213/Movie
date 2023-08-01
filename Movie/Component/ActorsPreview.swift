//
//  ActorsPreview.swift
//  Movie
//
//  Created by Elvis on 01/08/2023.
//

import SwiftUI

struct ActorsPreview: View {
    var profilePath: String
    var name: String
    var position: String
    
    var body: some View {
        VStack {
            CacheAsyncImage(url: URL(string: "https://image.tmdb.org/t/p/w185\(profilePath)")!) { phase in
                if let image = phase.image {
                    image
                        .resizable()
                        .scaledToFill()
                        .clipShape(Circle())
                } else if phase.error != nil {
                    Image(systemName: "photo")
                    Text("There was an error loading an image")
                        .foregroundColor(.red)
                } else {
                    ProgressView()
                }
            }
            .frame(width: 100, height: 100)
            Text(name)
                .font(.callout)
            Text(position)
                .font(.footnote)
        }
    }
}

struct ActorsIcon_Previews: PreviewProvider {
    static var previews: some View {
        ActorsPreview(profilePath: "/2Stnm8PQI7xHkVwINb4MhS7LOuR.jpg", name: "Anthony Ramos", position: "Acting")
    }
}

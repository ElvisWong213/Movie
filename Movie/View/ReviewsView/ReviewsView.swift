//
//  ReviewsView.swift
//  Movie
//
//  Created by Elvis on 30/07/2023.
//

import SwiftUI

struct ReviewsView: View {
    @StateObject var reviewsViewModel = ReviewsViewModel()
    var id: Int
    
    var body: some View {
        VStack(alignment: .leading) {
            ForEach(reviewsViewModel.reviews) { review in
                LazyVStack(alignment: .leading) {
                    HStack {
                        Text("\(review.author ?? "")")
                            .bold()
                        RatingBar(score: review.authorDetails?.rating ?? 0)
                    }
                    ExpandText(text: review.content ?? "")
                }
                .padding(.vertical)
                .task {
                    await reviewsViewModel.updateReviews(review: review, id: id)
                }
            }
        }
        .task {
            await reviewsViewModel.loadReviews(id: id, page: 1)
        }
    }
}

struct ReviewsView_Previews: PreviewProvider {
    static var previews: some View {
        ReviewsView(id: 667538)
    }
}

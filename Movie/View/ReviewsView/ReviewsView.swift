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
            if !reviewsViewModel.reviews.isEmpty {
                ForEach(reviewsViewModel.reviews.prefix(reviewsViewModel.showAllReviews ? reviewsViewModel.totalReviews : 2)) { review in
                    VStack(alignment: .leading) {
                        HStack {
                            Text("\(review.author)")
                                .bold()
                            RatingBar(score: review.authorDetails.rating ?? 0)
                        }
                        ExpandText(text: review.content)
                    }
                    .padding(.vertical)
                    .task {
                        await reviewsViewModel.updateReviews(review: review, id: id)
                    }
                }
                if reviewsViewModel.totalReviews > 2 {
                    HStack {
                        Spacer()
                        Button (action: {
                            reviewsViewModel.showAllReviews.toggle()
                        }) {
                            Text(reviewsViewModel.showAllReviews ? "Show Less" : "Show All")
                                .bold()
                        }
                        Spacer()
                    }
                }
            } else {
                Text("No Reviews")
                    .bold()
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

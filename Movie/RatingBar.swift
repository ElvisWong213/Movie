//
//  RatingBar.swift
//  Movie
//
//  Created by Elvis on 27/07/2023.
//

import SwiftUI

struct RatingBar: View {
    let onStar = Image(systemName: "star.fill")
    let offStar = Image(systemName: "star")
    let halfStar = Image(systemName: "star.leadinghalf.filled")
    var score: Float
    
    var body: some View {
        HStack {
            ForEach (1...5, id: \.self) { val in
                star(number: val)
            }
            .foregroundColor(.orange)
        }
    }
    
    func star(number: Int) -> Image {
        let converScore = score / 2
        if number <= Int(converScore) {
            return onStar
        }
        let remain = Float(number) - converScore
        if remain.remainder(dividingBy: Float(number)) < 1 && remain.remainder(dividingBy: Float(number)) > -1{
            return halfStar
        }
        return offStar
    }
}

struct RatingBar_Previews: PreviewProvider {
    static var previews: some View {
        RatingBar(score: 5)
    }
}

//
//  MovieVideo.swift
//  Movie
//
//  Created by Elvis on 30/07/2023.
//

import Foundation

struct MovieVideo: Decodable {
    let id: Int
    let results: [VideoDetail]
}

struct VideoDetail: Decodable {
    let id: String
    let key: String?
    let site: String?
    let type: String?
    let official: Bool?
}

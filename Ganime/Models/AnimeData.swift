//
//  AnimeData.swift
//  Ganime
//
//  Created by Brian Rosales on 2/12/22.
//

import Foundation
struct AnimeData: Decodable {
    let data: [TitleData]?
}
struct TitleData: Decodable {
    let attributes: AnimeInfo?
}
struct AnimeInfo: Decodable {
    let synopsis: String?
    let averageRating: String?
    let ageRating: String?
    let status: String?
    let canonicalTitle: String?
    let posterImage: PosterImage?
}

struct PosterImage: Decodable {
    let small: String?
}


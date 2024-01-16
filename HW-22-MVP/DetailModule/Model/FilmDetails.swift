//
//  FilmDetailsModel.swift
//  HW-22-MVP
//
//  Created by Олег Ковалев on 17.12.2023.
//

import Foundation

protocol FilmDetailServiceProtocol {
    func getFilmsByID(filmID: Int, completion: @escaping (FilmDetails?, Error?, Bool?) -> Void)

}

// MARK: - FilmIDDetails
struct FilmDetails: Codable {
    let kinopoiskID: Int?
    let kinopoiskHDID, imdbID, nameRu: String?
    let nameEn: JSONNullID?
    let nameOriginal: String?
    let posterURL, posterURLPreview: String?
    let coverURL, logoURL: String?
    let reviewsCount, ratingGoodReview, ratingGoodReviewVoteCount: Int?
    let ratingKinopoisk: Double?
    let ratingKinopoiskVoteCount: Int?
    let ratingImdb: Double?
    let ratingImdbVoteCount: Int?
    let ratingFilmCritics: Double?
    let ratingFilmCriticsVoteCount, ratingAwait, ratingAwaitCount, ratingRFCritics: Int?
    let ratingRFCriticsVoteCount: Int?
    let webURL: String?
    let year, filmLength: Int?
    let slogan, description, shortDescription: String?
    let editorAnnotation: JSONNullID?
    let isTicketsAvailable: Bool?
    let productionStatus: JSONNullID?
    let type, ratingMPAA, ratingAgeLimits: String?
    let countries: [CountryID]?
    let genres: [GenreID]?
    let startYear, endYear: JSONNullID?
    let serial, shortFilm, completed, hasImax: Bool?
    let has3D: Bool?
    let lastSync: String?

    enum CodingKeys: String, CodingKey {
        case kinopoiskID = "kinopoiskId"
        case kinopoiskHDID = "kinopoiskHDId"
        case imdbID = "imdbId"
        case nameRu, nameEn, nameOriginal
        case posterURL = "posterUrl"
        case posterURLPreview = "posterUrlPreview"
        case coverURL = "coverUrl"
        case logoURL = "logoUrl"
        case reviewsCount, ratingGoodReview, ratingGoodReviewVoteCount
        case ratingKinopoisk, ratingKinopoiskVoteCount, ratingImdb, ratingImdbVoteCount, ratingFilmCritics, ratingFilmCriticsVoteCount, ratingAwait, ratingAwaitCount
        case ratingRFCritics = "ratingRfCritics"
        case ratingRFCriticsVoteCount = "ratingRfCriticsVoteCount"
        case webURL = "webUrl"
        case year, filmLength, slogan, description, shortDescription, editorAnnotation, isTicketsAvailable, productionStatus, type
        case ratingMPAA = "ratingMpaa"
        case ratingAgeLimits, countries, genres, startYear, endYear, serial, shortFilm, completed, hasImax, has3D, lastSync
    }
}

// MARK: - Country
struct CountryID: Codable {
    let country: String?
}

// MARK: - Genre
struct GenreID: Codable {
    let genre: String?
}

// MARK: - Encode/decode helpers

class JSONNullID: Codable, Hashable {

    public static func == (lhs: JSONNullID, rhs: JSONNullID) -> Bool {
        return true
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(0)
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNullID.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}

class FilmDetailModel: FilmDetailServiceProtocol {

    func getFilmsByID(filmID: Int, completion: @escaping (FilmDetails?, Error?, Bool?) -> Void) {
        let urlString = "https://kinopoiskapiunofficial.tech/api/v2.2/films/\(filmID)"

        guard let urlComponents = URLComponents(string: urlString) else { return }
        guard let url = urlComponents.url else { return }
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = ["X-API-KEY": "a8587f52-2d32-42d4-9d69-5928b9d2d5ff"]

        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                completion(nil, error, nil)
                print("ERROR")
            } else {
                guard let data else { return }
                if let filmData = try? JSONDecoder().decode(FilmDetails.self, from: data) {
                    completion(filmData, nil, nil)
                    print("SUCCESS")
                } else {
                    completion(nil, nil, true)
                    print("NIL")
                }
            }
        }
        task.resume()
    }
}

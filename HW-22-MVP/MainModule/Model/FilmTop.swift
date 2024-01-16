//
//  FilmTop.swift
//  HW-22-MVP
//
//  Created by Олег Ковалев on 17.12.2023.
//

import Foundation

protocol FilmTopServiceProtocol {
    func getTopFilms(completion: @escaping (FilmTop?, Error?, Bool?) -> Void)
}

// MARK: - FilmTop
struct FilmTop: Codable {
    let pagesCount: Int?
    let films: [Films]?
}

// MARK: - Film
struct Films: Codable {
    let filmID: Int?
    let nameRu: String?
    let nameEn: String?
    let year: String?
    let filmLength: String?
    let countries: [Countrys]?
    let genres: [Genres]?
    let rating: String?
    let ratingVoteCount: Int?
    let posterURL, posterURLPreview: String?
    let ratingChange, isRatingUp: JSONNull?
    let isAfisha: Int?

    enum CodingKeys: String, CodingKey {
        case filmID = "filmId"
        case nameRu, nameEn, year, filmLength, countries, genres, rating, ratingVoteCount
        case posterURL = "posterUrl"
        case posterURLPreview = "posterUrlPreview"
        case ratingChange, isRatingUp, isAfisha
    }
}

// MARK: - Country
struct Countrys: Codable {
    let country: String?
}

// MARK: - Genre
struct Genres: Codable {
    let genre: String?
}

// MARK: - Encode/decode helpers

class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(0)
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}

class FilmTopModel: FilmTopServiceProtocol {

    func getTopFilms(completion: @escaping (FilmTop?, Error?, Bool?) -> Void) {
        let urlString = "https://kinopoiskapiunofficial.tech/api/v2.2/films/top"

        guard var urlComponents = URLComponents(string: urlString) else { return }
        urlComponents.queryItems = [URLQueryItem(name: "type", value: "TOP_100_POPULAR_FILMS")]
        guard let url = urlComponents.url else { return }
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = ["X-API-KEY": "a8587f52-2d32-42d4-9d69-5928b9d2d5ff"]

        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                completion(nil, error, nil)
                print("ERROR")
            } else {
                guard let data else { return }
                if let filmData = try? JSONDecoder().decode(FilmTop.self, from: data) {
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

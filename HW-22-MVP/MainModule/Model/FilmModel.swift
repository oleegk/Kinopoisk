//
//  FilmData.swift
//  HW-22-MVP
//
//  Created by Олег Ковалев on 17.12.2023.
//

import Foundation

// MARK: - FilmServiceProtocol
protocol FilmServiceProtocol {
    func getFilmsByKeyword(keyword: String, completion: @escaping (Film?, Error?, Bool?) -> Void)
}

// MARK: - Film
struct Film: Codable {
    let keyword: String?
    let pagesCount: Int?
    let films: [FilmElement]
    let searchFilmsCountResult: Int?
}

// MARK: - FilmElement
struct FilmElement: Codable {
    let filmID: Int?
    let nameRu: String?
    let nameEn: String?
    let type: TypeEnum
    let year: String
    let description, filmLength: String?
    let countries: [Country]
    let genres: [Genre]
    let rating: String?
    let ratingVoteCount: Int?
    let posterURL, posterURLPreview: String?

    enum CodingKeys: String, CodingKey {
        case filmID = "filmId"
        case nameRu, nameEn, type, year, description, filmLength, countries, genres, rating, ratingVoteCount
        case posterURL = "posterUrl"
        case posterURLPreview = "posterUrlPreview"
    }
}

// MARK: - Country
struct Country: Codable {
    let country: String?
}

// MARK: - Genre
struct Genre: Codable {
    let genre: String?
}

enum TypeEnum: String, Codable {
    case film = "FILM"
    case miniSeries = "MINI_SERIES"
    case tvSeries = "TV_SERIES"
    case video = "VIDEO"
}

class FilmModel: FilmServiceProtocol {

    func getFilmsByKeyword(keyword: String, completion: @escaping (Film?, Error?, Bool?) -> Void) {
        let urlString = "https://kinopoiskapiunofficial.tech/api/v2.1/films/search-by-keyword?keyword="

        guard var urlComponents = URLComponents(string: urlString) else { return }
        urlComponents.queryItems = [URLQueryItem(name: "keyword", value: keyword)]
        guard let url = urlComponents.url else { return }

        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = ["X-API-KEY": "a8587f52-2d32-42d4-9d69-5928b9d2d5ff"]

        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                completion(nil, error, nil)
                print("ERROR")
            } else {
                guard let data else { return }
                if let filmData = try? JSONDecoder().decode(Film.self, from: data) {
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

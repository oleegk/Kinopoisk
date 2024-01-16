//
//  FilmDetailPresenter.swift
//  HW-22-MVP
//
//  Created by Олег Ковалев on 19.12.2023.
//

import Foundation

protocol FilmDetailPresenterProtocol: AnyObject {
    var view: FilmDetailViewProtocol? { get }
    var modelFilm: FilmDetailServiceProtocol { get }
    func configure(film: FilmDetails)
}

class FilmDetailPresenter: FilmDetailPresenterProtocol {

    weak var view: FilmDetailViewProtocol?
    var modelFilm: FilmDetailServiceProtocol

    init(view: FilmDetailViewProtocol?, modelFilm: FilmDetailServiceProtocol) {
        self.view = view
        self.modelFilm = modelFilm
    }

    func configure(film: FilmDetails) {
        DispatchQueue.main.async { [weak self] in
            guard let view = self?.view else { return }
            view.posterUrl = film.posterURL ?? ""
            view.nameFilmRuLabel.text = film.nameRu
            view.nameFilmOriginalLabel.text = film.nameOriginal
            view.raitingKinopoiskLabel.text = "\(String(describing: film.ratingKinopoisk ?? 0.0))"
            if Double(view.raitingKinopoiskLabel.text!)! > 7.0 {
                view.raitingKinopoiskLabel.textColor = .systemGreen
            } else if Double(view.raitingKinopoiskLabel.text!)! < 7.0 && Double(view.raitingKinopoiskLabel.text!)! > 5.0 {
                view.raitingKinopoiskLabel.textColor = .systemYellow
            } else {
                view.raitingKinopoiskLabel.textColor = .systemRed
            }
            view.raitingImdbLabel.text = "\(String(describing: film.ratingImdb ?? 0.0))"
            view.yearLabel.text = "\(String(describing: film.year ?? 0))"
            view.filmLengthLabel.text = "\(String(describing: film.filmLength ?? 0)) мин."
            view.descriptionFilmLabel.text = film.description

            let queue = DispatchQueue.global(qos: .utility)
            queue.async {
                if let data = try? Data(contentsOf: (URL(string: view.posterUrl) ?? URL(string: "https://kinopoiskapiunofficial.tech/images/posters/kp/4749291.jpg"))!) {
                    view.loadPosterImage(data: data)
                }
            }
        }
    }
}

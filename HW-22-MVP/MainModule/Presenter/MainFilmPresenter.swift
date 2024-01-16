//
//  MainPresenter.swift
//  HW-22-MVP
//
//  Created by Олег Ковалев on 17.12.2023.
//

import Foundation
import UIKit

protocol MainFilmPresenterProtocol {
    var view: MainFilmViewProtocol? { get }
    var modelFilm: FilmServiceProtocol { get }
    var modelFilmTop: FilmTopServiceProtocol { get }
    var cell: MyCellProtocol { get }
    var cellPreviewModelArray: [MyCellModelProtocol] { get }
    var detailFilmPresenter: FilmDetailPresenterProtocol? { get }
    func getFilmsByKeyword(keyword: String)
    func getPopFilms()
    func didTapSearchButton(_ keyword: String)
    func didTapPopFilmsButton()
    func numberOfFilms() -> Int
    func heightForRowAt() -> CGFloat
    func configure(cell: MyCellProtocol, forRow row: Int)
    func didTapRefresh(sender: UIRefreshControl)
    func getFilmBy(id: Int)
}

class MainFilmPresenter: MainFilmPresenterProtocol {

    weak var view: MainFilmViewProtocol?
    var modelFilm: FilmServiceProtocol
    var modelFilmTop: FilmTopServiceProtocol
    var cell: MyCellProtocol
    var cellPreviewModelArray: [MyCellModelProtocol] = []
    var detailFilmPresenter: FilmDetailPresenterProtocol?

    init(view: MainFilmViewProtocol, modelFilm: FilmServiceProtocol, modelTopFilm: FilmTopServiceProtocol, cell: MyCellProtocol) {
        self.view = view
        self.modelFilm = modelFilm
        self.modelFilmTop = modelTopFilm
        self.cell = cell
    }

    func getFilmsByKeyword(keyword: String) {
        modelFilm.getFilmsByKeyword(keyword: keyword) { [weak self] data, _, _ in
            guard let self else { return }
            guard let data else { return }
            data.films.forEach { film in
                let cellModel = MyCellModel(filmId: film.filmID,
                                            nameRu: film.nameRu,
                                            posterURL: film.posterURLPreview)
                self.cellPreviewModelArray.append(cellModel)
                DispatchQueue.main.async {
                    self.view?.activityIndicator.stopAnimating()
                    self.view?.tableView.reloadData()
                }
            }
        }
    }

    func getPopFilms() {
        modelFilmTop.getTopFilms(completion: { [weak self] data, _, _ in
            guard let self else { return }
            guard let data else { return }
            print("getPopFilms")
            data.films?.forEach { film in
                let cellModel = MyCellModel(filmId: film.filmID,
                                            nameRu: film.nameRu,
                                            posterURL: film.posterURLPreview)
                self.cellPreviewModelArray.append(cellModel)
                DispatchQueue.main.async {
                    self.view?.activityIndicator.stopAnimating()
                    self.view?.tableView.reloadData()
                }
            }
        })
    }

    func didTapSearchButton(_ keyword: String) {
        view?.addActivityIndicator()
        view?.activityIndicator.startAnimating()
        cellPreviewModelArray.removeAll()
        getFilmsByKeyword(keyword: keyword)

    }

    func didTapPopFilmsButton() {
        view?.activityIndicator.startAnimating()
        cellPreviewModelArray.removeAll()
        getPopFilms()
    }

    func numberOfFilms() -> Int {
        return cellPreviewModelArray.count
    }

    func heightForRowAt() -> CGFloat {
        return 100
    }

    func configure(cell: MyCellProtocol, forRow row: Int) {
        guard let cell = cell as? MyCell else { return }
        cell.posterUrl = cellPreviewModelArray[row].posterURL ?? ""
        cell.nameFilmRuLabel.text = cellPreviewModelArray[row].nameRu
        cell.filmIDLabel.text = "\(cellPreviewModelArray[row].filmId ?? 0)"

        let queue = DispatchQueue.global(qos: .utility)
        queue.async {
            if let data = try? Data(contentsOf: URL(string: cell.posterUrl)!) {
                DispatchQueue.main.async { [weak self] in
                    guard self != nil else { return }
                    let view = UIImage(data: data)
                    cell.posterView.image = view
                }
            }
        }
    }

    func didTapRefresh(sender: UIRefreshControl) {
        DispatchQueue.main.async {
            self.view?.tableView.reloadData()
            sender.endRefreshing()
        }
    }

    func getFilmBy(id: Int) {
        detailFilmPresenter = FilmDetailPresenter(view: FilmDetailViewController(), modelFilm: FilmDetailModel())
        detailFilmPresenter?.modelFilm.getFilmsByID(filmID: id) { [weak self] data, _, _ in
            guard let self else { return }
            guard let data else { return }
            view?.showFilmDetailScreen(film: data)
        }
    }
}

//
//  FilmDetailViewController.swift
//  HW-22-MVP
//
//  Created by Олег Ковалев on 19.12.2023.
//

import UIKit

protocol FilmDetailViewProtocol: AnyObject {
    var posterUrl: String { get set }
    var nameFilmRuLabel: UILabel { get set }
    var nameFilmOriginalLabel: UILabel { get set }
    var raitingKinopoiskLabel: UILabel { get set }
    var raitingImdbLabel: UILabel { get set }
    var yearLabel: UILabel { get set }
    var filmLengthLabel: UILabel { get set }
    var descriptionFilmLabel: UILabel { get set }
    var posterView: UIImageView { get set }
    func configure(film: FilmDetails)
    func loadPosterImage(data: Data)

}

class FilmDetailViewController: UIViewController, FilmDetailViewProtocol {

    // MARK: - Variable

    var presenter: FilmDetailPresenterProtocol!

    private lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        return view
    }()

    private lazy var contentView: UIView = {
        let view = UIView()
        return view
    }()

    lazy var posterView: UIImageView = {
        let view = UIImageView()
        view.layer.cornerRadius = 7
        view.clipsToBounds = true
        return view
    }()

    lazy var nameFilmRuLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.textAlignment = .center
        label.sizeToFit()
        return label
    }()

    lazy var nameFilmOriginalLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .lightGray
        label.textAlignment = .center
        return label
    }()

    private lazy var kinopoiskLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.text = "Kinopoisk"
        label.textAlignment = .center
        return label
    }()

    lazy var raitingKinopoiskLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.textAlignment = .center
        return label
    }()

    private lazy var imdbLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.text = "IMDB"
        label.textAlignment = .center
        return label
    }()

    lazy var raitingImdbLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.textAlignment = .center
        return label
    }()

    private lazy var titleYearLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.textColor = .lightGray
        label.text = "Год производства"
        return label
    }()

    lazy var yearLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)

        return label
    }()

    private lazy var titleFilmLengthLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.textColor = .lightGray
        label.text = "Продолжительность"
        return label
    }()

    lazy var filmLengthLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        return label
    }()

    lazy var descriptionFilmLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 16, weight: .regular)
        return label
    }()

    lazy var posterUrl = String()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
        presenter = FilmDetailPresenter(view: self, modelFilm: FilmDetailModel())

    }

    // MARK: - Methods

    private func setupViews() {
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(scrollView)
        }
        contentView.addSubview(posterView)
        posterView.snp.makeConstraints { make in
            make.width.equalTo(190)
            make.height.equalTo(250)
            make.top.equalToSuperview().offset(40)
            make.left.equalToSuperview().offset(20)
        }
        contentView.addSubview(nameFilmRuLabel)
        nameFilmRuLabel.snp.makeConstraints { make in
            make.width.equalTo(300)
            make.centerX.equalToSuperview()
            make.top.equalTo(posterView.snp.bottomMargin).offset(60)
        }
        contentView.addSubview(nameFilmOriginalLabel)
        nameFilmOriginalLabel.snp.makeConstraints { make in
            make.width.equalTo(270)
            make.centerX.equalToSuperview()
            make.top.equalTo(nameFilmRuLabel.snp.bottomMargin).offset(7)
        }
        contentView.addSubview(kinopoiskLabel)
        kinopoiskLabel.snp.makeConstraints { make in
            make.width.equalTo(100)
            make.height.equalTo(25)
            make.top.equalToSuperview().offset(40)
            make.right.equalToSuperview().offset(-30)
        }
        contentView.addSubview(raitingKinopoiskLabel)
        raitingKinopoiskLabel.snp.makeConstraints { make in
            make.width.equalTo(30)
            make.height.equalTo(30)
            make.top.equalTo(kinopoiskLabel.snp.bottomMargin).offset(10)
            make.centerX.equalTo(kinopoiskLabel.snp.centerX)
        }
        contentView.addSubview(imdbLabel)
        imdbLabel.snp.makeConstraints { make in
            make.width.equalTo(100)
            make.height.equalTo(25)
            make.top.equalTo(raitingKinopoiskLabel.snp.bottomMargin).offset(20)
            make.right.equalToSuperview().offset(-30)
        }
        contentView.addSubview(raitingImdbLabel)
        raitingImdbLabel.snp.makeConstraints { make in
            make.width.equalTo(30)
            make.height.equalTo(30)
            make.top.equalTo(imdbLabel.snp.bottomMargin).offset(10)
            make.centerX.equalTo(imdbLabel.snp.centerX)
        }
        contentView.addSubview(descriptionFilmLabel)
        descriptionFilmLabel.snp.makeConstraints { make in
            make.width.equalTo(350)
            make.centerX.equalToSuperview()
            make.top.equalTo(nameFilmOriginalLabel.snp.bottomMargin).offset(30)
        }
        contentView.addSubview(titleYearLabel)
        titleYearLabel.snp.makeConstraints { make in
            make.width.equalTo(170)
            make.height.equalTo(25)
            make.top.equalTo(descriptionFilmLabel.snp.bottomMargin).offset(50)
            make.left.equalToSuperview().offset(20)
        }
        contentView.addSubview(yearLabel)
        yearLabel.snp.makeConstraints { make in
            make.width.equalTo(45)
            make.height.equalTo(25)
            make.top.equalTo(titleYearLabel.snp.bottomMargin).offset(5)
            make.left.equalToSuperview().offset(20)
        }
        contentView.addSubview(titleFilmLengthLabel)
        titleFilmLengthLabel.snp.makeConstraints { make in
            make.width.equalTo(170)
            make.height.equalTo(25)
            make.top.equalTo(yearLabel.snp.bottomMargin).offset(15)
            make.left.equalToSuperview().offset(20)
        }
        contentView.addSubview(filmLengthLabel)
        filmLengthLabel.snp.makeConstraints { make in
            make.width.equalTo(70)
            make.height.equalTo(25)
            make.top.equalTo(titleFilmLengthLabel.snp.bottomMargin).offset(5)
            make.left.equalToSuperview().offset(20)
            make.bottom.equalToSuperview()
        }
    }

    func configure(film: FilmDetails) {
        presenter.configure(film: film)
    }

    func loadPosterImage(data: Data) {
        let view = UIImage(data: data)
        DispatchQueue.main.async {
            self.posterView.image = view
        }

    }
}

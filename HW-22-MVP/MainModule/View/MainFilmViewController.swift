//
//  MainViewController.swift
//  HW-22-MVP
//
//  Created by Олег Ковалев on 17.12.2023.
//

import UIKit
import SnapKit

protocol MainFilmViewProtocol: AnyObject {
    var tableView: UITableView { get set }
    var popFilmsButton: UIButton { get set }
    var userRequestText: String { get set }
    var searchBar: UISearchBar { get set }
    var activityIndicator: UIActivityIndicatorView { get set }

    func showFilmDetailScreen(film: FilmDetails)
    func addActivityIndicator()
}

class MainViewController: UIViewController, MainFilmViewProtocol {

    var presenter: MainFilmPresenterProtocol!

    // MARK: - Variables

    lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.searchBarStyle = .prominent
        searchBar.placeholder = "Поиск ...."
        searchBar.sizeToFit()
        searchBar.isTranslucent = true
        searchBar.backgroundImage = UIImage()
        return searchBar
    }()

    lazy var popFilmsButton: UIButton = {
        let button = UIButton()
        button.setTitle("Популярные фильмы", for: .normal)
        button.tintColor = .white
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 7
        return button
    }()

    var userRequestText = ""

    lazy var activityIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .medium)
        return view
    }()

    lazy var tableView: UITableView = {
        let view = UITableView(frame: CGRect.zero, style: .grouped)
        view.tableHeaderView = headerView
        view.backgroundColor = .white
        return view
    }()

    private lazy var headerView: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        label.textColor = .lightGray
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        return label
    }()

    private lazy var myRefreshControl: UIRefreshControl = {
        let myRefreshControl = UIRefreshControl()
        myRefreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        myRefreshControl.attributedTitle = NSAttributedString(string: "Updating")
        myRefreshControl.tintColor = .lightGray
        return myRefreshControl
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        addTargetButtons()
        presenter = MainFilmPresenter(view: self,
                                      modelFilm: FilmModel(),
                                      modelTopFilm: FilmTopModel(),
                                      cell: MyCell())
    }

    // MARK: - Methods

    private func setupViews() {

        view.addSubview(searchBar)
        searchBar.delegate = self
        searchBar.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(100)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
        }
        view.addSubview(popFilmsButton)
        popFilmsButton.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottomMargin).offset(40)
            make.centerX.equalToSuperview()
            make.width.equalTo(210)
            make.height.equalTo(33)
        }
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MyCell.self, forCellReuseIdentifier: "Cell")
        tableView.refreshControl = myRefreshControl
        tableView.snp.makeConstraints { make in
            make.top.equalTo(popFilmsButton.snp.bottomMargin).offset(30)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottomMargin)
        }
    }

    private func addTargetButtons() {
        popFilmsButton.addTarget(self, action: #selector(popFilmsButtonIsPressed), for: .touchUpInside)
    }

    @objc func popFilmsButtonIsPressed(sender: UIButton) {
        presenter.didTapPopFilmsButton()
        headerView.text = "Популярные фильмы"
    }

    @objc func refresh(sender: UIRefreshControl) {
        presenter.didTapRefresh(sender: sender)
    }

    func addActivityIndicator() {
        view.addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints { make in
            make.center.equalTo(view.safeAreaLayoutGuide.snp.center)
        }
    }

    func showFilmDetailScreen(film: FilmDetails) {
        DispatchQueue.main.async {
            let detailVC = FilmDetailViewController()
            self.present(detailVC, animated: true)
            detailVC.configure(film: film)
        }
    }
}

    // MARK: - extension

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.numberOfFilms()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? MyCellProtocol
        presenter.configure(cell: cell ?? MyCell(), forRow: indexPath.row)
        return cell as? UITableViewCell ?? UITableViewCell()
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        presenter.heightForRowAt()
    }
}

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let IDFilm = presenter.cellPreviewModelArray[indexPath.row].filmId else { return }
        presenter.getFilmBy(id: IDFilm)
    }
}

extension MainViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        if let text = searchBar.text {
            userRequestText = text
            presenter.didTapSearchButton(text)
            headerView.text = "Поиск по запросу: \(text)"
        }
    }
}

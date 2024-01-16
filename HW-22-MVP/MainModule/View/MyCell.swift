//
//  MainCell.swift
//  HW-22-MVP
//
//  Created by Олег Ковалев on 19.12.2023.
//

import UIKit

protocol MyCellProtocol {
    var nameFilmRuLabel: UILabel { get }
    var filmIDLabel: UILabel { get }
    var posterUrl: String { get set }
    var posterView: UIImageView { get }
}

class MyCell: UITableViewCell, MyCellProtocol {

    // MARK: - Variable

    lazy var nameFilmRuLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 16, weight: .regular)
        return label
    }()

    lazy var filmIDLabel: UILabel = {
        let label = UILabel()
        return label
    }()

    var posterUrl = String()

    lazy var posterView: UIImageView = {
        let view = UIImageView()
        view.layer.cornerRadius = 2
        view.clipsToBounds = true
        return view
    }()

    // MARK: - Lifecycle

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Methods

    private func setupViews() {
        contentView.addSubview(posterView)
        posterView.snp.makeConstraints { make in
            make.width.equalTo(60)
            make.height.equalTo(80)
            make.centerY.equalToSuperview()
            make.left.equalToSuperview()
        }
        contentView.addSubview(nameFilmRuLabel)
        nameFilmRuLabel.snp.makeConstraints { make in
            make.centerY.equalTo(posterView.snp.centerY)
            make.left.equalTo(posterView.snp.rightMargin).offset(30)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(80)
        }
    }
}

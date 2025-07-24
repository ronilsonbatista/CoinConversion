//
//  ListCurrenciesSectionViewCell.swift
//  CoinConversion
//
//  Created by Ronilson Batista on 19/07/20.
//  Copyright © 2020 Ronilson Batista. All rights reserved.
//

import UIKit

protocol ListCurrenciesSectionViewCellDelegate: AnyObject {
    func didTapSortBy(_ sortType: SortType)
}

// MARK: - Main
class ListCurrenciesSectionViewCell: UITableViewHeaderFooterView {
    static let identifier = "ListCurrenciesSectionViewCell"
    
    weak var delegate: ListCurrenciesSectionViewCellDelegate?
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Ordenar por:"
        label.textColor = .colorGrayPrimary
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let sortByNameButton: RadioButton = {
        let button = RadioButton()
        button.setTitle("Nome", for: .normal)
        button.setTitleColor(.colorSectionLabelk, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18)
        button.iconColor = .colorGrayLighten60
        button.indicatorColor = .colorDarkishPink
        button.iconBackgroundColor = .colorGrayLighten70
        button.tag = 0
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let sortByCodeButton: RadioButton = {
        let button = RadioButton()
        button.setTitle("Código", for: .normal)
        button.setTitleColor(.colorSectionLabelk, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18)
        button.iconColor = .colorGrayLighten60
        button.indicatorColor = .colorDarkishPink
        button.iconBackgroundColor = .colorGrayLighten70
        button.tag = 1
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Init
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    private func configureView() {
        contentView.backgroundColor = .colorBackground
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(sortByNameButton)
        contentView.addSubview(sortByCodeButton)
        
        sortByNameButton.addTarget(self, action: #selector(didTapSortByName), for: .touchUpInside)
        sortByCodeButton.addTarget(self, action: #selector(didTapSortByCode), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            // titleLabel
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 21),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -21),
            
            // sortByNameButton
            sortByNameButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            sortByNameButton.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            sortByNameButton.widthAnchor.constraint(equalToConstant: 80),
            sortByNameButton.heightAnchor.constraint(equalToConstant: 20),
            
            // sortByCodeButton
            sortByCodeButton.topAnchor.constraint(equalTo: sortByNameButton.topAnchor),
            sortByCodeButton.leadingAnchor.constraint(equalTo: sortByNameButton.trailingAnchor, constant: 40),
            sortByCodeButton.widthAnchor.constraint(equalToConstant: 86),
            sortByCodeButton.heightAnchor.constraint(equalTo: sortByNameButton.heightAnchor),
            
            // alinhamento inferior
            sortByNameButton.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -16.5)
        ])
    }
    
    // MARK: - Actions
    @objc private func didTapSortByName() {
        setupRadioButtons(selectedTag: 0)
        delegate?.didTapSortBy(.name)
    }
    
    @objc private func didTapSortByCode() {
        setupRadioButtons(selectedTag: 1)
        delegate?.didTapSortBy(.code)
    }
    
    // MARK: - Helpers
    func setupRadioButtons(selectedTag: Int) {
        [sortByNameButton, sortByCodeButton].forEach { button in
            button.isSelected = (button.tag == selectedTag)
        }
    }
}

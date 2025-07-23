//
//  ListCurrenciesViewCell.swift
//  CoinConversion
//
//  Created by Ronilson Batista on 20/07/20.
//  Copyright © 2020 Ronilson Batista. All rights reserved.
//

import UIKit

class ListCurrenciesViewCell: UITableViewCell {
    
    // MARK: - Propriedades
    static let identifier = "ListCurrenciesViewCell"
    
    private let containerView: UIView = {
        let view = UIView()
        view.setCardLayout()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let currencyLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textAlignment = .left
        label.textColor = .colorGrayPrimary
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .colorBackground // no código original, o separador era custom
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = .colorGrayPrimary
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Inicializador
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configuração da View
    private func configureView() {
        backgroundColor = .clear
        contentView.addSubview(containerView)
        
        containerView.addSubview(currencyLabel)
        containerView.addSubview(separatorView)
        containerView.addSubview(nameLabel)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 21),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -21),
            
            currencyLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            currencyLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 24),
            currencyLabel.widthAnchor.constraint(equalToConstant: 50),
            
            separatorView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 9),
            separatorView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -9),
            separatorView.leadingAnchor.constraint(equalTo: currencyLabel.trailingAnchor, constant: 10),
            separatorView.widthAnchor.constraint(equalToConstant: 1),
            
            nameLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 1),
            nameLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -1),
            nameLabel.leadingAnchor.constraint(equalTo: separatorView.trailingAnchor, constant: 8),
            nameLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8)
        ])
    }
    
    // MARK: - Bind
    func bind(name: String, currency: String) {
        nameLabel.text = name
        currencyLabel.text = currency
    }
}


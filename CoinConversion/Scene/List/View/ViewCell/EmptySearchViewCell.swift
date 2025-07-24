//
//  EmptySearchViewCell.swift
//  CoinConversion
//
//  Created by Ronilson Batista on 20/07/20.
//  Copyright © 2020 Ronilson Batista. All rights reserved.
//

import UIKit

class EmptySearchViewCell: UITableViewCell {
    
    static let identifier = "EmptySearchViewCell"
    
    private let txtWithout: UILabel = {
        let label = UILabel()
        label.text = "Nenhuma moeda encontrada"
        label.textColor = .gray
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let imageViewSad: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "sad")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    // MARK: - Inicializadores
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
        contentView.backgroundColor = .colorBackground
        contentView.addSubview(txtWithout)
        contentView.addSubview(imageViewSad)
        
        NSLayoutConstraint.activate([
            txtWithout.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 40),
            txtWithout.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 31),
            txtWithout.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -31),
            
            imageViewSad.topAnchor.constraint(equalTo: txtWithout.bottomAnchor, constant: 30),
            imageViewSad.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            imageViewSad.heightAnchor.constraint(equalToConstant: 100),
            imageViewSad.widthAnchor.constraint(equalToConstant: 100),
            
            imageViewSad.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -10.5)
        ])
    }
}

//
//  ConversionView.swift
//  CoinConversion
//
//  Created by Ronilson Batista on 25/07/25.
//  Copyright © 2025 Ronilson Batista. All rights reserved.
//

import UIKit

final class ConversionView: UIView {

    // MARK: - Components

    let scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        return scroll
    }()

    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    let updateDateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        label.textColor = .colorSectionLabel
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let fromTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "De: "
        label.font = .systemFont(ofSize: 14)
        label.textAlignment = .left
        label.numberOfLines = 0
        label.textColor = .colorGrayPrimary
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let fromCurrencyNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Clique para escolher"
        label.font = .systemFont(ofSize: 13)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .colorGrayPrimary
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let fromView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setCardLayout()
        return view
    }()
    
    
    let fromCurrencyCodeLabel = ConversionView.createLabel(text: "aaaaa")
    let fromSeparatorView = ConversionView.createSeparator()
//    let fromView = ConversionView.createCardView()
    let fromWithCurrencyView = ConversionView.createCardView(hidden: true)

    let toCurrencyNameLabel = ConversionView.createLabel(text: "Clique para escolher")
    let toCurrencyCodeLabel = ConversionView.createLabel()
    let toSeparatorView = ConversionView.createSeparator()
    let toView = ConversionView.createCardView()
    let toWithCurrencyView = ConversionView.createCardView(hidden: true)

    let valueTextField: UITextField = {
        let field = UITextField()
        field.placeholder = "Digite o valor"
        field.textAlignment = .center
        field.keyboardType = .numberPad
        field.font = .systemFont(ofSize: 13)
        field.tintColor = .colorDarkishPink
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()

    let valueView = ConversionView.createCardView()
    let resultLabel = ConversionView.createLabel(alignment: .center, fontSize: 16, text: "-")
    let resultView = ConversionView.createCardView()
    
    let conversionStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 16
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.isHidden = true
        return stack
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .colorBackground
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


private extension ConversionView {

    static func createLabel(alignment: NSTextAlignment = .left, fontSize: CGFloat = 12, text: String = "") -> UILabel {
        let label = UILabel()
        label.text = text
        label.textAlignment = alignment
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: fontSize)
        label.textColor = .colorGrayPrimary
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }

    static func createSeparator() -> UIView {
        let view = UIView()
        view.backgroundColor = .colorGrayLighten60
        view.translatesAutoresizingMaskIntoConstraints = false
        view.widthAnchor.constraint(equalToConstant: 1).isActive = true
        return view
    }

    static func createCardView(hidden: Bool = false) -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setCardLayout()
        view.isHidden = hidden
        return view
    }
}


// MARK: - Setup View
private extension ConversionView {

    func setupView() {
        setupScrollView()
//        setupUpdateDate()
//        setupFromSection()
//        setupToSection()
//        setupConversionStack()
    }

    func setupScrollView() {
        addSubview(scrollView)
        scrollView.addSubview(containerView)
        containerView.addSubview(updateDateLabel)
        containerView.addSubview(fromTitleLabel)
        containerView.addSubview(fromView)
        fromView.addSubview(fromCurrencyNameLabel)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),

            containerView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            containerView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            updateDateLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            updateDateLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            updateDateLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            
            fromTitleLabel.topAnchor.constraint(equalTo: updateDateLabel.topAnchor, constant: 32),
            fromTitleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 32),
            fromTitleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -32),
            
            fromView.topAnchor.constraint(equalTo: fromTitleLabel.bottomAnchor, constant: 3),
            fromView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 32),
            fromView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -32),
            fromView.heightAnchor.constraint(equalToConstant: 80),
            
            fromCurrencyNameLabel.centerYAnchor.constraint(equalTo: fromView.centerYAnchor),
            fromCurrencyNameLabel.centerXAnchor.constraint(equalTo: fromView.centerXAnchor),
            fromCurrencyNameLabel.topAnchor.constraint(equalTo: fromView.topAnchor, constant: 16)
            
            
        ])
    }

//    func setupUpdateDate() {
//        containerView.addSubview(updateDateLabel)
//        NSLayoutConstraint.activate([
//            updateDateLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
//            updateDateLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
//            updateDateLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16)
//        ])
//    }

    func setupFromSection() {
        setupCurrencySection(
            title: "De:",
            view: fromView,
            codeLabel: fromCurrencyCodeLabel,
            nameLabel: fromCurrencyNameLabel,
            separator: fromSeparatorView,
            containerTop: updateDateLabel.bottomAnchor
        )
    }

    func setupToSection() {
        setupCurrencySection(
            title: "Para:",
            view: toView,
            codeLabel: toCurrencyCodeLabel,
            nameLabel: toCurrencyNameLabel,
            separator: toSeparatorView,
            containerTop: fromView.bottomAnchor
        )
    }

    func setupConversionStack() {
        containerView.addSubview(conversionStackView)

        // Valor
        let valueTitle = ConversionView.createLabel(fontSize: 15, text: "Insira um valor:")
        let valueContainer = UIStackView(arrangedSubviews: [valueTitle, valueView])
        valueContainer.axis = .vertical
        valueContainer.spacing = 5

        valueView.addSubview(valueTextField)
        NSLayoutConstraint.activate([
            valueTextField.topAnchor.constraint(equalTo: valueView.topAnchor),
            valueTextField.bottomAnchor.constraint(equalTo: valueView.bottomAnchor),
            valueTextField.leadingAnchor.constraint(equalTo: valueView.leadingAnchor, constant: 20),
            valueTextField.trailingAnchor.constraint(equalTo: valueView.trailingAnchor, constant: -20),
            valueView.heightAnchor.constraint(equalToConstant: 50)
        ])

        // Resultado
        let resultTitle = ConversionView.createLabel(fontSize: 15, text: "Resultado:")
        let resultContainer = UIStackView(arrangedSubviews: [resultTitle, resultView])
        resultContainer.axis = .vertical
        resultContainer.spacing = 5

        resultView.addSubview(resultLabel)
        NSLayoutConstraint.activate([
            resultLabel.topAnchor.constraint(equalTo: resultView.topAnchor, constant: 10),
            resultLabel.bottomAnchor.constraint(equalTo: resultView.bottomAnchor, constant: -10),
            resultLabel.leadingAnchor.constraint(equalTo: resultView.leadingAnchor, constant: 32),
            resultLabel.trailingAnchor.constraint(equalTo: resultView.trailingAnchor, constant: -32)
        ])

        // Add ao stack principal
        conversionStackView.addArrangedSubview(valueContainer)
        conversionStackView.addArrangedSubview(resultContainer)

        NSLayoutConstraint.activate([
            conversionStackView.topAnchor.constraint(equalTo: toView.bottomAnchor, constant: 24),
            conversionStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 32),
            conversionStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -32),
            conversionStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -30)
        ])
    }

    func setupCurrencySection(
        title: String,
        view: UIView,
        codeLabel: UILabel,
        nameLabel: UILabel,
        separator: UIView,
        containerTop: NSLayoutYAxisAnchor
    ) {
        let titleLabel = ConversionView.createLabel(fontSize: 15, text: title)

        let hStack = UIStackView(arrangedSubviews: [codeLabel, separator, nameLabel])
        hStack.axis = .horizontal
        hStack.spacing = 10
        hStack.alignment = .center
        hStack.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(hStack)
        NSLayoutConstraint.activate([
            hStack.topAnchor.constraint(equalTo: view.topAnchor, constant: 9),
            hStack.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -9),
            hStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            hStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            view.heightAnchor.constraint(equalToConstant: 80)
        ])

        let section = UIStackView(arrangedSubviews: [titleLabel, view])
        section.axis = .vertical
        section.spacing = 3
        section.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(section)

        NSLayoutConstraint.activate([
            section.topAnchor.constraint(equalTo: containerTop, constant: 24),
            section.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 32),
            section.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -32)
        ])
    }
}

//
//  ConversionPresenter.swift
//  CoinConversion
//
//  Created by Ronilson Batista on 18/07/20.
//  Copyright © 2020 Ronilson Batista. All rights reserved.
//

import UIKit

// MARK: - Presenting
protocol ConversionPresenting {
    var delegate: ConversionPresenterDelegate? { get set }
    func formatCurrency(currencyCode: String, amount: String) -> String?
    func fetchQuotes(isRefresh: Bool)
    func fetchConvert(fromCode: String, toCode: String, value: String)
    func fetchCurrencies(_ conversion: Conversion)
}

// MARK: - Delegate
protocol ConversionPresenterDelegate: AnyObject {
    func didStartLoading()
    func didHideLoading()
    func didUpdateDate(with date: String)
    func didReloadData(code: String, name: String, conversion: Conversion)
    func didReloadResult(with value: String, color: UIColor)
    func didFail(with title: String, message: String, buttonTitle: String, noConnection: Bool, dataSave: Bool)
}

// MARK: - Main
final class ConversionPresenter: ConversionPresenting {
    
    weak var delegate: ConversionPresenterDelegate?
    
    private var interactor: CurrenciesConversionInteracting
    private let dataManager: DataManager
    private let router: ConversionRouting
    private var conversionModel: ConversionViewModel?
    
    init(
        interactor: CurrenciesConversionInteracting,
        dataManager: DataManager,
        router: ConversionRouting
    ) {
        self.interactor = interactor
        self.dataManager = dataManager
        self.router = router
        
        self.interactor.delegate = self
        self.dataManager.delegate = self
        self.router.delegate = self
    }
    
    func fetchQuotes(isRefresh: Bool) {
        guard !hasDatabaseQuotes() || isRefresh else { return }
        delegate?.didStartLoading()
        interactor.fetchQuotes()
    }
    
    func fetchConvert(fromCode: String, toCode: String, value: String) {
        guard let result = convertCurrency(fromCode: fromCode, toCode: toCode, value: value, conversion: conversionModel?.currencies) else {
            return didConversionFail()
        }
        delegate?.didReloadResult(with: result, color: .colorSpringGreen)
    }
    
    func fetchCurrencies(_ conversion: Conversion) {
        router.navigateToListCurrencies(using: conversion)
    }
    
    func formatCurrency(currencyCode code: String, amount: String) -> String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale.availableIdentifiers
            .map { Locale(identifier: $0) }
            .first { ($0 as NSLocale).object(forKey: .currencyCode) as? String == code }
        
        let value = NSString(string: amount).doubleValue / 100
        return formatter.string(from: NSNumber(value: value))
    }
}

// MARK: - Private
private extension ConversionPresenter {
    
    private func hasDatabaseQuotes() -> Bool {
        guard dataManager.hasDatabaseQuotes() else { return false }
        guard let model = dataManager.fetchDatabaseQuotes() else { return false }
        
        conversionModel = model
        delegate?.didUpdateDate(with: model.date.getDateStringFromUTC())
        return true
    }
    
    private func convertCurrency(fromCode: String, toCode: String, value: String, conversion: [ConversionCurrencyViewModel]?) -> String? {
        guard
            let value = Double(value),
            let conversion = conversion,
            let from = returnQuotes(conversion, base: "USD", code: fromCode),
            let to = returnQuotes(conversion, base: "USD", code: toCode),
            let result = formatCurrency(currencyCode: toCode, amount: String(value * to.quotes / from.quotes))
        else {
            return value.isEmpty ? "-" : nil
        }
        return result
    }
    
    private func didConversionFail() {
        delegate?.didReloadResult(
            with: "Ops... Aconteceu um erro na conversão",
            color: .colorDarkRed
        )
    }
    
    private func handleQuotes(_ quotes: CurrenciesConversion) -> ConversionViewModel {
        let currencies = quotes.quotes.map {
            ConversionCurrencyViewModel(code: $0.key, quotes: $0.value)
        }
        return ConversionViewModel(date: quotes.timestamp, currencies: currencies)
    }
    
    private func handleError(_ error: ServiceError) {
        switch error.type {
        case .noConnection:
            if hasDatabaseQuotes() {
                delegate?.didFail(
                    with: "Problema na conexão",
                    message: "Não conseguimos atualizar as cotas. Continue navegando com os dados da última atualização.",
                    buttonTitle: "OK",
                    noConnection: true,
                    dataSave: true
                )
            } else {
                delegate?.didFail(
                    with: "Problema na conexão",
                    message: "Encontramos problemas com a conexão. Tente ajustá-la para continuar navegando.",
                    buttonTitle: "Tentar novamente",
                    noConnection: true,
                    dataSave: false
                )
            }
        default:
            if hasDatabaseQuotes() {
                delegate?.didFail(
                    with: "Erro encontrado",
                    message: "Não conseguimos atualizar as cotas. Continue navegando com os dados da última atualização.",
                    buttonTitle: "OK",
                    noConnection: false,
                    dataSave: false
                )
            } else {
                delegate?.didFail(
                    with: "Erro encontrado",
                    message: "Desculpe-nos pelo erro. \nMotivo: \(error.type.description)",
                    buttonTitle: "OK",
                    noConnection: false,
                    dataSave: false
                )
            }
        }
    }
    
    private func returnQuotes(_ conversion: [ConversionCurrencyViewModel], base: String, code: String) -> ConversionCurrencyViewModel? {
        return conversion.first { $0.code == base + code }
    }
}

// MARK: - Interactor Delegate
extension ConversionPresenter: CurrenciesConversionInteractorDelegate {
    func quotesFetched(with quotes: CurrenciesConversion) {
        delegate?.didHideLoading()
        
        guard quotes.success else {
            handleError(.init(type: .noAuthorized))
            return
        }
        
        conversionModel = handleQuotes(quotes)
        delegate?.didUpdateDate(with: conversionModel?.date.getDateStringFromUTC() ?? "-")
        dataManager.syncQuotes(with: conversionModel!)
    }
    
    func handleFailure(with serviceError: ServiceError) {
        delegate?.didHideLoading()
        handleError(serviceError)
    }
}

// MARK: - Router Delegate
extension ConversionPresenter: ConversionRouterDelegate {
    func currencyFetched(_ code: String, _ name: String, _ conversion: Conversion) {
        delegate?.didReloadData(code: code, name: name, conversion: conversion)
    }
}

// MARK: - Data Manager Delegate
extension ConversionPresenter: DataManagerDelegate {
    func dataManager(didFailWith error: PersistenceError) {
        delegate?.didFail(
            with: "Erro encontrado",
            message: "Não conseguimos salvar seus dados para uso off-line.\nMotivo: \(error)",
            buttonTitle: "Continuar Navegando",
            noConnection: false,
            dataSave: false
        )
    }
}

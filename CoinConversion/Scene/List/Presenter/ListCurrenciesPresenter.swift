//
//  ListCurrenciesPresenter.swift
//  CoinConversion
//
//  Created by Ronilson Batista on 19/07/20.
//  Copyright © 2020 Ronilson Batista. All rights reserved.
//

import Foundation

// MARK: - ListCurrenciesPresenting
protocol ListCurrenciesPresenting: AnyObject {
    var delegate: ListCurrenciesPresenterDelegate? { get set }
    var listCurrencies: [ListCurrenciesModel] { get }
    var isSorted: Bool { get }
    
    func fetchListCurrencies(isRefresh: Bool)
    func searchListCurrencies(with text: String)
    func fetchListSorted(by type: SortType, currencies: [ListCurrenciesModel])
    func chooseCurrency(code: String, name: String)
}

// MARK: - ListCurrenciesPresenterDelegate
protocol ListCurrenciesPresenterDelegate: AnyObject {
    func didStartLoading()
    func didHideLoading()
    func didReloadData()
    func didFail(
        with title: String,
        message: String,
        buttonTitle: String,
        noConnection: Bool,
        dataSave: Bool
    )
}

// MARK: - Main
final class ListCurrenciesPresenter:  ListCurrenciesPresenting {
    weak var delegate: ListCurrenciesPresenterDelegate?
    
    private var interactor: ListCurrenciesInteracting
    private let router: ListCurrenciesRouting
    private let dataManager: DataManager
    private let conversion: Conversion
    
    private var allCurrencies: [ListCurrenciesModel] = []
    private(set) var listCurrencies: [ListCurrenciesModel] = []
    private(set) var isSorted = false
    
    // MARK: - Inicializador
    init(
        interactor: ListCurrenciesInteracting,
        conversion: Conversion,
        dataManager: DataManager,
        router: ListCurrenciesRouting
    ) {
        self.interactor = interactor
        self.conversion = conversion
        self.dataManager = dataManager
        self.router = router
        
        self.interactor.delegate = self
        self.dataManager.delegate = self
    }
    
    // MARK: - Métodos públicos
    func fetchListCurrencies(isRefresh: Bool) {
        if !loadFromDatabase() || isRefresh {
            delegate?.didStartLoading()
            isSorted = false
            interactor.fetchListCurrencies()
        }
    }
    
    func searchListCurrencies(with text: String) {
        if text.isEmpty {
            listCurrencies = allCurrencies
        } else {
            listCurrencies = allCurrencies.filter {
                $0.name.localizedCaseInsensitiveContains(text) ||
                $0.code.localizedCaseInsensitiveContains(text)
            }
        }
        
        DispatchQueue.main.async {
            self.delegate?.didReloadData()
        }
    }
    
    func fetchListSorted(by type: SortType, currencies: [ListCurrenciesModel]) {
        switch type {
        case .name:
            listCurrencies = currencies.sorted { $0.name < $1.name }
        case .code:
            listCurrencies = currencies.sorted { $0.code < $1.code }
        }
        isSorted = true
        
        DispatchQueue.main.async {
            self.delegate?.didReloadData()
        }
    }
    
    func chooseCurrency(code: String, name: String) {
        router.dismissToConversion(code: code, name: name, conversion: conversion)
    }
    
    // MARK: - Métodos privados
    private func loadFromDatabase() -> Bool {
        guard dataManager.hasDatabaseCurrencies() else {
            return false
        }
        
        let currencies = dataManager.fetchDatabaseCurrencies()
            .sorted(by: { $0.name < $1.name })
        
        allCurrencies = currencies
        listCurrencies = currencies
        isSorted = false
        
        return true
    }
    
    private func handleListCurrencies(_ listCurrencies: ListCurrencies) -> [ListCurrenciesModel] {
        return listCurrencies.currencies
            .map { ListCurrenciesModel(name: $0.value, code: $0.key) }
            .sorted { $0.name < $1.name }
    }
    
    private func handleError(_ error: ServiceError) {
        delegate?.didHideLoading()
        
        let hasLocalData = loadFromDatabase()
        
        if error.type == .noConnection {
            if hasLocalData {
                showError(
                    title: "Problema na conexão",
                    message: """
                        Encontramos problemas com a conexão.
                        Não conseguimos atualizar as cotas. Continue navegando com os dados da última atualização.
                    """,
                    buttonTitle: "OK",
                    noConnection: true,
                    dataSave: true
                )
                return
            }
            
            showError(
                title: "Problema na conexão",
                message: """
                    Encontramos problemas com a conexão.
                    Tente ajustá-la para continuar navegando.
                """,
                buttonTitle: "Tentar novamente",
                noConnection: true,
                dataSave: false
            )
            return
        }
        
        if hasLocalData {
            showError(
                title: "Erro encontrado",
                message: """
                    Desculpe-nos pelo erro.
                    Não conseguimos atualizar as cotas. Continue navegando com os dados da última atualização.
                """,
                buttonTitle: "OK",
                noConnection: false,
                dataSave: false
            )
            return
        }
        
        showError(
            title: "Erro encontrado",
            message: """
                Desculpe-nos pelo erro. Iremos contorná-lo o mais rápido possível.
                Motivo: \(error.type.description)
            """,
            buttonTitle: "OK",
            noConnection: false,
            dataSave: false
        )
    }
    
    private func showError(
        title: String,
        message: String,
        buttonTitle: String,
        noConnection: Bool,
        dataSave: Bool
    ) {
        delegate?.didFail(
            with: title,
            message: message,
            buttonTitle: buttonTitle,
            noConnection: noConnection,
            dataSave: dataSave
        )
    }
}

// MARK: - ListCurrenciesInteractorDelegate
extension ListCurrenciesPresenter: ListCurrenciesInteractorDelegate {
    func currenciesFetched(with listCurrencies: ListCurrencies) {
        delegate?.didHideLoading()
        
        guard listCurrencies.success else {
            handleError(.init(type: .noAuthorized))
            return
        }
        
        let parsed = handleListCurrencies(listCurrencies)
        allCurrencies = parsed
        self.listCurrencies = parsed
        dataManager.syncCurrencies(parsed)
        
        DispatchQueue.main.async {
            self.delegate?.didReloadData()
        }
    }
    
    func handleFailure(with serviceError: ServiceError) {
        handleError(serviceError)
    }
}

// MARK: - DataManagerDelegate
extension ListCurrenciesPresenter: DataManagerDelegate {
    func dataManager(didFailWith error: PersistenceError) {
        delegate?.didFail(
            with: "Erro ao salvar dados",
            message: """
                Desculpe-nos pelo erro.
                Não conseguimos salvar seus dados para uso off-line.
                Motivo: \(error)
            """,
            buttonTitle: "Continuar",
            noConnection: false,
            dataSave: false
        )
    }
}

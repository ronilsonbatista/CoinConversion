//
//  ListCurrenciesModule.swift
//  CoinConversion
//
//  Created by Ronilson Batista on 20/07/25.
//  Copyright © 2025 Ronilson Batista. All rights reserved.
//

struct ListCurrenciesModule {
    static func build(conversion: Conversion, delegate: ListCurrenciesRouterDelegate?) -> UIViewController {
        let router = ListCurrenciesRouter(delegate: delegate)
        let interactor = ListCurrenciesInteractor()
        let presenter = ListCurrenciesPresenter(
            interactor: interactor,
            conversion: conversion,
            dataManager: DataManager(),
            router: router
        )
        let viewController = ListCurrenciesViewController(presenter: presenter)
        return viewController
    }
}

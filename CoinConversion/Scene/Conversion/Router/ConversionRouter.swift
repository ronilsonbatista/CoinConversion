//
//  ConversionRouter.swift
//  CoinConversion
//
//  Created by Ronilson Batista on 18/07/20.
//  Copyright © 2020 Ronilson Batista. All rights reserved.
//

import Foundation
import UIKit

// MARK: - ConversionRouterDelegate
protocol ConversionRouterDelegate: AnyObject {
    func currencyFetched(_ code: String, _ name: String, _ conversion: Conversion)
}

// MARK: - Main
class ConversionRouter {
    
    private let window: UIWindow
    weak var delegate: ConversionRouterDelegate?
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func createConversionScreen() {
        let viewController = ConversionViewController(
            presenter: ConversionPresenter(
                interactor: CurrenciesConversionInteractor(),
                dataManager: DataManager(),
                router: self
        ))
        
        let navigationController = UINavigationController(
            rootViewController: viewController
        )
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
    
    func enqueueListCurrencies(_ conversion: Conversion) {
        let listCurrenciesViewController = ListCurrenciesModule.build(
            conversion: conversion,
            delegate: self
        )

        if let topViewController = UIApplication.shared.topMostViewController() {
            topViewController.navigationController?.pushViewController(listCurrenciesViewController, animated: true)
        }
    }
}

// MARK: - ListCurrenciesRouterDelegate
extension ConversionRouter: ListCurrenciesRouterDelegate {
    func currencyFetched(code: String, name: String, conversion: Conversion) {
        delegate?.currencyFetched(code, name, conversion)
    }
}

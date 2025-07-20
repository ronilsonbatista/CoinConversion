//
//  PersistenceError.swift
//  CoinConversion
//
//  Created by Ronilson Batista on 20/07/25.
//  Copyright © 2025 Ronilson Batista. All rights reserved.
//

enum PersistenceError: Error {
    case savingFailed(Error)
    case deletingFailed(Error)
    case fetchingFailed(Error)
    case noDataFound
}

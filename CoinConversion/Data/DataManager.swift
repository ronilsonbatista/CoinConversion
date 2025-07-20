//
//  DataManager.swift
//  CoinConversion
//
//  Created by Ronilson Batista on 22/07/20.
//  Copyright © 2020 Ronilson Batista. All rights reserved.
//

import CoreData

// MARK: - DataManagerDelegate
protocol DataManagerDelegate: AnyObject {
    func dataManager(didFailWith error: PersistenceError)
}

// MARK: Main
final class DataManager {
    
    weak var delegate: DataManagerDelegate?
    
    private let coreDataStack: CoreDataStack
    private let context: NSManagedObjectContext
    
    init(coreDataStack: CoreDataStack = .shared) {
        self.coreDataStack = coreDataStack
        self.context = coreDataStack.persistentContainer.viewContext
    }
}

// MARK: - Quotes
extension DataManager {
    func syncQuotes(with viewModel: ConversionViewModel) {
        deleteAllQuotes() 
        saveQuotes(with: viewModel)
    }
    
    func hasDatabaseQuotes() -> Bool {
        !fetchQuotesEntities().isEmpty
    }
    
    func fetchDatabaseQuotes() -> ConversionViewModel? {
        let entities = fetchQuotesEntities()
        guard let first = entities.first else { return nil }
        
        let conversions = entities.map {
            ConversionCurrenciesViewModel(code: $0.code ?? "", quotes: $0.quotes)
        }
        return ConversionViewModel(date: first.timestamp, conversion: conversions)
    }
}

// MARK: - Private / Quotes
private extension DataManager {
    func saveQuotes(with viewModel: ConversionViewModel) {
        viewModel.conversion?.forEach { quoteVM in
            let entity = ConversionEntity(context: context)
            entity.code = quoteVM.code
            entity.quotes = quoteVM.quotes ?? 0.0
            entity.timestamp = viewModel.date ?? 0
        }
        saveContext()
    }
    
    func deleteAllQuotes() {
        deleteAllData(for: ConversionEntity.self)
    }
    
    func fetchQuotesEntities() -> [ConversionEntity] {
        fetchEntities(ConversionEntity.self)
    }
}

// MARK: - Currencies (Public)
extension DataManager {
    func syncCurrencies(_ currencies: [ListCurrenciesModel]) {
        deleteAllCurrencies()
        saveCurrencies(with: currencies)
    }
    
    func hasDatabaseCurrencies() -> Bool {
        !fetchCurrenciesEntities().isEmpty
    }
    
    func fetchDatabaseCurrencies() -> [ListCurrenciesModel] {
        fetchCurrenciesEntities().map {
            ListCurrenciesModel(name: $0.name ?? "", code: $0.code ?? "")
        }
    }
}

// MARK: - Private / Currencies
private extension DataManager {
    func saveCurrencies(with currencies: [ListCurrenciesModel]) {
        currencies.forEach { model in
            let entity = CurrenciesEntity(context: context)
            entity.code = model.code
            entity.name = model.name
        }
        saveContext()
    }
    
    func deleteAllCurrencies() {
        deleteAllData(for: CurrenciesEntity.self)
    }
    
    func fetchCurrenciesEntities() -> [CurrenciesEntity] {
        fetchEntities(CurrenciesEntity.self)
    }
}


// MARK: - Shared Utilities
private extension DataManager {
    func deleteAllData<T: NSManagedObject>(for entityType: T.Type) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: entityType))
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(deleteRequest)
        } catch {
            delegate?.dataManager(didFailWith: .deletingFailed(error))
        }
    }
    
    func fetchEntities<T: NSManagedObject>(_ entityType: T.Type) -> [T] {
        let request = NSFetchRequest<T>(entityName: String(describing: entityType))
        do {
            return try context.fetch(request)
        } catch {
            delegate?.dataManager(didFailWith: .fetchingFailed(error))
            return []
        }
    }
    
    func saveContext() {
        guard context.hasChanges else { return }
        do {
            try context.save()
        } catch {
            delegate?.dataManager(didFailWith: .savingFailed(error))
        }
    }
}

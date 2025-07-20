//
//  CoreDataStack.swift
//  CoinConversion
//
//  Created by Ronilson Batista on 22/07/20.
//  Copyright © 2020 Ronilson Batista. All rights reserved.
//

import CoreData


// MARK: - Main
final class CoreDataStack {
    
    private init() {}
    static let shared = CoreDataStack()
        
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CoinConversion")
        
        container.loadPersistentStores { _, error in
            if let error = error {
                print("Failed to load persistent store: \(error.localizedDescription)")
            }
        }
        
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        container.viewContext.undoManager = nil
        container.viewContext.shouldDeleteInaccessibleFaults = true
        container.viewContext.automaticallyMergesChangesFromParent = true
        
        return container
    }()
    
    var viewContext: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    func newBackgroundContext() -> NSManagedObjectContext {
        persistentContainer.newBackgroundContext()
    }
    
    func saveContext() throws {
        let contextToSave = persistentContainer.viewContext
        guard contextToSave.hasChanges else { return }
        
        do {
            try contextToSave.save()
        } catch {
            throw PersistenceError.savingFailed(error)
        }
    }
}

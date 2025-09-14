//
//  CoreDataStack.swift
//  Core
//
//  Created by Yudi Marta on 13/05/25.
//

import CoreData

public final class CoreDataStack: @unchecked Sendable {
    public static let shared = CoreDataStack()
    
    lazy var gamePersistentContainer: NSPersistentContainer = {
        let bundle = Bundle.module
        if let modelURL = bundle.url(forResource: "GameData", withExtension: "momd"),
           let model = NSManagedObjectModel(contentsOf: modelURL) {
            let container = NSPersistentContainer(name: "GameData", managedObjectModel: model)
            return configureContainer(container)
        } else {
            // Fallback to default initialization
            let container = NSPersistentContainer(name: "GameData")
            return configureContainer(container)
        }
    }()
    
    private func configureContainer(_ container: NSPersistentContainer) -> NSPersistentContainer {
        if let description = container.persistentStoreDescriptions.first {
            description.shouldMigrateStoreAutomatically = true
            description.shouldInferMappingModelAutomatically = true
        }
        
        container.loadPersistentStores { _, error in
            guard error == nil else {
                fatalError("Unresolved error \(error!)")
            }
        }
        container.viewContext.automaticallyMergesChangesFromParent = false
        container.viewContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
        container.viewContext.shouldDeleteInaccessibleFaults = true
        container.viewContext.undoManager = nil
        
        return container
    }
    

    
    private func gameTaskContext() -> NSManagedObjectContext {
        let taskContext = gamePersistentContainer.newBackgroundContext()
        taskContext.undoManager = nil
        
        taskContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
        return taskContext
    }
}

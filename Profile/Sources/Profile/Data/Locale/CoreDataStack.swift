//
//  CoreDataStack.swift
//  Profile
//
//  Created by Yudi Marta on 13/09/25.
//

import CoreData

public final class CoreDataStack: @unchecked Sendable {
    public static let shared = CoreDataStack()
    
    lazy var profilePersistentContainer: NSPersistentContainer = {
        let bundle = Bundle.module
        if let modelURL = bundle.url(forResource: "ProfileData", withExtension: "momd"),
           let model = NSManagedObjectModel(contentsOf: modelURL) {
            let container = NSPersistentContainer(name: "ProfileData", managedObjectModel: model)
            return configureContainer(container)
        } else {
            let container = NSPersistentContainer(name: "ProfileData")
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
    

    
    private func profileTaskContext() -> NSManagedObjectContext {
        let taskContext = profilePersistentContainer.newBackgroundContext()
        taskContext.undoManager = nil
        
        taskContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
        return taskContext
    }
}

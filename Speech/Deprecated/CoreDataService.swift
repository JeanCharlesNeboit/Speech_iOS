//
//  CoreData.swift
//  Speech
//
//  Created by Jean-Charles Neboit on 12/10/2021.
//

import CoreData

class CoreDataService {
    // MARK: - Shared container
    private lazy var managedObjectModel: NSManagedObjectModel? = {
        guard let modelURL = Bundle.main.url(forResource: "Speech", withExtension: "momd") else { return nil }
        return NSManagedObjectModel(contentsOf: modelURL)
    }()
    
    lazy var secureAppGroupPersistentStoreURL: URL? = {
        let fileManager = FileManager.default
        guard let directory = fileManager.containerURL(forSecurityApplicationGroupIdentifier: "group.com.Jean-Charles.Speech") else { return nil }
        return directory.appendingPathComponent("Speech.sqlite")
    }()
    
    private lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
        guard let managedObjectModel = managedObjectModel,
              let secureAppGroupPersistentStoreURL = secureAppGroupPersistentStoreURL else { return nil }
        
        let storeCoordinator: NSPersistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
        let storeURL = secureAppGroupPersistentStoreURL
        do {
            try storeCoordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeURL, options: [NSMigratePersistentStoresAutomaticallyOption: true, NSInferMappingModelAutomaticallyOption: true])
        } catch let error {
            log.error(error)
        }
        return storeCoordinator
    }()
    
    private(set) lazy var managedObjectContext: NSManagedObjectContext = {
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
}

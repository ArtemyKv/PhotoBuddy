//
//  CoreDataStack.swift
//  PhotoBuddy
//
//  Created by Artem Kvashnin on 23.11.2022.
//
import CoreData

class CoreDataStack {
    static var shared = CoreDataStack(modelName: "PhotoBuddy")
    
    private let modelName: String
    
    lazy var managedContext: NSManagedObjectContext = {
        return self.storeContainer.viewContext
    }()
    
    private init(modelName: String) {
        self.modelName = modelName
    }
    
    lazy private var storeContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: self.modelName)
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                print("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    func saveContext() {
        guard managedContext.hasChanges else { return }
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Unresolved error \(error), \(error.userInfo)")
        }
    }
}

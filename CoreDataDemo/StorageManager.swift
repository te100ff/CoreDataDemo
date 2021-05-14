//
//  StorageManager.swift
//  CoreDataDemo
//
//  Created by Stanislav Testov on 12.05.2021.
//

import CoreData

class StorageManager {
    static let shared = StorageManager()
    
    
    // MARK: - Core Data stack
    private let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CoreDataDemo")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    private let context: NSManagedObjectContext
    
    private init() {
        context = persistentContainer.viewContext
    }
    
    // MARK: - Core Data Saving support
    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func fetchData() -> [Task] {
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        
        do {
            let taskList = try context.fetch(fetchRequest)
            return taskList
        } catch let error {
            print(error)
            return []
        }
        
    }
    
    func createAndSaveTaskObject(_ taskname: String) -> Task? {
        guard let entityDescription = NSEntityDescription.entity(forEntityName: "Task", in: context) else { return nil }
        guard let task = NSManagedObject(entity: entityDescription, insertInto: context) as? Task else { return nil }
        task.title = taskname
        saveContext()
        return task
    }
    
    func edit(_ task: Task, newTitle: String) {
        task.title = newTitle
        saveContext()
    }
    
    func deleteTaskObject(_ task: Task) {
        context.delete(task)
        saveContext()
    }
  
   
    
}

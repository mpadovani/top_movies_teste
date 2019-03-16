//
//  CoreDataStackSingleton.swift
//  top_games
//
//  Created by Mateus Padovani on 10/03/19.
//  Copyright © 2019 Mateus Padovani. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStackSingleton {
    
    static var shared = CoreDataStackSingleton()
    
    private init() {}
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "top_movies_teste")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
}

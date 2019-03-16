//
//  MovieStoreDataStore.swift
//  top_games
//
//  Created by Mateus Padovani on 10/03/19.
//  Copyright © 2019 Mateus Padovani. All rights reserved.
//

import CoreData

class MovieStoreDataStore {
    let context: NSManagedObjectContext
    
    init() {
        self.context = CoreDataStackSingleton.shared.persistentContainer.viewContext
    }
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func fetchMovieStore(offset: Int, success: @escaping ([Movies]) -> Void, failure: @escaping (Error) -> Void, completion: @escaping () -> Void) {
        let request = NSFetchRequest<MovieStore>(entityName: "MovieStore")
        request.fetchLimit = 20
        request.fetchOffset = offset
        let asyncFetchRequest = NSAsynchronousFetchRequest<MovieStore>(fetchRequest: request) { asyncFetchResult in
            DispatchQueue.main.async {
                if let result = asyncFetchResult.finalResult {
                    let movies = result.map { Movies(result: $0) }
                    success(movies)
                } else if let error = asyncFetchResult.operationError {
                    failure(error)
                }
                completion()
            }
        }
        context.perform { [weak self] in
            do {
                try self?.context.execute(asyncFetchRequest)
            } catch {
                failure(error)
            }
            completion()
        }
    }
    
    func update(discover: Movies, success: () -> Void, failure: (Error) -> Void, completion: () -> Void) {
        let genres = discover.genres?.compactMap({$0.name}) ?? []
        
        let batchRequest = NSBatchUpdateRequest(entityName: "MovieStore")
        let predicate = NSPredicate(format: "id == %@", discover.id.description)
        batchRequest.predicate = predicate
        batchRequest.propertiesToUpdate = ["isDetails": true,
                                           "genres": genres,
                                           "status": discover.status ?? "",
                                           "homepage": discover.homepage ?? ""]
        batchRequest.resultType = .updatedObjectIDsResultType
        do {
            let batchUpdateResult = try context.execute(batchRequest) as! NSBatchUpdateResult
            let objectIDs = batchUpdateResult.result as! [NSManagedObjectID]
            
            objectIDs.forEach { (object) in
                let managedObject = context.object(with: object)
                context.refresh(managedObject, mergeChanges: false)
            }
            
            success()
        } catch {
            failure(error)
        }
        completion()
    }
    
    func deleteAll(success: () -> Void, failure: (Error) -> Void, completion: () -> Void) {
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "MovieStore")
        let request = NSBatchDeleteRequest(fetchRequest: fetch)
        
        do {
            try context.execute(request)
            try context.save()
            success()
        } catch {
            failure(error)
        }
        completion()
    }
    
    func save(discover: [Movies], success: () -> Void, failure: (Error) -> Void, completion: () -> Void) {
        discover.forEach { discover in
            let movieStore = MovieStore(context: context)
            movieStore.id = Int32(discover.id)
            movieStore.title = discover.title
            movieStore.posterPath = discover.posterPath
            movieStore.releaseDate = discover.releaseDate
            movieStore.overview = discover.overview
            movieStore.homepage = discover.homepage
            movieStore.genres = []
            movieStore.status = discover.status
            movieStore.isDetails = false
        }
        do {
            try context.save()
            success()
        } catch {
            failure(error)
        }
        completion()
    }

    
}

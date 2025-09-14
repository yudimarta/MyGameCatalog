//
//  GetGamesLocaleDataSource.swift
//  Home
//
//  Created by Yudi Marta on 13/05/25.
//
import Foundation
import CoreData
import UIKit
import Combine
import Core

public struct GetGamesLocaleDataSource : LocaleDataSource {
    
    public typealias Request = GameModuleEntity

    public typealias Response = GameModuleEntity
    
    public init() {}
    
    public func list() -> AnyPublisher<[GameModuleEntity], Error> {
        return Future<[GameModuleEntity], Error> { completion in
            let taskContext = CoreDataStack.shared.gamePersistentContainer.newBackgroundContext()
            taskContext.perform {
                let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Favorites")
                do {
                    let results = try taskContext.fetch(fetchRequest)
                    var games: [GameModuleEntity] = []
                    for result in results {
                        if let id = result.value(forKey: "id") as? Int,
                           let title = result.value(forKey: "title") as? String,
                           let rating = result.value(forKey: "rating") as? Double,
                           let releaseDate = result.value(forKey: "releaseDate") as? String,
                           let platforms = result.value(forKey: "platforms") as? [String],
                           let genres = result.value(forKey: "genres") as? [String],
                           let screenshotURLs = result.value(forKey: "screenshotURLs") as? [String],
                           let posterURLString = result.value(forKey: "posterUrl") as? String,
                           let posterUrl = URL(string: posterURLString) {
                            let game = GameModuleEntity(
                                id: id,
                                title: title,
                                rating: rating,
                                releaseDate: releaseDate,
                                platforms: platforms,
                                genres: genres,
                                screenshotURLs: screenshotURLs,
                                posterUrl: posterUrl
                            )
                            
                            if let imageData = result.value(forKey: "image") as? Data {
                                game.image = UIImage(data: imageData)
                            }
                            
                            games.append(game)
                        }
                    }
                    completion(.success(games))
                } catch let error as NSError {
                    print("Could not fetch. \(error), \(error.userInfo)")
                    completion(.failure(DatabaseError.invalidInstance))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    public func add(entities: GameModuleEntity) -> AnyPublisher<Bool, Error> {
        return list()
            .tryMap { data -> Bool in
                guard !data.contains(where: { $0.id == entities.id }) else {
                    return false
                }

                let taskContext = CoreDataStack.shared.gamePersistentContainer.newBackgroundContext()
                var success = false

                try taskContext.performAndWait {
                    if let entity = NSEntityDescription.entity(forEntityName: "Favorites", in: taskContext) {
                        let favoriteData = NSManagedObject(entity: entity, insertInto: taskContext)
                        favoriteData.setValue(entities.id, forKey: "id")
                        favoriteData.setValue(entities.title, forKey: "title")
                        favoriteData.setValue(entities.rating, forKey: "rating")
                        favoriteData.setValue(entities.genres, forKey: "genres")
                        favoriteData.setValue(entities.platforms, forKey: "platforms")
                        favoriteData.setValue(entities.posterUrl.absoluteString, forKey: "posterUrl")
                        favoriteData.setValue(entities.releaseDate, forKey: "releaseDate")
                        favoriteData.setValue(entities.screenshotURLs, forKey: "screenshotURLs")
                        favoriteData.setValue(entities.posterUrl.absoluteString, forKey: "image")

                        do {
                            try taskContext.save()
                            success = true
                        } catch {
                            throw error
                        }
                    }
                }

                return success
            }
            .eraseToAnyPublisher()
    }
    
    public func delete(_ id: Int) -> AnyPublisher<Bool, Error> {
        return Future<Bool, Error> { completion in
            let taskContext = CoreDataStack.shared.gamePersistentContainer.newBackgroundContext()
            taskContext.perform {
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Favorites")
                fetchRequest.fetchLimit = 1
                fetchRequest.predicate = NSPredicate(format: "id == \(id)")

                let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
                batchDeleteRequest.resultType = .resultTypeCount

                do {
                    if let batchDeleteResult = try taskContext.execute(batchDeleteRequest) as? NSBatchDeleteResult {
                        if batchDeleteResult.result != nil {
                            completion(.success(true))
                        } else {
                            completion(.failure(NSError(domain: "", code: 1, userInfo: [NSLocalizedDescriptionKey: "Delete failed. No result."])))
                        }
                    } else {
                        completion(.failure(NSError(domain: "", code: 2, userInfo: [NSLocalizedDescriptionKey: "Failed to cast delete result."])))
                    }
                } catch {
                    completion(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}

//
//  ProfileLocaleDataSource.swift
//  Profile
//
//  Created by Yudi Marta on 13/09/25.
//

import Foundation
import Combine
import CoreData
import UIKit
import Core

public struct GetProfileLocaleDataSource: LocaleDataSource {
    public typealias Request = ProfileModuleEntity
    public typealias Response = ProfileModuleEntity
    
    public init() {}
    
    public func list() -> AnyPublisher<[ProfileModuleEntity], Error> {
        return Future<[ProfileModuleEntity], Error> { completion in
            let taskContext = CoreDataStack.shared.profilePersistentContainer.newBackgroundContext()
            taskContext.perform {
                let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Profile")
                do {
                    let results = try taskContext.fetch(fetchRequest)
                    var profiles: [ProfileModuleEntity] = []
                    for result in results {
                        if let name = result.value(forKey: "name") as? String,
                           let email = result.value(forKey: "email") as? String,
                           let photo = result.value(forKey: "photo") as? String,
                           let role = result.value(forKey: "role") as? [String],
                           let site = result.value(forKey: "site") as? String {
                            let profile = ProfileModuleEntity(
                                email: email,
                                name: name,
                                photo: photo,
                                role: role,
                                site: site
                            )
                            profiles.append(profile)
                        }
                    }
                    completion(.success(profiles))
                } catch let error as NSError {
                    print("Could not fetch. \(error), \(error.userInfo)")
                    completion(.failure(DatabaseError.invalidInstance))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    public func add(entities: ProfileModuleEntity) -> AnyPublisher<Bool, Error> {
        return Future<Bool, Error> { completion in
            let taskContext = CoreDataStack.shared.profilePersistentContainer.newBackgroundContext()
            taskContext.perform {
                if let entity = NSEntityDescription.entity(forEntityName: "Profile", in: taskContext) {
                    let profileData = NSManagedObject(entity: entity, insertInto: taskContext)
                    
                    profileData.setValue(entities.name, forKey: "name")
                    profileData.setValue(entities.email, forKey: "email")
                    profileData.setValue(entities.photo, forKey: "photo")
                    profileData.setValue(entities.role, forKey: "role")
                    profileData.setValue(entities.site, forKey: "site")
                    
                    do {
                        try taskContext.save()
                        completion(.success(true))
                    } catch {
                        completion(.failure(error))
                    }
                } else {
                    completion(.failure(DatabaseError.invalidInstance))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    public func delete(_ id: Int) -> AnyPublisher<Bool, Error> {
        return Just(false).setFailureType(to: Error.self).eraseToAnyPublisher()
    }
}

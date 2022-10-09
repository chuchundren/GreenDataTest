//
//  CoreDataStore.swift
//  GreenDataTest
//
//  Created by Dasha Palshau on 09.10.2022.
//

import Foundation
import CoreData

final class CoreDataStore {
    
    static let shared = CoreDataStore()
    
    private var bgContext: NSManagedObjectContext
    
    private init() {
        bgContext = CoreDataStore.persistentContainer.newBackgroundContext()
        bgContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    }
    
    static var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Model")

        container.loadPersistentStores { _, error in
            if let error = error {
                //TODO: - Add Error Handling
                fatalError("Unresolved error: \(error)")
            }
        }
        
        return container
    }()
    
    func cacheUsers(_ users: [RandomUser]) {
        users.forEach { user in
            let cdUser = CDRandomUser(context: bgContext)
            let name = Name(context: bgContext)
            let dateOfBirth = DateOfBirth(context: bgContext)
            let timezone = Timezone(context: bgContext)
            let location = Location(context: bgContext)
            let picture = Picture(context: bgContext)
            
            name.first = user.name.first
            name.last = user.name.last
            
            dateOfBirth.date = user.dateOfBirth.date
            dateOfBirth.age = Int16(user.dateOfBirth.age)
            
            timezone.offset = user.location.timezone.offset
            timezone.tzDescription = user.location.timezone.description
            
            location.timezone = timezone
            
            picture.large = user.picture.large
            picture.medium = user.picture.medium
            picture.thumbnail = user.picture.thumbnail
            
            cdUser.name = name
            cdUser.dateOfBirth = dateOfBirth
            cdUser.location = location
            cdUser.picture = picture
            cdUser.email = user.email
            cdUser.gender = user.gender.rawValue
            cdUser.uuid = user.login.uuid
        }
        
        save()
    }
    
    private func save() {
        if bgContext.hasChanges {
            do {
                try bgContext.save()
            } catch {
                fatalError("Unresolved error: \(error)")
            }
        }
    }
    
}

//
//  TrackerCategoryStore.swift
//  Tracker
//
//  Created by macOS on 27.04.2023.
//

import UIKit
import CoreData

final class TrackerCategoryStore: NSObject {
    
    var categories = [TrackerCategory]()
    private let context: NSManagedObjectContext
    
    convenience override init() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        try! self.init(context: context)
    }
    
    init(context: NSManagedObjectContext) throws {
        self.context = context
        super.init()
        
        try setupCategories(with: context)
    }

    func categoryCoreData(with id: UUID) throws -> TrackerCategoryCoreData {
        let request = NSFetchRequest<TrackerCategoryCoreData>(entityName: "TrackerCategoryCoreData")
        request.predicate = NSPredicate(format: "%K == %@", #keyPath(TrackerCategoryCoreData.categoryId), id.uuidString)
        let category = try context.fetch(request)
        return category[0]
    }
    
    private func makeCategory(from coreData: TrackerCategoryCoreData) throws -> TrackerCategory {
        
        guard
            let stringId = coreData.categoryId,
            let id = UUID(uuidString: stringId),
            let head = coreData.head
        else { throw TrackerCagetoryStoreError.decodingError }
        return TrackerCategory(id: id,
                               head: head,
                               trackers: [])
    }
    
    private func setupCategories(with context: NSManagedObjectContext) throws {
        let checkRequest = TrackerCategoryCoreData.fetchRequest()
        let result = try context.fetch(checkRequest)
        
        guard result.count == 0 else {
            categories = try result.map({ try makeCategory(from: $0) })
            return
        }
        
        let _ = [
            TrackerCategory(id: UUID(),
                            head: "test",
                            trackers: [Tracker(id: UUID(),
                                               name: "testTracker",
                                               color: .blue,
                                               emoji: "",
                                               completedDaysCount: 0,
                                               schedule: [.friday])]),
            TrackerCategory(id: UUID(),
                            head: "test2",
                            trackers: [Tracker(id: UUID(),
                                               name: "testTracker",
                                               color: .blue,
                                               emoji: "",
                                               completedDaysCount: 0,
                                               schedule: [.friday])])
        ].map { category in
            let categoryCoreData = TrackerCategoryCoreData(context: context)
            categoryCoreData.categoryId = category.id.uuidString
            categoryCoreData.createdAt = Date()
            categoryCoreData.head = category.head
            return categoryCoreData
        }
        
        try context.save()
    }
}

enum TrackerCagetoryStoreError: Error {
    case decodingError
    case decodingErrorInvalidHead
    case decodingErrorInvalidTrackers
}

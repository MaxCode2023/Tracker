//
//  TrackerCategoryStore.swift
//  Tracker
//
//  Created by macOS on 27.04.2023.
//

import UIKit
import CoreData

final class TrackerCategoryStore: NSObject, NSFetchedResultsControllerDelegate {
    
    weak var delegate: TrackerCategoryStoreDelegate?
    var categoriesCoreData: [TrackerCategoryCoreData] {
        fetchedResultsController.fetchedObjects ?? []
    }
    
    private lazy var fetchedResultsController: NSFetchedResultsController<TrackerCategoryCoreData> = {
        let fetchRequest = NSFetchRequest<TrackerCategoryCoreData>(entityName: "TrackerCategoryCoreData")
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(keyPath: \TrackerCategoryCoreData.createdAt, ascending: true)
        ]
        let fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        fetchedResultsController.delegate = self
        try? fetchedResultsController.performFetch()
        return fetchedResultsController
    }()
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.didUpdate()
    }
    
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
    
    func makeCategory(from coreData: TrackerCategoryCoreData) throws -> TrackerCategory {
        
        guard
            let stringId = coreData.categoryId,
            let id = UUID(uuidString: stringId),
            let head = coreData.head
        else { throw TrackerCagetoryStoreError.decodingError }
        return TrackerCategory(id: id,
                               head: head,
                               trackers: [])
    }
    
    private func getCategoryCoreData(by id: UUID) throws -> TrackerCategoryCoreData {
        fetchedResultsController.fetchRequest.predicate = NSPredicate(
            format: "%K == %@",
            #keyPath(TrackerCategoryCoreData.categoryId), id.uuidString
        )
        try fetchedResultsController.performFetch()
        guard let category = fetchedResultsController.fetchedObjects?.first else { throw TrackerCagetoryStoreError.fetchedResultError }
        fetchedResultsController.fetchRequest.predicate = nil
        try fetchedResultsController.performFetch()
        return category
    }
    
    func saveDataCategory(data: TrackerCategory) throws {
        let category = try getCategoryCoreData(by: data.id)
        category.head = data.head
        try context.save()
    }
    
    func removeDataCategory(data: TrackerCategory) throws {
        let categoryToDelete = try getCategoryCoreData(by: data.id)
        context.delete(categoryToDelete)
        try context.save()
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
    }
}

protocol TrackerCategoryStoreDelegate: AnyObject {
    func didUpdate()
}

enum TrackerCagetoryStoreError: Error {
    case decodingError
    case decodingErrorInvalidHead
    case decodingErrorInvalidTrackers
    case fetchedResultError
}

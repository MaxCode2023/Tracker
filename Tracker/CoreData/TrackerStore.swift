//
//  TrackerStore.swift
//  Tracker
//
//  Created by macOS on 27.04.2023.
//

import UIKit
import CoreData

extension TrackerStore: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.didUpdate()
    }
}

final class TrackerStore: NSObject {
    
    private let context: NSManagedObjectContext
    private var fetchedResultsController: NSFetchedResultsController<TrackerCoreData>!
    private let uiColorMarshalling = UIColorMarshalling()
    private let trackerCategoryStore = TrackerCategoryStore()
    
    weak var delegate: TrackerStoreDelegate?
    
    convenience override init() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        try! self.init(context: context)
    }
    
    init(context: NSManagedObjectContext) throws {
        self.context = context
        super.init()
        
        let fetchRequest = TrackerCoreData.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(keyPath: \TrackerCoreData.category?.categoryId, ascending: true),
            NSSortDescriptor(keyPath: \TrackerCoreData.createdAt, ascending: true)
        ]
        let controller = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: "category",
            cacheName: nil
        )
        controller.delegate = self
        self.fetchedResultsController = controller
        try controller.performFetch()
    }
    
    func makeTracker(from coreData: TrackerCoreData) throws -> Tracker {
        
        guard
            let stringId = coreData.idTracker,
            let id = UUID(uuidString: stringId),
            let name = coreData.name,
            let emoji = coreData.emoji,
            let colorHex = coreData.color,
            let completedDaysCount = coreData.records
        else { throw TrackeStoreError.decodingError }
        let color = uiColorMarshalling.color(from: colorHex)
        let scheduleString = coreData.schedule
        let schedule = Week.decode(from: scheduleString)
        return Tracker(id: id,
                       name: name,
                       color: color,
                       emoji: emoji,
                       completedDaysCount: completedDaysCount.count,
                       schedule: schedule,
                       isAttached: coreData.isAttached)
    }
    
    func getTrackerCoreData(by id: UUID) throws -> TrackerCoreData? {
        fetchedResultsController.fetchRequest.predicate = NSPredicate(
            format: "%K == %@",
            #keyPath(TrackerCoreData.idTracker), id.uuidString
        )
        try fetchedResultsController.performFetch()
        return fetchedResultsController.fetchedObjects?.first
    }
    
    func getTrackerCoreData(by indexPath: IndexPath) throws -> TrackerCoreData? {
        return fetchedResultsController.object(at: indexPath)
    }
    
    func loadFilteredTrackers(date: Date, searchString: String) throws {
        var predicates = [NSPredicate]()
        
        let weekdayIndex = Calendar.current.component(.weekday, from: date)
        let iso860WeekdayIndex = weekdayIndex > 1 ? weekdayIndex - 2 : weekdayIndex + 5
        
        var regex = ""
        for index in 0..<7 {
            if index == iso860WeekdayIndex {
                regex += "1"
            } else {
                regex += "."
            }
        }
        
        predicates.append(NSPredicate(
            format: "%K == nil OR (%K != nil AND %K MATCHES[c] %@)",
            #keyPath(TrackerCoreData.schedule),
            #keyPath(TrackerCoreData.schedule),
            #keyPath(TrackerCoreData.schedule), regex
        ))
        
        if !searchString.isEmpty {
            predicates.append(NSPredicate(
                format: "%K CONTAINS[cd] %@",
                #keyPath(TrackerCoreData.name), searchString
            ))
        }
        
        fetchedResultsController.fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        try fetchedResultsController.performFetch()
        delegate?.didUpdate()
    }
}

extension TrackerStore: TrackerStoreProtocol {
    var numberOfTrackers: Int {
        fetchedResultsController.fetchedObjects?.count ?? 0
    }
    
    var numberOfSections: Int {
        fetchedResultsController.sections?.count ?? 0
    }
    
    func numberOfRowsInSection(_ section: Int) -> Int {
        fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    func headerLabelInSection(_ section: Int) -> String? {
        guard let trackerCoreData = fetchedResultsController.sections?[section].objects?.first as? TrackerCoreData else { return nil }
        return trackerCoreData.category?.head ?? nil
    }
    
    func tracker(at indexPath: IndexPath) -> Tracker? {
        let trackerCoreData = fetchedResultsController.object(at: indexPath)
        do {
            let tracker = try makeTracker(from: trackerCoreData)
            return tracker
        } catch {
            return nil
        }
    }
    
    func addTracker(_ tracker: Tracker, with category: TrackerCategory) throws {
        let categoryCoreData = try trackerCategoryStore.categoryCoreData(with: category.id)
        let trackerCoreData = TrackerCoreData(context: context)
        trackerCoreData.idTracker = tracker.id.uuidString
        trackerCoreData.createdAt = Calendar.current.startOfDay(for: Date())
        trackerCoreData.name = tracker.name
        trackerCoreData.emoji = tracker.emoji
        trackerCoreData.color = uiColorMarshalling.hexString(from: tracker.color)
        trackerCoreData.schedule = Week.code(tracker.schedule)
        trackerCoreData.category = categoryCoreData
        trackerCoreData.isAttached = tracker.isAttached
        try context.save()
    }
    
    func deleteTracker(_ tracker: Tracker) throws {
        if let tracker = try getTrackerCoreData(by: tracker.id) {
            context.delete(tracker)
            try context.save()
        }
    }
    
    func editTracker(oldTracker: Tracker, newTracker: Tracker, category: TrackerCategory) throws {
        let categoryCoreData = try trackerCategoryStore.categoryCoreData(with: category.id)
        let trackerCoreData = try getTrackerCoreData(by: oldTracker.id)
        trackerCoreData?.name = newTracker.name
        trackerCoreData?.category = categoryCoreData
        trackerCoreData?.schedule = Week.code(newTracker.schedule)
        trackerCoreData?.emoji = newTracker.emoji
        trackerCoreData?.color = uiColorMarshalling.hexString(from: newTracker.color)
        try context.save()
    }
}

protocol TrackerStoreDelegate: AnyObject {
    func didUpdate()
}

protocol TrackerStoreProtocol {
    var numberOfTrackers: Int { get }
    var numberOfSections: Int { get }
    func numberOfRowsInSection(_ section: Int) -> Int
    func headerLabelInSection(_ section: Int) -> String?
    func tracker(at indexPath: IndexPath) -> Tracker?
    func addTracker(_ tracker: Tracker, with category: TrackerCategory) throws
    func deleteTracker(_ tracker: Tracker) throws
}

enum TrackeStoreError: Error {
    case decodingError
}

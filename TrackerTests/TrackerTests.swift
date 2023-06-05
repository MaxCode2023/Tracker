//
//  TrackerTests.swift
//  TrackerTests
//
//  Created by Albert on 27.05.2023.
//

import XCTest
import CoreData
import SnapshotTesting
@testable import Tracker

final class TrackerTests: XCTestCase {

    var managedObjectContext: NSManagedObjectContext!
    var testTrackerCategory: TrackerCategory?
    var testTracker: Tracker?

    override func setUp() {
        super.setUp()
        
        // Создаем NSManagedObjectModel для нашей БД
        let modelURL = Bundle.main.url(forResource: "CoreDataModel", withExtension: "momd")!
        let managedObjectModel = NSManagedObjectModel(contentsOf: modelURL)!
        
        // Создаем NSPersistentStoreCoordinator
        let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
        
        // Добавляем in-memory хранилище
        try! persistentStoreCoordinator.addPersistentStore(ofType: NSInMemoryStoreType, configurationName: nil, at: nil, options: nil)
        
        // Создаем NSManagedObjectContext
        managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = persistentStoreCoordinator
        
        //Добавляем тестовый трекер на экран
        testTracker = Tracker(id: UUID(),
                                 name: "test",
                                 color: .blue,
                                 emoji: "🙂",
                                 completedDaysCount: 0,
                                 schedule: Week.allCases,
                                 isAttached: false)
        
        testTrackerCategory = (try? TrackerCategoryStore().addCategory(name: "testHead"))!
        
        if let testTrackerCategory = testTrackerCategory,
           let testTracker = testTracker {
            try? TrackerStore().addTracker(testTracker, with: testTrackerCategory)
        }
    }
    
    override func tearDown() {
        super.tearDown()
        //удаляем тестовый трекер и тестовую категорию
        if let testTrackerCategory = testTrackerCategory,
           let testTracker = testTracker {
            try? TrackerStore().deleteTracker(testTracker)
            try? TrackerCategoryStore().removeDataCategory(data: testTrackerCategory)
        }
    }
    
    func testTrackersViewController() throws {
        
        let vc = TrackersViewController()
        vc.viewDidLoad()
        let window = UIWindow(frame: UIScreen.main.bounds)
        
        window.overrideUserInterfaceStyle = .light
        assertSnapshots(matching: vc, as: [.image(traits: .init(userInterfaceStyle: .light))])

        window.overrideUserInterfaceStyle = .dark
        assertSnapshots(matching: vc, as: [.image(traits: .init(userInterfaceStyle: .dark))])
    }
}

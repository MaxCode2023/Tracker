//
//  CategoryViewModel.swift
//  Tracker
//
//  Created by macOS on 05.05.2023.
//

import Foundation

protocol CategoryViewModelDelegate {
    func categoryListOnChange()
    func didSelectCategory(category: TrackerCategory)
}

final class CategoryViewModel: TrackerCategoryStoreDelegate {
    
    
    private let trackerCategoryStore = TrackerCategoryStore()
    weak var delegate: CategoryViewModelDelegate?
    
    init() {
        trackerCategoryStore.delegate = self
    }
    
    
    private(set) var categoryList: [TrackerCategory]? {
        didSet {
            delegate?.categoryListOnChange()
        }
    }
    
    private(set) var selectedCategory: TrackerCategory? = nil {
        didSet {
            guard let selectedCategory else {return}
            delegate?.didSelectCategory(category: selectedCategory)
        }
    }
    
    private func getDataFromStore() -> [TrackerCategory] {
        do {
            let categories = try trackerCategoryStore.categoriesCoreData.map({
                try trackerCategoryStore.makeCategory(from: $0)
            })
            return categories
        } catch {
            return []
        }
        
    }
    
    func selectCategoryCell(index: IndexPath) {
        selectedCategory = categoryList?[index.row]
    }
    
    
    
    func didUpdate() {
        categoryList = getDataFromStore()
    }
    
}

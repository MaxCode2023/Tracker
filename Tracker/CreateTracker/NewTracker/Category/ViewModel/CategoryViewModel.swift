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
    func showError()
}

final class CategoryViewModel: TrackerCategoryStoreDelegate {
    
    private let trackerCategoryStore = TrackerCategoryStore()
    var delegate: CategoryViewModelDelegate?
    
    init(selectedCategory: TrackerCategory?) {
        self.selectedCategory = selectedCategory
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
    
    func updateCategoryList() {
        categoryList = getDataFromStore()
    }
    
    func moveCategoryToData(category: TrackerCategory) {
        guard let categoryList = categoryList else {return}
        if categoryList.contains(where: {
            $0.id == category.id
        }) {
            saveCategory(category: category)
        } else {
            addCategory(name: category.head)
        }
    }
    
    func removeCategory(category: TrackerCategory) {
        do {
            try trackerCategoryStore.removeDataCategory(data: category)
            updateCategoryList()
            if category == selectedCategory {
                selectedCategory = nil
            }
        } catch {
            delegate?.showError()
        }
    }
    
    private func getDataFromStore() -> [TrackerCategory] {
        do {
            let categoryList = try trackerCategoryStore.categoriesCoreData
                .filter { $0.head != "Закреплённые" }
                .map({
                try trackerCategoryStore.makeCategory(from: $0)
            })
            return categoryList
        } catch {
            return []
        }
    }
    
    private func addCategory(name: String) {
        do {
            try trackerCategoryStore.addCategory(name: name)
            updateCategoryList()
        } catch {
            delegate?.showError()
        }
    }
    
    private func saveCategory(category: TrackerCategory) {
        do {
            try trackerCategoryStore.saveDataCategory(data: category)
            updateCategoryList()
        } catch {
            delegate?.showError()
        }
    }
    
    func selectCategoryCell(index: IndexPath) {
        selectedCategory = categoryList?[index.row]
    }
    
    func didUpdate() {
        categoryList = getDataFromStore()
    }
}

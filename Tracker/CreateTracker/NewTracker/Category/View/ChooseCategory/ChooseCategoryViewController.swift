//
//  ChooseCategoryViewController.swift
//  Tracker
//
//  Created by macOS on 04.05.2023.
//

import UIKit

protocol ChooseCategoryViewControllerDelegate: AnyObject {
    func didConfirmCategory(category: TrackerCategory)
}

final class ChooseCategoryViewController: UIViewController, CategoryViewModelDelegate, NewCategoryViewControllerDelegate {
    
    private let titleView = UILabel()
    private let tableCategory = UITableView()
    private let addCategoryButton = UIButton()
    private let emptyCategoryStackView = UIStackView()
    private let emptyCategoryImage = UIImageView()
    private let emptyCategoryLabel = UILabel()
    
    let viewModel: CategoryViewModel
    weak var delegate: ChooseCategoryViewControllerDelegate?
    private var categoryList = [TrackerCategory]()
    
    init(trackerCategory: TrackerCategory?) {
        viewModel = CategoryViewModel(selectedCategory: trackerCategory)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        
        addCategoryButton.addTarget(self, action: #selector(clickAddCategory), for: .touchUpInside)
        
        viewModel.delegate = self
        viewModel.didUpdate()
        
        tableCategory.delegate = self
        tableCategory.dataSource = self
    }
    
    @objc private func clickAddCategory() {
        let vc = NewCategoryViewController()
        vc.delegate = self
        self.present(vc, animated: false)
    }
    
    func didConfirm(category: TrackerCategory) {
        viewModel.moveCategoryToData(category: category)
        dismiss(animated: true)
    }
    
    func categoryListOnChange() {
        guard let categoryList = viewModel.categoryList else {return}
        emptyCategoryStackView.isHidden = !categoryList.isEmpty
        tableCategory.reloadData()
    }
    
    func didSelectCategory(category: TrackerCategory) {
        delegate?.didConfirmCategory(category: category)
    }
    
    func showError() {
        showAlert()
    }
    
    private func replaceCategory(currentCategory: TrackerCategory) {
        let vc = NewCategoryViewController(category: currentCategory)
        vc.delegate = self
        self.present(vc, animated: false)
    }
    
    private func removeCategory(category: TrackerCategory) {
        let alert = UIAlertController(
            title: nil,
            message: "Эта категория точно не нужна?",
            preferredStyle: .actionSheet
        )
        let cancelAction = UIAlertAction(title: "Отменить", style: .cancel)
        let deleteAction = UIAlertAction(title: "Удалить", style: .destructive) { [weak self] _ in
            self?.viewModel.removeCategory(category: category)
        }
        
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    private func showAlert() {
        let alert = UIAlertController(title: "Ошибка при работе с базой данных",
                                      message: "Повторите попытку позже",
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK",
                                      style: .default,
                                      handler: { _ in
        }))
        self.present(alert, animated: true)
    }
    
    private func setUI() {
        view.backgroundColor = UIColor(named: "white")
        view.addSubview(titleView)
        view.addSubview(tableCategory)
        view.addSubview(addCategoryButton)
        view.addSubview(emptyCategoryStackView)
        emptyCategoryStackView.addArrangedSubview(emptyCategoryImage)
        emptyCategoryStackView.addArrangedSubview(emptyCategoryLabel)
        
        emptyCategoryStackView.isHidden = !categoryList.isEmpty
        
        emptyCategoryStackView.axis = .vertical
        emptyCategoryStackView.spacing = 8
        emptyCategoryStackView.alignment = .center
        
        titleView.text = "Категория"
        titleView.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        
        tableCategory.layer.cornerRadius = 16
        tableCategory.register(CategoryCell.self, forCellReuseIdentifier: CategoryCell.identifier)
        tableCategory.separatorStyle = .singleLine
        tableCategory.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    
        emptyCategoryImage.image = UIImage(named: "emptyTrackers")
        emptyCategoryLabel.text = "Привычки и события можно объединять по смыслу"
        emptyCategoryLabel.numberOfLines = 2
        emptyCategoryLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        emptyCategoryLabel.textAlignment = .center
        
        addCategoryButton.setTitle("Добавить категорию", for: .normal)
        addCategoryButton.backgroundColor = UIColor(named: "black")
        addCategoryButton.layer.cornerRadius = 16
        
        titleView.translatesAutoresizingMaskIntoConstraints = false
        tableCategory.translatesAutoresizingMaskIntoConstraints = false
        addCategoryButton.translatesAutoresizingMaskIntoConstraints = false
        emptyCategoryStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleView.topAnchor.constraint(equalTo: view.topAnchor, constant: 15),
  
            emptyCategoryStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyCategoryStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyCategoryStackView.widthAnchor.constraint(equalToConstant: 200),
            
            tableCategory.topAnchor.constraint(equalTo: titleView.bottomAnchor, constant: 38),
            tableCategory.bottomAnchor.constraint(equalTo: addCategoryButton.topAnchor, constant: -25),
            tableCategory.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableCategory.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            addCategoryButton.heightAnchor.constraint(equalToConstant: 60),
            addCategoryButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            addCategoryButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            addCategoryButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        ])
    }
}

extension ChooseCategoryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.categoryList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let categoryCell = tableView.dequeueReusableCell(withIdentifier: CategoryCell.identifier) as? CategoryCell else { return UITableViewCell() }
        
        let category = viewModel.categoryList?[indexPath.row]
        let isSelected = viewModel.selectedCategory == category

        categoryCell.configueCell(name: category?.head ?? "", isSelected: isSelected)
        return categoryCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.selectCategoryCell(index: indexPath)
        dismiss(animated: true)
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        guard let category = viewModel.categoryList?[indexPath.row] else {return UIContextMenuConfiguration()}
        
        return UIContextMenuConfiguration(actionProvider: { _ in
            UIMenu(children: [
                UIAction(title: "Редактировать") { [weak self] _ in
                    self?.replaceCategory(currentCategory: category)
                },
                UIAction(title: "Удалить", attributes: .destructive) { [weak self] _ in
                    self?.removeCategory(category: category)
                }
            ])
        })
    }
}

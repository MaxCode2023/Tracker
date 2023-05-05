//
//  ChooseCategoryViewController.swift
//  Tracker
//
//  Created by macOS on 04.05.2023.
//

import UIKit

final class ChooseCategoryViewController: UIViewController {
    private let titleView = UILabel()
    private let tableCategory = UITableView()
    private let addCategoryButton = UIButton()
    private let emptyCategoryStackView = UIStackView()
    private let emptyCategoryImage = UIImageView()
    private let emptyCategoryLabel = UILabel()
    
    let viewModel = CategoryViewModel()
    var categoryList = [TrackerCategory]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        
        addCategoryButton.addTarget(self, action: #selector(clickAddCategory), for: .touchUpInside)
        
      //  categoryList = viewModel.categoryList
    }
    
    @objc func clickAddCategory() {
        let vc = NewCategoryViewController()
        vc.viewModel = self.viewModel
        self.present(vc, animated: false)
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
            tableCategory.bottomAnchor.constraint(equalTo: addCategoryButton.topAnchor, constant: -15),
            tableCategory.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableCategory.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
            addCategoryButton.heightAnchor.constraint(equalToConstant: 60),
            addCategoryButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            addCategoryButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            addCategoryButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        ])
    }
}

extension ChooseCategoryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        categoryList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}

//
//  NewCategoryViewController.swift
//  Tracker
//
//  Created by macOS on 04.05.2023.
//

import UIKit

protocol NewCategoryViewControllerDelegate: AnyObject {
    func didConfirm(category: TrackerCategory)
}

final class NewCategoryViewController: UIViewController, UITextFieldDelegate {
    private let titleView = UILabel()
    private let nameCategory = UITextField()
    private let completeButton = UIButton()
    
    var category: TrackerCategory
    weak var delegate: NewCategoryViewControllerDelegate?
    
    init(category: TrackerCategory = TrackerCategory(id: UUID(), head: "")) {
        self.category = category
        super.init(nibName: nil, bundle: nil)
        nameCategory.text = category.head
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        
        completeButton.addTarget(self, action: #selector(clickCompleteButton), for: .touchUpInside)
        nameCategory.addTarget(self, action: #selector(didChangedTextField), for: .editingChanged)
    }
    
    @objc private func didChangedTextField(_ sender: UITextField) {
        if let text = sender.text, !text.isEmpty {
            category.head = text
            checkUnblockedButton()
        } else {
            checkUnblockedButton()
        }
    }
    
    @objc private func clickCompleteButton() {
        delegate?.didConfirm(category: category)
    }
    
    private func setUI() {
        view.backgroundColor = UIColor(named: "white")
        view.addSubview(titleView)
        view.addSubview(nameCategory)
        view.addSubview(completeButton)
        
        titleView.text = "Новая категория"
        titleView.font = UIFont.systemFont(ofSize: 16, weight: .medium)

        completeButton.setTitle("Готово", for: .normal)
        completeButton.backgroundColor = UIColor(named: "black")
        completeButton.layer.cornerRadius = 16
        
        titleView.translatesAutoresizingMaskIntoConstraints = false
        nameCategory.translatesAutoresizingMaskIntoConstraints = false
        completeButton.translatesAutoresizingMaskIntoConstraints = false
        
        nameCategory.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        nameCategory.backgroundColor = UIColor(named: "background view")
        nameCategory.layer.cornerRadius = 16
        nameCategory.placeholder = "Введите название категории"
        nameCategory.delegate = self
        
        let textFieldPadding = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: nameCategory.frame.height))
        nameCategory.leftView = textFieldPadding
        nameCategory.leftViewMode = .always
        nameCategory.rightView = textFieldPadding
        nameCategory.rightViewMode = .always
        
        NSLayoutConstraint.activate([
            titleView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleView.topAnchor.constraint(equalTo: view.topAnchor, constant: 15),

            nameCategory.topAnchor.constraint(equalTo: titleView.bottomAnchor, constant: 38),
            nameCategory.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            nameCategory.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            nameCategory.heightAnchor.constraint(equalToConstant: 75),
            
            completeButton.heightAnchor.constraint(equalToConstant: 60),
            completeButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            completeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            completeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        ])
    }
    
    func checkUnblockedButton() {
        guard let nameCategoryText = nameCategory.text else {return}
        
        if nameCategoryText.isEmpty || nameCategoryText == " " {
            completeButton.blockedButton()
        } else {
            completeButton.unblockedButton()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        checkUnblockedButton()
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        checkUnblockedButton()
    }
}

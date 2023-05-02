//
//  ColorCell.swift
//  Tracker
//
//  Created by macOS on 24.04.2023.
//

import UIKit

final internal class ColorCell: UICollectionViewCell {
    private let mainView = UIView()
    public var color: UIColor? {
        didSet {
            mainView.backgroundColor = color != nil ? color : .green
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configCell(color: UIColor) {
        self.color = color
    }
    
    func toggleCell(_ isSelected: Bool) {
        if isSelected {
            contentView.layer.borderWidth = 0
            contentView.layer.borderColor = color?.withAlphaComponent(0).cgColor
        } else {
            contentView.layer.borderWidth = 3
            contentView.layer.borderColor = color?.withAlphaComponent(0.3).cgColor
        }
    }
    
    private func setUI() {
        
        contentView.addSubview(mainView)
        contentView.layer.cornerRadius = 8
        
        mainView.layer.cornerRadius = 8
        mainView.translatesAutoresizingMaskIntoConstraints = false
        mainView.backgroundColor = .green
        
        NSLayoutConstraint.activate([
            mainView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            mainView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            mainView.widthAnchor.constraint(equalToConstant: 40),
            mainView.heightAnchor.constraint(equalToConstant: 40),
        ])
    }
}

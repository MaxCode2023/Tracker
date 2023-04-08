//
//  TrackerCell.swift
//  Tracker
//
//  Created by macOS on 08.04.2023.
//

import UIKit

class TrackerCollectionViewCell: UICollectionViewCell {
    let backView = UIView()
    let icon = UIView(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
    let iconImage = UIImageView()
    let title = UILabel()
    let count = UILabel()
    let plusButton = UIButton(frame: CGRect(x: 0, y: 0, width: 34, height: 34))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backView.backgroundColor = .blue
        backView.layer.cornerRadius = 16
        plusButton.setTitle("+", for: .normal)
        plusButton.backgroundColor = .blue
        plusButton.layer.cornerRadius = 17
        count.text = "1 день"
        title.text = "рандомная ячейка"
        
        contentView.addSubview(backView)
        backView.addSubview(icon)
        backView.addSubview(title)
        icon.addSubview(iconImage)
        
        contentView.addSubview(count)
        contentView.addSubview(plusButton)
        
        backView.translatesAutoresizingMaskIntoConstraints = false
        icon.translatesAutoresizingMaskIntoConstraints = false
        title.translatesAutoresizingMaskIntoConstraints = false
        count.translatesAutoresizingMaskIntoConstraints = false
        plusButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            backView.topAnchor.constraint(equalTo: contentView.topAnchor),
            backView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            backView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            backView.heightAnchor.constraint(equalToConstant: 90),
            
            icon.topAnchor.constraint(equalTo: backView.topAnchor, constant: 12),
            icon.leadingAnchor.constraint(equalTo: backView.leadingAnchor, constant: 12),
            
            title.bottomAnchor.constraint(equalTo: backView.bottomAnchor, constant: 12),
            title.leadingAnchor.constraint(equalTo: backView.leadingAnchor, constant: 12),
            
            count.topAnchor.constraint(equalTo: backView.bottomAnchor, constant: 16),
            count.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            count.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 12),
            
            plusButton.centerYAnchor.constraint(equalTo: count.centerYAnchor),
            plusButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12)
            
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

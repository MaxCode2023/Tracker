//
//  TrackerCell.swift
//  Tracker
//
//  Created by macOS on 08.04.2023.
//

import UIKit

class TrackerCollectionViewCell: UICollectionViewCell {
    let backView = UIView()
    let emojiView = UIView()
    let emojiImageView = UIImageView()
    let title = UILabel()
    let count = UILabel()
    let plusButton = UIView()
    let plusButtonTittle = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backView.backgroundColor = .blue
        backView.layer.cornerRadius = 16
        plusButton.backgroundColor = .blue
        plusButton.layer.cornerRadius = 17
        count.text = "1 день"
        title.text = "рандомная ячейка"
        title.textColor = UIColor(named: "white")
        plusButtonTittle.textColor = UIColor(named: "white")
        
        contentView.addSubview(backView)
        backView.addSubview(emojiView)
        backView.addSubview(title)
        emojiView.addSubview(emojiImageView)
        plusButton.addSubview(plusButtonTittle)
        emojiImageView.image = UIImage(named: "statistic icon")
        plusButtonTittle.text = "+"
        
        contentView.addSubview(count)
        contentView.addSubview(plusButton)
        
        backView.translatesAutoresizingMaskIntoConstraints = false
        emojiView.translatesAutoresizingMaskIntoConstraints = false
        emojiImageView.translatesAutoresizingMaskIntoConstraints = false
        title.translatesAutoresizingMaskIntoConstraints = false
        count.translatesAutoresizingMaskIntoConstraints = false
        plusButton.translatesAutoresizingMaskIntoConstraints = false
        plusButtonTittle.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            backView.topAnchor.constraint(equalTo: contentView.topAnchor),
            backView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            backView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            backView.heightAnchor.constraint(equalToConstant: 90),
            
            emojiView.topAnchor.constraint(equalTo: backView.topAnchor, constant: 12),
            emojiView.leadingAnchor.constraint(equalTo: backView.leadingAnchor, constant: 12),
            emojiView.heightAnchor.constraint(equalToConstant: 24),
            emojiView.widthAnchor.constraint(equalToConstant: 24),
            
            emojiImageView.centerYAnchor.constraint(equalTo: emojiView.centerYAnchor),
            emojiImageView.centerXAnchor.constraint(equalTo: emojiView.centerXAnchor),
            
            title.bottomAnchor.constraint(equalTo: backView.bottomAnchor, constant: -12),
            title.leadingAnchor.constraint(equalTo: backView.leadingAnchor, constant: 12),
            title.trailingAnchor.constraint(equalTo: backView.trailingAnchor),
            
            plusButton.topAnchor.constraint(equalTo: backView.bottomAnchor, constant: 8),
            plusButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            plusButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            plusButton.heightAnchor.constraint(equalToConstant: 34),
            plusButton.widthAnchor.constraint(equalToConstant: 34),
            
            plusButtonTittle.centerXAnchor.constraint(equalTo: plusButton.centerXAnchor),
            plusButtonTittle.centerYAnchor.constraint(equalTo: plusButton.centerYAnchor),
            
            count.centerYAnchor.constraint(equalTo: plusButton.centerYAnchor),
            count.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12)
            
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

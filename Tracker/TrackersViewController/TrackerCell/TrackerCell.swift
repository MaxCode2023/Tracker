//
//  TrackerCell.swift
//  Tracker
//
//  Created by macOS on 08.04.2023.
//

import UIKit

protocol TrackerCellDelegate {
    func appendToCompletedCategories(id: UInt)
    func removeCompletedCategories(id: UInt)
}

class TrackerCollectionViewCell: UICollectionViewCell {
    
    public var color: UIColor? {
        didSet {
            backView.backgroundColor = color != nil ? color : .green
            plusButton.backgroundColor = color != nil ? color : .green
        }
    }
    
    let backView = UIView()
    let emojiView = UIView()
    let emojiImageView = UIImageView()
    let title = UILabel()
    let countLabel = UILabel()
    let plusButton = UIView()
    let plusButtonTittle = UILabel()
    let plusButtonImage = UIImageView()
    
    var id: UInt?
    var date: Date?
    var delegate: TrackerCellDelegate?
    var count = 0
    var isCompleted = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(clickPlus))
        plusButton.addGestureRecognizer(tapGesture)

        setUI()
    }
    
    @objc func clickPlus() {
        if date ?? Date() > Date() {
            return
        } else {
            isCompleted = !isCompleted
            guard let id = id else {return}
            if isCompleted {
                plusButton.alpha = 0.3
                count = count + 1
                plusButtonImage.isHidden = false
                plusButtonTittle.isHidden = true
                
                delegate?.appendToCompletedCategories(id: id)
            } else {
                plusButton.alpha = 1
                count = count - 1
                plusButtonImage.isHidden = true
                plusButtonTittle.isHidden = false
                delegate?.removeCompletedCategories(id: id)
            }
            countLabel.text = "\(count) день"
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        
        backView.layer.cornerRadius = 16
        plusButton.layer.cornerRadius = 17
        countLabel.text = "\(count) день"
        title.text = "рандомная ячейка"
        title.textColor = UIColor(named: "white")
        plusButtonTittle.textColor = UIColor(named: "white")
        
        contentView.addSubview(backView)
        backView.addSubview(emojiView)
        backView.addSubview(title)
        emojiView.addSubview(emojiImageView)
        plusButton.addSubview(plusButtonTittle)
        plusButton.addSubview(plusButtonImage)
        emojiImageView.image = UIImage(named: "statistic icon")
        plusButtonTittle.text = "+"
        plusButtonImage.isHidden = true
        plusButtonImage.image = UIImage(named: "done")
        
        contentView.addSubview(countLabel)
        contentView.addSubview(plusButton)
        
        backView.translatesAutoresizingMaskIntoConstraints = false
        emojiView.translatesAutoresizingMaskIntoConstraints = false
        emojiImageView.translatesAutoresizingMaskIntoConstraints = false
        title.translatesAutoresizingMaskIntoConstraints = false
        countLabel.translatesAutoresizingMaskIntoConstraints = false
        plusButton.translatesAutoresizingMaskIntoConstraints = false
        plusButtonTittle.translatesAutoresizingMaskIntoConstraints = false
        plusButtonImage.translatesAutoresizingMaskIntoConstraints = false
        
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
            
            plusButtonImage.centerXAnchor.constraint(equalTo: plusButton.centerXAnchor),
            plusButtonImage.centerYAnchor.constraint(equalTo: plusButton.centerYAnchor),
            
            countLabel.centerYAnchor.constraint(equalTo: plusButton.centerYAnchor),
            countLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12)
            
        ])
    }
    
}

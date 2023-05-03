//
//  TrackerCell.swift
//  Tracker
//
//  Created by macOS on 08.04.2023.
//

import UIKit

protocol TrackerCellDelegate {
    func clickDoneButton(cell: TrackerCollectionViewCell, tracker: Tracker)
}

final class TrackerCollectionViewCell: UICollectionViewCell {
    
    public var color: UIColor? {
        didSet {
            backView.backgroundColor = color != nil ? color : .green
            plusButton.backgroundColor = color != nil ? color : .green
        }
    }
    
    private let backView = UIView()
    private let emojiView = UIView()
    private let emoji = UILabel()
    private let title = UILabel()
    private let countLabel = UILabel()
    private let plusButton = UIView()
    private let plusButtonTittle = UILabel()
    private let plusButtonImage = UIImageView()
    private var tracker: Tracker?
    
    var id: UInt?
    var delegate: TrackerCellDelegate?
    var count = 0 {
        didSet {
            countLabel.text = "\(count) дней"
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(clickPlus))
        plusButton.addGestureRecognizer(tapGesture)
        setUI()
    }
    
    func configCell(tracker: Tracker, count: Int, isCompleted: Bool) {
        self.tracker = tracker
        self.count = count
        color = tracker.color
        title.text = tracker.name
        emoji.text = tracker.emoji
        toggleDoneButton(isCompleted)
    }
    
    func toggleDoneButton(_ isCompleted: Bool) {
        
        plusButtonImage.isHidden = !isCompleted
        plusButtonTittle.isHidden = isCompleted
        plusButton.alpha = isCompleted ? 0.3 : 1

    }
    
    func increaseCount() {
        count += 1
    }
    
    func decreaseCount() {
        count -= 1
    }
    
    @objc private func clickPlus() {
        guard let tracker else {return}
        delegate?.clickDoneButton(cell: self, tracker: tracker)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        
        backView.layer.cornerRadius = 16
        plusButton.layer.cornerRadius = 17
        title.text = "рандомная ячейка"
        title.textColor = UIColor(named: "white")
        plusButtonTittle.textColor = UIColor(named: "white")
        emojiView.backgroundColor = color?.withAlphaComponent(0.3)
        emojiView.layer.cornerRadius = 12
        
        contentView.addSubview(backView)
        backView.addSubview(emojiView)
        backView.addSubview(title)
        emojiView.addSubview(emoji)
        plusButton.addSubview(plusButtonTittle)
        plusButton.addSubview(plusButtonImage)
        emoji.text = ""
        plusButtonTittle.text = "+"
        plusButtonImage.isHidden = true
        plusButtonImage.image = UIImage(named: "Done")
        
        contentView.addSubview(countLabel)
        contentView.addSubview(plusButton)
        
        backView.translatesAutoresizingMaskIntoConstraints = false
        emojiView.translatesAutoresizingMaskIntoConstraints = false
        emoji.translatesAutoresizingMaskIntoConstraints = false
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
            
            emoji.centerYAnchor.constraint(equalTo: emojiView.centerYAnchor),
            emoji.centerXAnchor.constraint(equalTo: emojiView.centerXAnchor),
            
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

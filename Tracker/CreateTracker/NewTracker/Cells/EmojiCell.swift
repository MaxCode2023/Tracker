//
//  EmojiCell.swift
//  Tracker
//
//  Created by macOS on 24.04.2023.
//

import UIKit
import Foundation

final public class EmojiCell: UICollectionViewCell {
    
    public let emoji = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func toggleCell(_ isSelected: Bool) {
        if isSelected {
            contentView.backgroundColor = UIColor(named: Constants.ColorNames.white)
        } else {
            contentView.backgroundColor = UIColor(named: Constants.ColorNames.lightGrey)
        }
    }
    
    private func setUI() {
        
        contentView.layer.cornerRadius = 16
        contentView.addSubview(emoji)
        
        emoji.text = "1"
        
        emoji.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            emoji.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            emoji.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
}

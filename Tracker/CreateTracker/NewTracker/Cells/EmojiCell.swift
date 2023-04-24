//
//  EmojiCell.swift
//  Tracker
//
//  Created by macOS on 24.04.2023.
//

import UIKit
import Foundation

public protocol EmojiCellDelegate {
    func onClickEmoji(cell: EmojiCell, emoji: String)
}

final class EmojiCell: UICollectionViewCell {
    
    let emoji = UILabel()
    var delegate: EmojiCellDelegate?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onClickEmoji))
        self.addGestureRecognizer(tapGesture)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        emoji.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            emoji.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            emoji.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
    
    @objc func onClickEmoji() {
        guard let tracker else {return}
        delegate?.onClickEmoji(cell: self, emoji: emoji.text)
    }
}

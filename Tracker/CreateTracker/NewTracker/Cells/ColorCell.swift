//
//  ColorCell.swift
//  Tracker
//
//  Created by macOS on 24.04.2023.
//

import UIKit
import Foundation

public protocol ColorCellDelegate {
    func onClickColor(cell: ColorCell, color: UIColor)
}

final public class ColorCell: UICollectionViewCell {
    let mainView = UIView()
    public var color: UIColor? {
        didSet {
            mainView.backgroundColor = color != nil ? color : .green
        }
    }
    var delegate: ColorCellDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onClickColor))
        self.addGestureRecognizer(tapGesture)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configCell(color: UIColor) {
        self.color = color
    }
    
    private func setUI() {
        
        contentView.addSubview(mainView)
        
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
    
    @objc func onClickColor() {
        delegate?.onClickColor(cell: self, color: color ?? .gray)
    }
}

//
//  CategoryCell.swift
//  Tracker
//
//  Created by macOS on 05.05.2023.
//

import UIKit

final class CategoryCell: UITableViewCell {
    public let name = UILabel()
    public let checkImage = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(name)
        addSubview(checkImage)

        checkImage.image = UIImage(named: "check")
        
        name.translatesAutoresizingMaskIntoConstraints = false
        checkImage.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.heightAnchor.constraint(equalToConstant: 75),
            
            name.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            name.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            
            checkImage.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            checkImage.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16)
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func toggleCell(_ isSelected: Bool) {
        checkImage.isHidden = !isSelected
    }
}

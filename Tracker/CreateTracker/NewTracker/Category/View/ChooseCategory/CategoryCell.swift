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
    static let identifier = "CategoryCell"
    static let cellHeight = 75
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        contentView.addSubview(name)
        contentView.addSubview(checkImage)

        contentView.backgroundColor = UIColor(named: Constants.ColorNames.background)?.withAlphaComponent(0.3)
        
        checkImage.image = UIImage(named: Constants.ImageNames.check)
        name.textColor = UIColor(named: Constants.ColorNames.black)
        name.font = UIFont.systemFont(ofSize: 17)
        
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
    
    func configueCell(name: String, isSelected: Bool) {
        self.name.text = name
        toggleCell(isSelected)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func toggleCell(_ isSelected: Bool) {
        checkImage.isHidden = !isSelected
    }
}

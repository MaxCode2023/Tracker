//
//  NewTrackerTableViewCell.swift
//  Tracker
//
//  Created by macOS on 10.04.2023.
//

import UIKit

final class NewTrackerTableViewCell: UITableViewCell {
    static let reuseIdentifier = "newTrackerCell"
    public var name = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(name)
        
        name.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            name.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            name.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
}

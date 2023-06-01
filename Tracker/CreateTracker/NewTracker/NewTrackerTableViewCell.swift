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
    public var choosedParams = UILabel()
    public var stackView = UIStackView()
    public var arrow = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(stackView)
        stackView.addArrangedSubview(name)
        stackView.addArrangedSubview(choosedParams)
        addSubview(arrow)
        
        stackView.axis = .vertical
        stackView.spacing = 2
        arrow.image = UIImage(named: "arrow")
        choosedParams.textColor = UIColor(named: "grey")
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        arrow.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            self.heightAnchor.constraint(equalToConstant: 75),
            
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            stackView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            
            arrow.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            arrow.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16)
            
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
}

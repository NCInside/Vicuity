//
//  CustomTableViewCell.swift
//  Vicuity
//
//  Created by Nicholas Christian Irawan on 02/05/24.
//

import UIKit

class CustomTableViewCell: UITableViewCell {
    let scoreLabel = UILabel()
    let dateLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        scoreLabel.textColor = .white
        dateLabel.textColor = .white

        contentView.addSubview(scoreLabel)
        contentView.addSubview(dateLabel)

        NSLayoutConstraint.activate([
            scoreLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            scoreLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),

            dateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            dateLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

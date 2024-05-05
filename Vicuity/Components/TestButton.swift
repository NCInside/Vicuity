//
//  TestButton.swift
//  Vicuity
//
//  Created by Nicholas Christian Irawan on 05/05/24.
//

import UIKit

class TestButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    init(title: String?) {
        super.init(frame: .zero)
        self.setTitle(title, for: .normal)
        configure()
    }
    
    private func configure() {
        layer.cornerRadius = 10
        backgroundColor = .black
        layer.borderWidth = 4
        layer.borderColor = UIColor.white.cgColor
        titleLabel?.textColor = .white
        titleLabel?.font = UIFont(name: "Sloan", size: 32)
        translatesAutoresizingMaskIntoConstraints = false
        contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }

}

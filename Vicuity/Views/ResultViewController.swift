//
//  ResultViewController.swift
//  Vicuity
//
//  Created by Nicholas Christian Irawan on 03/05/24.
//

import UIKit

class ResultViewController: UIViewController {
    
    var testScore: String!
    
    let scoreLabel = UILabel()
    let score = UILabel()
    let descLabel = UILabel()
    let desc = UILabel()
    let textColor: UIColor = .white
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupScoreLabel()
        setupScore()
        setupDescLabel()
        setupDescription()
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButtonTapped))
        navigationItem.rightBarButtonItem = doneButton
    }
    
    @objc func doneButtonTapped() {
        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
    }
    
    func setupScoreLabel() {
        view.addSubview(scoreLabel)
        
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        scoreLabel.text = "Score"
        scoreLabel.textColor = textColor
        scoreLabel.font = UIFont.boldSystemFont(ofSize: 64)
        
        NSLayoutConstraint.activate([
            scoreLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            scoreLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    func setupScore() {
        view.addSubview(score)
        
        score.translatesAutoresizingMaskIntoConstraints = false
        score.text = testScore
        score.textColor = textColor
        score.font = UIFont.boldSystemFont(ofSize: 64)
        
        NSLayoutConstraint.activate([
            score.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor, constant: 12),
            score.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    func setupDescLabel() {
        view.addSubview(descLabel)
        
        descLabel.translatesAutoresizingMaskIntoConstraints = false
        descLabel.text = "What it means"
        descLabel.textColor = textColor
        descLabel.font = UIFont.boldSystemFont(ofSize: 32)
        
        NSLayoutConstraint.activate([
            descLabel.topAnchor.constraint(equalTo: score.bottomAnchor, constant: 80),
            descLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
        ])
    }
    
    func setupDescription() {
        view.addSubview(desc)
        
        desc.translatesAutoresizingMaskIntoConstraints = false
        desc.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Suspendisse non elementum enim. Pellentesque id tempus dolor. Sed congue ac est eget cursus. Praesent ultrices at nibh ut tempus. Ut et varius erat, sit amet pretium odio. Pellentesque vehicula lectus tincidunt purus accumsan, id ornare arcu auctor. Mauris ex urna, pharetra sed volutpat in, rutrum eget ipsum. Pellentesque dapibus nibh pharetra condimentum maximus. Integer convallis lacus vitae mauris finibus varius. Cras consectetur augue eget neque viverra rutrum. Maecenas interdum sem ut efficitur ornare. Etiam vitae justo fringilla, pulvinar turpis in, interdum arcu."
        desc.textColor = textColor
        desc.numberOfLines = 0
        desc.lineBreakMode = .byWordWrapping
        
        NSLayoutConstraint.activate([
            desc.topAnchor.constraint(equalTo: descLabel.bottomAnchor, constant: 20),
            desc.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            desc.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
}

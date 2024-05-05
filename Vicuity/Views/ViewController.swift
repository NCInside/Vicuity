//
//  ViewController.swift
//  Vicuity
//
//  Created by Nicholas Christian Irawan on 26/04/24.
//

import UIKit

class ViewController: UIViewController {
    
    let testButton = TestButton(title: "TEST")
    let historyButton = TestButton(title: "HISTORY")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTestButton()
        setupHistoryButton()
    }

    @objc func navigateToTestVC() {
        let testVC = TestViewController()
        testVC.modalPresentationStyle = .fullScreen
        self.present(testVC, animated: true, completion: nil)
    }
    
    @objc func navigateToHistoryVC() {
        let historyVC = HistoryViewController()
        historyVC.title = "History"
        navigationController?.pushViewController(historyVC, animated: true)
    }
    
    func setupTestButton() {
        view.addSubview(testButton)
        testButton.addTarget(self, action: #selector(navigateToTestVC), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            testButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            testButton.bottomAnchor.constraint(equalTo: view.centerYAnchor, constant: -40)
        ])
    }
    
    func setupHistoryButton() {
        view.addSubview(historyButton)
        historyButton.addTarget(self, action: #selector(navigateToHistoryVC), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            historyButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            historyButton.topAnchor.constraint(equalTo: testButton.bottomAnchor, constant: 80)
        ])
    }
    
}

#Preview {
    ViewController()
}

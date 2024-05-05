//
//  TestViewController.swift
//  Vicuity
//
//  Created by Nicholas Christian Irawan on 02/05/24.
//

import UIKit
import Speech
import CoreData

class TestViewController: UIViewController, SFSpeechRecognizerDelegate {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var timer: Timer?
    
    let alphabet = Array("DHKRSVZ").map{ String($0) }
    let sizeDict: [String: Double] = [
        "20/800": 160,
        "20/640": 152,
        "20/500": 144,
        "20/400": 136,
        "20/320": 128,
        "20/250": 120,
        "20/200": 112,
        "20/160": 104,
        "20/125": 96,
        "20/100": 88,
        "20/80": 80,
        "20/63": 72,
        "20/50": 64,
        "20/40": 56,
        "20/32": 48,
        "20/25": 40,
        "20/20": 32,
        "20/15": 24,
        "20/12": 16]
    let sizeArr = ["20/800", "20/640", "20/500", "20/400", "20/320", "20/250", "20/200", "20/160", "20/125", "20/100", "20/80", "20/63", "20/50", "20/40", "20/32", "20/25", "20/20", "20/15", "20/12"]
    var curSize = "20/400"
    var gate = "O"
    var pool: [String: [Int]] = [:]
    var limit: [String] = []
    var counter = 1
    var score = 0
    
    let letter = UILabel()
    
    private var speechRecognizer:SpeechRecognizer?
    private var recognizedTextObservation: NSKeyValueObservation?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        speechRecognizer = SpeechRecognizer()
        speechRecognizer!.start()
        setupLetter()
        observeRecognizedText()
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButtonTapped))
        navigationItem.rightBarButtonItem = doneButton
    }
    
    @objc func doneButtonTapped() {
        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
    }
  
    func handleScreening(curValue: String, newValue: String) {
        if gate == "A" {
            if curValue == newValue.uppercased() || curSize == "20/800" {
                pool[curSize] = [0,0]
                print(1)
                handleThreshold(curValue: curValue, newValue: newValue)
                return
            }
            else {
                curSize = sizeArr[sizeArr.firstIndex(of: curSize)!-1]
                letter.font = letter.font.withSize(CGFloat((sizeDict[curSize])!))
                letter.text = alphabet.randomElement()
            }
        }
        else if gate == "B" {
            if curValue == newValue.uppercased() {
                if curSize == "20/12" {
                    pool[curSize] = [0,0]
                    print(2)
                    handleThreshold(curValue: curValue, newValue: newValue)
                    return
                }
                curSize = sizeArr[sizeArr.firstIndex(of: curSize)!+1]
                letter.font = letter.font.withSize(CGFloat((sizeDict[curSize])!))
                letter.text = alphabet.randomElement()
            }
            else {
                pool[sizeArr[sizeArr.firstIndex(of: curSize)!-1]] = [0,0]
                print(3)
                handleThreshold(curValue: curValue, newValue: newValue)
                return
            }
        }
        else if gate == "O" {
            if curValue == newValue.uppercased() {
                curSize = "20/200"
                letter.font = letter.font.withSize(CGFloat((sizeDict["20/200"])!))
            }
            else {
                curSize = "20/800"
                letter.font = letter.font.withSize(CGFloat((sizeDict["20/800"])!))
            }
            letter.text = alphabet.randomElement()
            gate = ""
        }
        else {
            if ["20/320","20/160","20/80","20/40","20/20"].contains(curSize) {
                if curValue == newValue.uppercased() {
                    curSize = sizeArr[sizeArr.firstIndex(of: curSize)!+1]
                    gate = "B"
                }
                else {
                    curSize = sizeArr[sizeArr.firstIndex(of: curSize)!-1]
                    gate = "A"
                }
                letter.font = letter.font.withSize(CGFloat((sizeDict[curSize])!))
                letter.text = alphabet.randomElement()
            }
            else if ["20/200","20/100","20/50","20/25","20/12"].contains(curSize) {
                if curValue == newValue.uppercased() {
                    if curSize == "20/12" {
                        pool[curSize] = [0,0]
                        print(4)
                        handleThreshold(curValue: curValue, newValue: newValue)
                        return
                    }
                    curSize = sizeArr[sizeArr.firstIndex(of: curSize)!+3]
                }
                else {
                    curSize = sizeArr[sizeArr.firstIndex(of: curSize)!-2]
                }
                letter.font = letter.font.withSize(CGFloat((sizeDict[curSize])!))
                letter.text = alphabet.randomElement()
            }
            else if ["20/800","20/640","20/500","20/400"].contains(curSize) {
                if curValue == newValue.uppercased() {
                    curSize = sizeArr[sizeArr.firstIndex(of: curSize)!+1 + (curSize == "20/400" ? 2 : 0) ]
                    letter.font = letter.font.withSize(CGFloat((sizeDict[curSize])!))
                    letter.text = alphabet.randomElement()
                }
                else {
                    pool[sizeArr[sizeArr.firstIndex(of: curSize)! - (curSize == "20/800" ? 0 : 1) ]] = [0,0]
                    print(5)
                    handleThreshold(curValue: curValue, newValue: newValue)
                    return
                }
            }
        }
    }
    
    func handleThreshold(curValue: String, newValue: String) {
        if limit.count != 2 {
            let upper = pool.keys.randomElement()!
            limit.append(upper)
            if upper != "20/12" {
                let lower = sizeArr[sizeArr.firstIndex(of: pool.keys.randomElement()!)!+1]
                limit.append(lower)
                pool[lower] = [0,0]
            }
            else {
                limit.append(upper)
            }
        }
        else {
            if curValue == newValue.uppercased() {
                pool[curSize]![0] += 1
                if curSize == limit[1] && curSize != "20/12" {
                    let newLow = sizeArr[sizeArr.firstIndex(of: curSize)!+1]
                    limit[1] = newLow
                    pool[newLow] = [0,0]
                }
            }
            else {
                pool[curSize]![1] += 1
                if curSize == limit[0] && curSize != "20/800" {
                    let newHigh = sizeArr[sizeArr.firstIndex(of: curSize)!-1]
                    limit[0] = newHigh
                    pool[newHigh] = [0,0]
                }
            }
            if pool[curSize]!.reduce(0,+) == 3 {
                score += pool[curSize]![0]
                pool[curSize] = nil
                if pool.isEmpty {
                    score += sizeArr.firstIndex(of: limit[0])! * 3
                    createItem(score: Int16(score))
                    print("Score: " + String(score))
                    speechRecognizer!.stop()
                    let resultVC = ResultViewController()
                    resultVC.testScore = String(score)
                    let navController = UINavigationController(rootViewController: resultVC)
                    navController.modalPresentationStyle = .fullScreen
                    present(navController, animated: true, completion: nil)
                    return
                }
            }
        }
        if counter % 3 != 0 {
            curSize = pool.keys.randomElement()!
        }
        else {
            if let first = limit.first(where: { pool[$0] != nil }) {
                curSize = first
            }
        }
        letter.font = letter.font.withSize(CGFloat(sizeDict[curSize]!))
        letter.text = alphabet.randomElement()
        print("Counter: " + String(counter))
        counter += 1
    }
    
    func createItem(score: Int16) {
        let newItem = Test(context: context)
        newItem.date = Date()
        newItem.score = score
        
        do {
            try context.save()
        }
        catch {
            
        }
    }
    
    func observeRecognizedText() {
        recognizedTextObservation = speechRecognizer!.observe(\.recognizedText, options: [.new]) { [weak self] _, change in
            DispatchQueue.main.async {
                if let newValue = change.newValue {
                    self?.timer?.invalidate()
                    self?.timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { _ in
                        print("Observe:" + (newValue ?? "bruh"))
                        let curValue = self?.letter.text
                        if (self?.pool.isEmpty ?? true) {
                            self?.handleScreening(curValue: curValue!, newValue: newValue!)
                        }
                        else {
                            self?.handleThreshold(curValue: curValue!, newValue: newValue!)
                        }
                    }
                }
            }
        }
    }
    
    func setupLetter() {
        view.addSubview(letter)
        
        letter.text = "K"
        letter.font = UIFont(name: "Sloan", size: sizeDict["20/400"]!)
        letter.textColor = .white
        
        letter.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            letter.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            letter.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
}

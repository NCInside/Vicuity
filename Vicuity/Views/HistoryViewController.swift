//
//  HistoryViewController.swift
//  Vicuity
//
//  Created by Nicholas Christian Irawan on 02/05/24.
//

import UIKit
import CoreData

class HistoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let dateFormatter = DateFormatter()
    
    private var models = [Test]()
    
    let table = {
        let table = UITableView()
        table.register(CustomTableViewCell.self,
        forCellReuseIdentifier: "CustomCell")
        return table
    }()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        getAllItems()
        setupTable()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = models[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as! CustomTableViewCell
        cell.scoreLabel.text = String(model.score)
        dateFormatter.dateFormat = "yyyy-MM-dd"
        cell.dateLabel.text = dateFormatter.string(from: model.date!)
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.lightGray

        let headerLabel1 = UILabel()
        headerLabel1.textColor = UIColor.white
        headerLabel1.text = "Score"
        headerLabel1.sizeToFit()
        headerView.addSubview(headerLabel1)

        let headerLabel2 = UILabel()
        headerLabel2.textColor = UIColor.white
        headerLabel2.text = "Time"
        headerLabel2.sizeToFit()
        headerView.addSubview(headerLabel2)
        
        headerLabel1.translatesAutoresizingMaskIntoConstraints = false
        headerLabel2.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            headerLabel1.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 20),
            headerLabel1.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),

            headerLabel2.leadingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -60),
            headerLabel2.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
        ])

        return headerView
    }

    func getAllItems() {
        do {
            models = try context.fetch(Test.fetchRequest())
            models.sort { $0.date! > $1.date! }
            DispatchQueue.main.async {
                self.table.reloadData()
            }
        }
        catch {
            
        }
    }
    
    func setupTable() {
        view.addSubview(table)
        table.delegate = self
        table.dataSource = self
        table.frame = view.bounds
    }
    
}

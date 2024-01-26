//
//  ViewController.swift
//  ShoppingApp
//
//  Created by Frane Sučić on 19.01.2024..
//

import UIKit
import CoreData

class ShoppingListViewController: UIViewController {
    
    var items: [ShoppingItem] = []
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var selectedIndexPath: IndexPath?

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getAllItems()
        sortItems()
        tableView.reloadData()
    }
    
}

// MARK: - UI setup

extension ShoppingListViewController {
    
    func setupUI() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        tableView.separatorStyle = .none
    }
    
    func sortItems() {
        items.sort { item1, item2 in
            if item1.name == item2.name {
                return item1.id > item2.id
            } else {
                if let name1 = item1.name, let name2 = item2.name {
                    return name1.lowercased() < name2.lowercased()
                }
                return true
            }
        }
    }
    
}

// MARK: - Table view data source

extension ShoppingListViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath) as! ItemTableViewCell
        cell.configure(using: items[indexPath.row])
        return cell
    }
    
}

// MARK: - Table view delegate

extension ShoppingListViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        selectedIndexPath = indexPath
        performSegue(withIdentifier: "toEditScreen", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toEditScreen" {
            if let destinationVC = segue.destination as? EditItemViewController {
                if let selectedIndexPath {
                    destinationVC.currentItem = items[selectedIndexPath.row]
                }
            }
        }
    }
    
}

// MARK: - Core data

extension ShoppingListViewController {
    
    func getAllItems() {
        do {
            items = try context.fetch(ShoppingItem.fetchRequest())
        } catch {
            print("Error while fetching items.")
        }
    }
    
}


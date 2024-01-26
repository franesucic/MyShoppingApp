//
//  ItemPickerViewController.swift
//  MyShoppingApp
//
//  Created by Frane Sučić on 21.01.2024..
//

import UIKit

class ItemPickerViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var items: [ShoppingItem] = []
    var addedItem: ShoppingItem? = nil
    weak var delegate: ItemPickerDelegate?
    weak var delegate2: ItemPickerDelegate2?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupUI()
        getAllItems()
        sortItems()
        tableView.reloadData()
    }

}

// MARK: - UI setup

extension ItemPickerViewController {
    
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
                if item1.creationDateTime == item2.creationDateTime {
                    return item1.id > item2.id
                } else {
                    if let time1 = item1.creationDateTime, let time2 = item2.creationDateTime {
                        return time1 > time2
                    }
                }
            } else {
                if let name1 = item1.name, let name2 = item2.name {
                    return name1 < name2
                }
            }
            return true
        }
    }
    
}

// MARK: - Core Data

extension ItemPickerViewController {
    
    func getAllItems() {
        do {
            items = try context.fetch(ShoppingItem.fetchRequest())
        } catch {
            print("Error while fetching items.")
        }
    }
    
}

// MARK: - Table View Delegate

extension ItemPickerViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        addedItem = items[indexPath.row]
        if let addedItem {
            delegate?.updateVariable(item: addedItem)
            delegate2?.updateVariable2(item: addedItem)
        }
        navigationController?.popViewController(animated: true)
    }
    
}

// MARK: - Table View Data Source

extension ItemPickerViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemPickerCell", for: indexPath) as! PickerItemTableViewCell
        cell.configure(using: items[indexPath.row])
        return cell
    }
    
}

// MARK: - UISearchBar Delegate

extension ItemPickerViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == "" {
            getAllItems()
            tableView.reloadData()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        } else {
            items = items.filter({ elem in
                if let text = searchBar.text, let itemName = elem.name {
                    return itemName.lowercased().contains(text.lowercased())
                }
                return false
            })
            tableView.reloadData()
        }
    }
    
}

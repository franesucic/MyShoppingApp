//
//  NotesViewController.swift
//  MyShoppingApp
//
//  Created by Frane Sučić on 20.01.2024..
//

import UIKit

class NotesViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var notes: [Note] = []
    var items: [ShoppingItem] = []
    var selectedIndexPath: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getAllNotes()
        getAllItems()
        sortNotes()
        checkLinkedItemsInNotes()
        tableView.reloadData()
    }
    
}

// MARK: - UI Setup

extension NotesViewController {
    
    func setupUI() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        tableView.separatorStyle = .none
    }
    
    func sortNotes() {
        notes.sort { note1, note2 in
            if note1.title == note2.title {
                if note1.listOfLinkedItems.count == note2.listOfLinkedItems.count {
                    return note1.id > note2.id
                } else {
                    return note1.listOfLinkedItems.count > note2.listOfLinkedItems.count
                }
            } else {
                if let name1 = note1.title, let name2 = note2.title {
                    return name1 < name2
                }
            }
            return true
        }
    }
    
    func checkLinkedItemsInNotes() {
        for note in notes {
            for linkedItemId in note.listOfLinkedItems {
                var itemExists = false
                for item in items {
                    if item.id == linkedItemId {
                        itemExists = true
                    }
                }
                if !itemExists {
                    note.listOfLinkedItems.removeAll { $0 == linkedItemId }
                }
            }
        }
    }
    
}

// MARK: - Table View Data Source

extension NotesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "noteCell", for: indexPath) as! NoteTableViewCell
        selectedIndexPath = indexPath
        cell.configure(using: notes[indexPath.row])
        return cell
    }
    
}

// MARK: - Table View Delegate

extension NotesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        selectedIndexPath = indexPath
        performSegue(withIdentifier: "toEditNote", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toEditNote" {
            if let destinationVC = segue.destination as? EditNoteViewController {
                if let selectedIndexPath {
                    destinationVC.currentNote = notes[selectedIndexPath.row]
                }
            }
        }
    }
    
}

// MARK: - Core Data

extension NotesViewController {
    
    func getAllNotes() {
        do {
            notes = try context.fetch(Note.fetchRequest())
        } catch {
            print("Error while fetching notes.")
        }
    }
    
    func getAllItems() {
        do {
            items = try context.fetch(ShoppingItem.fetchRequest())
        } catch {
            print("Error while fetching notes.")
        }
    }
    
}

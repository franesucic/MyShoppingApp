//
//  EditNoteViewController.swift
//  MyShoppingApp
//
//  Created by Frane Sučić on 21.01.2024..
//

import UIKit

protocol ItemPickerDelegate2: AnyObject {
    func updateVariable2(item: ShoppingItem)
}

class EditNoteViewController: UIViewController, ItemPickerDelegate2 {
    
    var currentNote = Note()
    var changesMade = false
    var allItems: [ShoppingItem] = []
    var linkedItems: [ShoppingItem] = []
    var newLinkedItem: ShoppingItem? = nil
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var noteTextField: UITextView!
    @IBOutlet weak var tableView: UITableView!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getLinkedItems()
        tableView.reloadData()
        print(linkedItems)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let secondVC = ItemPickerViewController()
        secondVC.delegate2 = self
        getLinkedItems()
        setupUI()
    }
    
    func updateVariable2(item: ShoppingItem) {
        newLinkedItem = item
    }
    
    func getLinkedItems() {
        getAllItems()
        let linkedIds = currentNote.listOfLinkedItems
        linkedItems.removeAll()
        for i in allItems {
            if linkedIds.contains(i.id) {
                linkedItems.append(i)
            }
        }
    }
    
}

// MARK: - IBActions

extension EditNoteViewController {

    @IBAction func saveNote(_ sender: UIButton) {
        if let name = nameTextField.text, name != "", let note = noteTextField.text, note != "" {
            updateNoteCD(note: currentNote, name: name, noteText: note)
            navigationController?.popToRootViewController(animated: true)
        }
    }
    
    @IBAction func deleteNote(_ sender: UIButton) {
        deleteNoteCD(note: currentNote)
        navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func backToNotes(_ sender: UIBarButtonItem) {
        if changesMade {
            let alertController = UIAlertController(title: "Discard", message: "Are you sure you want to discard changes?", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
            let discardAction = UIAlertAction(title: "Discard", style: .destructive) { action in
                self.navigationController?.popToRootViewController(animated: true)
            }
            alertController.addAction(discardAction)
            alertController.addAction(cancelAction)
            present(alertController, animated: true)
        } else {
            navigationController?.popToRootViewController(animated: true)
        }
    }
    
    @IBAction func nameChanged(_ sender: UITextField) {
        changesMade = true
    }
    
    @IBAction func addItem(_ sender: UIButton) {
        let secondVC = ItemPickerViewController()
        secondVC.delegate2 = self
        performSegue(withIdentifier: "editNoteAddItem", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editNoteAddItem" {
            if let destinationVC = segue.destination as? ItemPickerViewController {
                destinationVC.delegate2 = self
            }
        }
    }
    
}

// MARK: - UI Setup

extension EditNoteViewController {
    
    func setupUI() {
        tableView.delegate = self
        tableView.dataSource = self
        nameTextField.text = currentNote.title
        noteTextField.text = currentNote.note
    }
    
}

// MARK: - Text View Delegate

extension EditNoteViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        changesMade = true
    }
    
}

// MARK: - Core Data

extension EditNoteViewController {
    
    func updateNoteCD(note: Note, name: String, noteText: String) {
        note.title = name
        note.note = noteText
        if let newLinkedItem, !linkedItems.contains(newLinkedItem) {
            linkedItems.append(newLinkedItem)
        }
        note.listOfLinkedItems = linkedItems.map{ $0.id }
        do {
            try context.save()
        } catch {
            print("Error while updating note.")
        }
    }
    
    func deleteNoteCD(note: Note) {
        context.delete(note)
        do {
            try context.save()
        } catch {
            print("Error while deleting note.")
        }
    }
    
    func getAllItems() {
        do {
            allItems = try context.fetch(ShoppingItem.fetchRequest())
        } catch {
            print("Error while fetching linked items.")
        }
    }
    
}

// MARK: - Table View Delegate

extension EditNoteViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

// MARK: - Table View Data Source

extension EditNoteViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentNote.listOfLinkedItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "editCell", for: indexPath)
        cell.textLabel?.text = linkedItems[indexPath.row].name
        return cell
    }
    
}



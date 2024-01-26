//
//  AddNoteViewController.swift
//  MyShoppingApp
//
//  Created by Frane Sučić on 21.01.2024..
//

import UIKit

protocol ItemPickerDelegate: AnyObject {
    func updateVariable(item: ShoppingItem)
}

class AddNoteViewController: UIViewController, ItemPickerDelegate {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var noteTextField: UITextView!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var changesMade = false
    var pickedItem: ShoppingItem? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let secondVC = ItemPickerViewController()
        secondVC.delegate = self
    }
    
    func updateVariable(item: ShoppingItem) {
        pickedItem = item
    }
    
}

// MARK: - IBActions

extension AddNoteViewController {
    
    @IBAction func saveNewNote(_ sender: UIButton) {
        if let title = noteTextField.text, title != "", let note = noteTextField.text, note != "" {
            let note = Note(context: context)
            note.id = IdGenerator.generateProductid()
            note.title = titleTextField.text
            note.note = noteTextField.text
            note.creationDateTime = Date()
            let id = pickedItem?.id
            if let id {
                note.listOfLinkedItems.append(id)
            }
            print(note)
            do {
                try context.save()
            } catch {
                print("Error while adding new note.")
            }
            navigationController?.popToRootViewController(animated: true)
        }
    }
    
    @IBAction func titleChanged(_ sender: UITextField) {
        changesMade = true
    }
    
    @IBAction func backToNotes(_ sender: UIBarButtonItem) {
        navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func pickItem(_ sender: UIButton) {
        let secondVC = ItemPickerViewController()
        secondVC.delegate = self
        performSegue(withIdentifier: "addNoteToPicker", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addNoteToPicker" {
            if let destinationVC = segue.destination as? ItemPickerViewController {
                destinationVC.delegate = self
            }
        }
    }
    
}

// MARK: - Text View Delegate

extension AddNoteViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        changesMade = true
    }
    
}

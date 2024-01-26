//
//  EditItemViewController.swift
//  MyShoppingApp
//
//  Created by Frane Sučić on 19.01.2024..
//

import UIKit

class EditItemViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var amountTextField: UITextField!
    
    var changesMade = false
    var currentItem = ShoppingItem()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
}

// MARK: - IBActions

extension EditItemViewController {
    
    @IBAction func saveItem(_ sender: UIButton) {
        if let amount = amountTextField.text, let name = nameTextField.text {
            if let amountAsDouble = Double(amount.replacingOccurrences(of: ",", with: ".")) {
                updateItemCD(item: currentItem, name: name, amount: amountAsDouble)
                navigationController?.popToRootViewController(animated: true)
            }
        }
    }
    
    @IBAction func textFieldChanged(_ sender: UITextField) {
        changesMade = true
    }
    
    @IBAction func amountFieldChanged(_ sender: UITextField) {
        changesMade = true
    }
    
    @IBAction func deleteItem(_ sender: UIButton) {
        deleteItemCD(item: currentItem)
        navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func backToHome(_ sender: UIBarButtonItem) {
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
    
}

// MARK: - Core Data

extension EditItemViewController {
    
    func deleteItemCD(item: ShoppingItem) {
        context.delete(item)
        do {
            try context.save()
        } catch {
            print("Error while deleting data")
        }
    }
    
    func updateItemCD(item: ShoppingItem, name: String, amount: Double) {
        item.name = name
        item.amount = amount
        do {
            try context.save()
        } catch {
            print("Error while editing data.")
        }
    }
    
}

// MARK: - UI Setup

extension EditItemViewController {
    
    func setupUI() {
        nameTextField.text = currentItem.name
        amountTextField.text = String(currentItem.amount).replacingOccurrences(of: ".", with: ",")
    }
    
}

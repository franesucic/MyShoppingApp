//
//  AddItemViewController.swift
//  MyShoppingApp
//
//  Created by Frane Sučić on 19.01.2024..
//

import UIKit

class AddItemViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var amountTextField: UITextField!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}

// MARK: - IBActions

extension AddItemViewController {
    
    @IBAction func saveNewItem(_ sender: UIButton) {
        if let name = nameTextField.text, let amount = amountTextField.text?.replacingOccurrences(of: ",", with: ".") {
            if name != "", amount != "" {
                if let amountAsDouble = Double(amount) {
                    createItem(name: name, amount: amountAsDouble)
                    navigationController?.popToRootViewController(animated: true)
                }
            }
        }
    }
    
    @IBAction func backToHome(_ sender: UIBarButtonItem) {
        navigationController?.popToRootViewController(animated: true)
    }
    
}

// MARK: - Core Data

extension AddItemViewController {
    
    func createItem(name: String, amount: Double) {
        let newItem = ShoppingItem(context: context)
        newItem.id = IdGenerator.generateProductid()
        newItem.name = name
        newItem.amount = amount
        newItem.creationDateTime = Date()
        do {
            try context.save()
        } catch {
            print("Error while saving data.")
        }
    }
    
}

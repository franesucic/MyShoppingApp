//
//  ItemTableViewCell.swift
//  MyShoppingApp
//
//  Created by Frane Sučić on 19.01.2024..
//

import UIKit

class ItemTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var cellView: UIView!
    
    func configure(using item: ShoppingItem) {
        self.backgroundColor = .systemGray4
        nameLabel.text = item.name
        if item.amount - Double(Int(item.amount)) != 0 {
            amountLabel.text = "Količina: \(String(format: "%g",Double(String(format: "%.3f", item.amount)) ?? 0).replacingOccurrences(of: ".", with: ","))"
        } else {
            amountLabel.text = "Količina: \(String(Int(item.amount)))"
        }
        cellView.layer.cornerRadius = 10
        
        let border = CALayer()
        border.backgroundColor = UIColor.systemGreen.cgColor
        border.frame = CGRect(x: 0, y: 0, width: cellView.layer.frame.width, height: 2)
        border.cornerRadius = 10
        cellView.layer.addSublayer(border)
    }
    
}

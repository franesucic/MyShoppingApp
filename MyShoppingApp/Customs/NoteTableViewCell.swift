//
//  NoteTableViewCell.swift
//  MyShoppingApp
//
//  Created by Frane Sučić on 21.01.2024..
//

import UIKit

class NoteTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var noteLabel: UILabel!
    @IBOutlet weak var linkedItemsLabel: UILabel!
    @IBOutlet weak var cellView: UIView!
    
    func configure(using note: Note) {
        self.backgroundColor = .systemGray4
        nameLabel.text = note.title
        noteLabel.text = "Note: " + note.note!
        linkedItemsLabel.text = "Linked items: \(note.listOfLinkedItems.count)"
        
        cellView.layer.cornerRadius = 10
        let border = CALayer()
        border.backgroundColor = UIColor.systemYellow.cgColor
        border.frame = CGRect(x: 0, y: 0, width: cellView.layer.frame.width, height: 2)
        border.cornerRadius = 10
        cellView.layer.addSublayer(border)
    }

}

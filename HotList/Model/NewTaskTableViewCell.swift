//
//  NewTaskTableViewCell.swift
//  HotList
//
//  Created by Sara Babaei on 3/16/20.
//  Copyright © 2020 Sara Babaei. All rights reserved.
//

import Foundation
import UIKit

protocol NewTaskCellDelegate {
    func newTaskCell(_ cell: NewTaskTableViewCell, newTaskCreated caption: String)
}

class NewTaskTableViewCell: UITableViewCell {
    @IBOutlet weak var textInput: UITextField!
    @IBOutlet weak var addButton: UIButton!
    
    var delegate: NewTaskCellDelegate?
    
    @IBAction func addButtonPressed(_ sender: Any) {
    }
    
    func configure(){
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configure()
    }
}

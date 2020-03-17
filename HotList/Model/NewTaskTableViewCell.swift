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

class NewTaskTableViewCell: UITableViewCell, UITextFieldDelegate {
    @IBOutlet weak var textInput: UITextField!
    @IBOutlet weak var addButton: UIButton!
    
    var delegate: NewTaskCellDelegate?
    
    @IBAction func addButtonPressed(_ sender: Any) {
        processInput()
    }
    
    @IBAction func inputTextChanged(_ sender: Any) {
        manageAddButton()
    }
    
    func processInput(){
        if let caption = fetchInput() {
            delegate?.newTaskCell(self, newTaskCreated: caption)
        }
        textInput.text = ""
        textInput.resignFirstResponder()
        manageAddButton()
    }
    
    func configure(){
        textInput.delegate = self
        manageAddButton()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configure()
    }
    
    func manageAddButton(){
        var enable = false
        if let caption = fetchInput() {
            if caption.count > 0 {  //useless?!
                enable = true
            }
        }
        addButton.isEnabled = enable
    }
    
    func fetchInput() -> String? {
        if let caption = textInput.text?.trimmingCharacters(in: .whitespaces) {
            return caption.count > 0 ? caption : nil
        }
        return nil
    }
    
    //MARK: text field delegates
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        processInput()
        return true
    }
}


//TODO: doesn't handle input

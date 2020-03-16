//
//  TaskTableViewCell.swift
//  HotList
//
//  Created by Sara Babaei on 3/16/20.
//  Copyright © 2020 Sara Babaei. All rights reserved.
//

import Foundation
import UIKit

protocol TaskCellDelegate {
    func taskCell(_ cell: TaskTableViewCell, completionChanged completion: Bool)
}

class TaskTableViewCell: UITableViewCell {

    @IBOutlet weak var checkMarkButton: UIButton!
    @IBOutlet weak var taskLabel: UILabel!

    var delegate: TaskCellDelegate?

    @IBAction func checkMarkButtonPressed(_ sender: Any) {
        markCompleted(!checkMarkButton.isSelected)
        delegate?.taskCell(self, completionChanged: checkMarkButton.isSelected)
    }

    func configure(){
        checkMarkButton.setImage(UIImage.init(named: "checkmark-off"), for: .normal)
        checkMarkButton.setImage(UIImage.init(named: "checkmark-on"), for: .selected)
    }

    override func awakeFromNib(){
        super.awakeFromNib()
        configure()
    }

    func markCompleted(_ completed: Bool){
        checkMarkButton.isSelected = completed
    }

    func setCaption(_ caption: String?){
        taskLabel.text = caption
    }
}

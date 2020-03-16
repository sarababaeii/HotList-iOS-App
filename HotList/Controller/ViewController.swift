//
//  ViewController.swift
//  HotList
//
//  Created by Sara Babaei on 3/14/20.
//  Copyright © 2020 Sara Babaei. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, TaskCellDelegate {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var progressLabel: UILabel!
    
    var priorityTasks = [HotTask]()
    var bonusTasks = [HotTask]()
    var lastDeletedTask: HotTask?
    var lastDeletedIndexPath: IndexPath?
    
    //MARK: Cells delegates
    func taskCell(_ cell: TaskTableViewCell, completionChanged completion: Bool){
        if let indexPath = tableView.indexPath(for: cell) {
            if let task = hotTaskDataSource(indexPath: indexPath) {
                task.completed = completion
                updateProgress()
            }
        }
    }
    
    //MARK: TableView delegates
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return priorityTasks.count
        case 2:
            return bonusTasks.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "NewTaskCellID", for: indexPath)
            return cell
        case 1, 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCellID", for: indexPath) as! TaskTableViewCell
            let task = hotTaskDataSource(indexPath: indexPath)
            cell.setCaption(task?.caption)
            cell.delegate = self
            return cell
        default:
            return UITableViewCell.init()
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 1:
            return "Top Priority"
        case 2:
            return "Bonus"
        default:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        switch indexPath.section {
        case 0:
            return false
        default:
            return true
        }
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        var actions: [UITableViewRowAction]?
        var moveCaption: String?
        var moveToIndexPath: IndexPath?
        
        switch indexPath.section {
        case 1:
            moveCaption = "Move to Bonus"
            moveToIndexPath = IndexPath(row: 0, section: 2)
        case 2:
            moveCaption = "Move to Priority"
            moveToIndexPath = IndexPath(row: 0, section: 1)
        default:
            return actions
        }
        
        if let task = hotTaskDataSource(indexPath: indexPath){
            let delete = UITableViewRowAction(style: .destructive, title: "Delete"){
                (actions, indexPath) in
                self.deleteTask(at: indexPath)
            }
            let move = UITableViewRowAction(style: .normal, title: moveCaption){
                (actions, indexPath) in
                task.priority = (task.priority == .top) ? .bonus : .top
                self.deleteTask(at: indexPath)
                self.insertTask(task, at: moveToIndexPath)
            }
            actions = [delete, move]
        }
        return actions
    }
    
    func insertTask(_ task: HotTask?, at indexPath: IndexPath?){
        if let task = task, let indexPath = indexPath{
            tableView.beginUpdates()
            
            if indexPath.section == 1 {
                priorityTasks.insert(task, at: indexPath.row)
            }
            else{
                bonusTasks.insert(task, at: indexPath.row)
            }
            
            tableView.insertRows(at: [indexPath], with: .automatic)
         
            deleteBackup()
            updateProgress()
            
            tableView.endUpdates()
        }
    }
    
    func deleteTask(at indexPath: IndexPath?){
        if let indexPath = indexPath{
            tableView.beginUpdates()
            
            lastDeletedIndexPath = indexPath
            
            if indexPath.section == 1 {
                lastDeletedTask = priorityTasks[indexPath.row]
                priorityTasks.remove(at: indexPath.row)
            }
            else{
                lastDeletedTask = bonusTasks[indexPath.row]
                bonusTasks.remove(at: indexPath.row)
            }
            
            tableView.deleteRows(at: [indexPath], with: .automatic)
          
            updateProgress()
            
            tableView.endUpdates()
        }
    }
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            if lastDeletedTask != nil{
               let alertController = UIAlertController(title: "Undo action", message: "Are you sure you want to restore the item you just deleted?", preferredStyle: .alert)
                
                let undoAction = UIAlertAction(title: "Undo", style: .default){
                    (action) in
                    self.undo()
                }
                alertController.addAction(undoAction)
                
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel){
                    (action) in
                    self.deleteBackup()
                }
                alertController.addAction(cancelAction)
                
                present(alertController, animated: true)
            }
        }
    }
    
    func undo(){
        insertTask(lastDeletedTask, at: lastDeletedIndexPath)
    }
    
    func deleteBackup(){
        lastDeletedTask = nil
        lastDeletedIndexPath = nil
    }
    
    func hotTaskDataSource(indexPath: IndexPath) -> HotTask? {
        switch indexPath.section {
        case 1:
            return priorityTasks[indexPath.row]
        case 2:
            return bonusTasks[indexPath.row]
        default:
            return nil
        }
    }
    
    func updateProgress(){
        let totalTasks = priorityTasks.count + bonusTasks.count
        let completedTasks = priorityTasks.filter{ (task) -> Bool in
            return task.completed == true
        }.count + bonusTasks.filter{ (task) -> Bool in
            return task.completed == true
        }.count
        var caption = "What's going on?"
        
        if totalTasks == 0 {
            caption = "It's lonely here - add some tasks!"
        }
        else if completedTasks == 0{
            caption = "Get started - \(totalTasks) to go!"
        }
        else if completedTasks == totalTasks{
            caption = "Well done - \(totalTasks) completed!"
        }
        else{
            caption = "\(completedTasks) down - \(totalTasks - completedTasks) to go!"
        }
        
        progressLabel.text = caption
    }
    
    func populateInitialTasks(){
        priorityTasks.removeAll()
        
        priorityTasks.append(HotTask.init(caption: "Pickup MacBook Pro from Apple store"))
        priorityTasks.append(HotTask.init(caption: "Practice Japanese"))
        priorityTasks.append(HotTask.init(caption: "Buy ingrediants for a cake for Alie's bday"))
        
        bonusTasks.removeAll()
        
        let hotTask = HotTask.init(caption: "Shop for funnky socks")
        hotTask.priority = .bonus
        bonusTasks.append(hotTask)
    }
    
    func configure() {
        tableView.delegate = self
        tableView.dataSource = self
        
        populateInitialTasks()
        
        updateProgress()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        configure()
    }
}

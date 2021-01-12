//
//  ToDoTableViewController.swift
//  SimpleToDoApp_rev
//
//  Created by Yumi Machino on 2021/01/11.
//

import UIKit

class ToDoTableViewController: UITableViewController, AddEditToDoDelegate {
    var cellId = "toDoItemCell"
    
//    var toDoItems: [ToDoItem] = [
//        ToDoItem(title:"Take a walk", priorityLevel: priorityLevel.high, isCompletedIndicator: false),
//        ToDoItem(title:"Study Design pattern", priorityLevel: priorityLevel.high, isCompletedIndicator: false),
//        ToDoItem(title:"Study iOS", priorityLevel: priorityLevel.medium, isCompletedIndicator: false),
//        ToDoItem(title:"Update Resume", priorityLevel: priorityLevel.medium, isCompletedIndicator: false),
//        ToDoItem(title:"Watch Netflix", priorityLevel: priorityLevel.low, isCompletedIndicator: false),
//        ToDoItem(title:"Finish Unit6", priorityLevel: priorityLevel.high, isCompletedIndicator: false),
//        ToDoItem(title:"Do laundry", priorityLevel: priorityLevel.medium, isCompletedIndicator: false),
//        ToDoItem(title:"Go to grocery shopping", priorityLevel: priorityLevel.low, isCompletedIndicator: false)
//    ]
    var toDoItems: [ToDoItem] = [
        ToDoItem(title:"Take a walk", priorityLevel: priorityLevel.high, isCompletedIndicator: false),
        ToDoItem(title:"Study Design pattern", priorityLevel: priorityLevel.medium, isCompletedIndicator: false),
        ToDoItem(title:"Study iOS", priorityLevel: priorityLevel.low, isCompletedIndicator: false)]
    
    var sections:[String] = ["High Priority", "Medium Priority", "Low Priority"]
    
    var highPriorityItems:[ToDoItem] = []
    var mediumPriorityItems:[ToDoItem] = []
    var lowPriorityItems:[ToDoItem] = []
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "ToDo Items"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addToDoItem))
        navigationItem.leftBarButtonItem = editButtonItem
        
        tableView.register(ToDoItemTableViewCell.self, forCellReuseIdentifier: cellId)
        sortItems()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    func toDoItemsUpdate(){
        toDoItems = []
        toDoItems = highPriorityItems + mediumPriorityItems + lowPriorityItems
    }

    
    @objc
    func addToDoItem(){
        let addEditTVC = AddEditToDoItemTableViewController()
        addEditTVC.delegate = self
        let addEditNC = UINavigationController(rootViewController: addEditTVC)
        present(addEditNC, animated: true, completion: nil)
    }
    
    // AddEditToDoDelegate method
    func add(_ toDoItem: ToDoItem){
        // update model
        switch toDoItem.priorityLevel {
        case .high:
            highPriorityItems.append(toDoItem)
            // update view
            tableView.insertRows(at: [IndexPath(row: highPriorityItems.count - 1, section: 0)], with: .automatic)
        case .medium:
            mediumPriorityItems.append(toDoItem)
            tableView.insertRows(at: [IndexPath(row: mediumPriorityItems.count - 1, section: 1)], with: .automatic)
        case .low:
            lowPriorityItems.append(toDoItem)
            tableView.insertRows(at: [IndexPath(row: lowPriorityItems.count - 1, section: 2)], with: .automatic)
        }
        toDoItemsUpdate()
        dismiss(animated: true, completion: nil)
    }
    
    func edit(_ toDoItem: ToDoItem) {
        // title , priority
        // grab data from selected index path
        // update model, update view
        // remove data, insert/append data, update view
        print("edit")
       
        if let indexPath = tableView.indexPathForSelectedRow {
            print(indexPath)
            switch indexPath.section {
            case 0:
                if let row = tableView.indexPathForSelectedRow?.row {
                    highPriorityItems.remove(at: row)
                }
                // Add edit segment ctrl func で obserbe
                if toDoItem.priorityLevel == .high {
                    highPriorityItems.insert(toDoItem, at: highPriorityItems.count - 1)
                } else if toDoItem.priorityLevel == .medium {
                        mediumPriorityItems.append(toDoItem)
                } else if toDoItem.priorityLevel == .low {
                        lowPriorityItems.append(toDoItem)
                } else {
                        fatalError()
                }
                    
                tableView.reloadData()
//                    tableView.reloadRows(at: [indexPath], with: .automatic)
                tableView.deselectRow(at: indexPath, animated: true)
                print(lowPriorityItems)
                    
//            case 1:
//                if let row = tableView.indexPathForSelectedRow?.row {
//                    mediumPriorityItems.remove(at: row)
//                    if toDoItem.priorityLevel == .high {
//                        highPriorityItems.insert(toDoItem, at: highPriorityItems.count - 1)
//                    } else if toDoItem.priorityLevel == .medium {
//                        mediumPriorityItems.insert(toDoItem, at: mediumPriorityItems.count - 1)
//                    } else if toDoItem.priorityLevel == .low {
//                        lowPriorityItems.insert(toDoItem, at: lowPriorityItems.count - 1)
//                    } else {
//                        fatalError()
//                    }
//
//
//                    tableView.reloadRows(at: [indexPath], with: .automatic)
//                    tableView.deselectRow(at: indexPath, animated: true)
//                    }
//            case 2:
//                if let row = tableView.indexPathForSelectedRow?.row {
//                    lowPriorityItems.remove(at: row)
//                    if toDoItem.priorityLevel == .high {
//                        highPriorityItems.insert(toDoItem, at: highPriorityItems.count - 1)
//                    } else if toDoItem.priorityLevel == .medium {
//                        mediumPriorityItems.insert(toDoItem, at: mediumPriorityItems.count - 1)
//                    } else if toDoItem.priorityLevel == .low {
//                        lowPriorityItems.insert(toDoItem, at: lowPriorityItems.count - 1)
//                    } else {
//                        fatalError()
//                    }
//
//
//                    tableView.reloadRows(at: [indexPath], with: .automatic)
//                    tableView.deselectRow(at: indexPath, animated: true)
//                    }
            default:
                fatalError("Error")
            }
            
        }
            toDoItemsUpdate()
            dismiss(animated: true, completion: nil)
            print(toDoItems)
        }
    
    

    
    
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    // ROW COUNT PER SECTION
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return highPriorityItems.count
        case 1:
            return mediumPriorityItems.count
        case 2:
            return lowPriorityItems.count
        default:
            return 0
        }
    }
    
    // SORT ITEMS PER PRIORITY
    func sortItems(){
        for item in toDoItems {
            if item.priorityLevel == .high {
                highPriorityItems.append(item)
            } else if item.priorityLevel == .medium {
                mediumPriorityItems.append(item)
            } else if item.priorityLevel == .low {
                lowPriorityItems.append(item)
            } else {
                print("no priority defined")
            }
        }
    }
    
  
    // DEQUE REUSABLE CELL
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ToDoItemTableViewCell
        cell.showsReorderControl = true
        
        switch indexPath.section {
        case 0:
            // Fetch data
            let toDoItem = highPriorityItems[indexPath.row]
            // configure cell
            cell.update(with: toDoItem)
            cell.accessoryType = .detailDisclosureButton
            return cell
        case 1:
            // Fetch data
            let toDoItem = mediumPriorityItems[indexPath.row]
            // configure cell
            cell.accessoryType = .detailDisclosureButton
            cell.update(with: toDoItem)
            return cell
        case 2:
            // Fetch data
            let toDoItem = lowPriorityItems[indexPath.row]
            // configure cell
            cell.accessoryType = .detailDisclosureButton
            cell.update(with: toDoItem)
            return cell
        default:
            fatalError("no item found")
        }
    }

    // SECTION HEADER
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }
    
    // DELETE
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        guard editingStyle == .delete else {return }
        switch indexPath.section {
        case 0:
            // update model
            highPriorityItems.remove(at: indexPath.row)
        case 1:
            mediumPriorityItems.remove(at: indexPath.row)
        case 2:
            lowPriorityItems.remove(at: indexPath.row)
        default:
            fatalError()
        }
        // update view
        tableView.deleteRows(at: [indexPath], with: .automatic)
        toDoItemsUpdate()
    }
   
    
    
    // When Accessory button tapped
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        // go to Add edit screen
        let addEditTVC = AddEditToDoItemTableViewController(style: .insetGrouped)
        addEditTVC.delegate = self
        let addEditNC = UINavigationController(rootViewController: addEditTVC)
        present(addEditNC, animated: true, completion: nil)
        
    
        switch indexPath.section {
        case 0:
            addEditTVC.item = highPriorityItems[indexPath.row]
        case 1:
            addEditTVC.item = mediumPriorityItems[indexPath.row]
        case 2:
            addEditTVC.item = lowPriorityItems[indexPath.row]
        default:
            fatalError("no item found")
        }
    }
}

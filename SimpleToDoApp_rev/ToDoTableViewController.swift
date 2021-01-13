//
//  ToDoTableViewController.swift
//  SimpleToDoApp_rev
//
//  Created by Yumi Machino on 2021/01/11.
//

import UIKit

class ToDoTableViewController: UITableViewController, AddEditToDoDelegate {
    var cellId = "toDoItemCell"
    
    var toDoItems: [ToDoItem] = [
        ToDoItem(title:"Take a walk", priorityLevel: priorityLevel.high, isCompletedIndicator: false),
        ToDoItem(title:"Study Design pattern", priorityLevel: priorityLevel.high, isCompletedIndicator: false),
        ToDoItem(title:"Study iOS", priorityLevel: priorityLevel.medium, isCompletedIndicator: false),
        ToDoItem(title:"Update Resume", priorityLevel: priorityLevel.medium, isCompletedIndicator: false),
        ToDoItem(title:"Watch Netflix", priorityLevel: priorityLevel.low, isCompletedIndicator: false),
        ToDoItem(title:"Finish Unit6", priorityLevel: priorityLevel.high, isCompletedIndicator: false),
        ToDoItem(title:"Do laundry", priorityLevel: priorityLevel.medium, isCompletedIndicator: false),
        ToDoItem(title:"Go to grocery shopping", priorityLevel: priorityLevel.low, isCompletedIndicator: false)
    ]
    
    var sections:[String] = ["High Priority", "Medium Priority", "Low Priority"]
    
    var highPriorityItems:[ToDoItem] = []
    var mediumPriorityItems:[ToDoItem] = []
    var lowPriorityItems:[ToDoItem] = []
    
    lazy var navTrashButton = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(didPressDelete))
    lazy var addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addToDoItem))

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "ToDo Items"

        navigationItem.rightBarButtonItems = [addButton, navTrashButton]
        navigationItem.leftBarButtonItem = editButtonItem
        navTrashButton.isEnabled = false
       
        // register custom TableViewCell
        tableView.register(ToDoItemTableViewCell.self, forCellReuseIdentifier: cellId)
        sortItems()
        
        // multiple deletion
        tableView.allowsMultipleSelectionDuringEditing = true
    }

    
    @objc
    func didPressDelete(_ sender: UIButton) {
        // selected IndexPath
        if let selectedIndexPaths = tableView.indexPathsForSelectedRows {
            for selectedIndexPath in selectedIndexPaths {
                switch selectedIndexPath.section {
                case 0:
                    highPriorityItems.remove(at: selectedIndexPath.row)
                    tableView.deleteRows(at: [selectedIndexPath], with: .automatic)
                case 1:
                    mediumPriorityItems.remove(at: selectedIndexPath.row)
                    tableView.deleteRows(at: [selectedIndexPath], with: .automatic)
                case 2:
                    lowPriorityItems.remove(at: selectedIndexPath.row)
                    tableView.deleteRows(at: [selectedIndexPath], with: .automatic)
                default:
                 fatalError()
                }
            }
            toDoItemsUpdate()
        }
        navTrashButton.isEnabled = false
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
    
    func edit(_ toDoItem: ToDoItem, _ originalIndexPath: IndexPath, _  originalPriorityLevel: priorityLevel) {
        // remove data, insert/append data, update view
        let section = originalIndexPath.section
        let row = originalIndexPath.row
        // when priority not changed
        if toDoItem.priorityLevel == originalPriorityLevel {
            switch section {
            case 0:
                highPriorityItems.remove(at: row)
                highPriorityItems.insert(toDoItem, at: row)
                tableView.reloadRows(at: [originalIndexPath], with: .automatic)
                tableView.deselectRow(at: originalIndexPath, animated: true)
            case 1:
                mediumPriorityItems.remove(at: row)
                mediumPriorityItems.insert(toDoItem, at: row)
                tableView.reloadRows(at: [originalIndexPath], with: .automatic)
                tableView.deselectRow(at: originalIndexPath, animated: true)
            case 2:
                lowPriorityItems.remove(at: row)
                lowPriorityItems.insert(toDoItem, at: row)
                tableView.reloadRows(at: [originalIndexPath], with: .automatic)
                tableView.deselectRow(at: originalIndexPath, animated: true)
            default:
                fatalError()
            }
        } else {
            //when priority is edited
                switch section {
                case 0:
                    // remove element, and delete row
                    highPriorityItems.remove(at: row)
                    tableView.deleteRows(at: [IndexPath(row: row, section: 0)], with: .automatic)
                    if toDoItem.priorityLevel == .medium {
                        mediumPriorityItems.append(toDoItem)
                        tableView.insertRows(at: [IndexPath(row: mediumPriorityItems.count - 1, section: 1)], with: .automatic)
                    }
                    if toDoItem.priorityLevel == .low {
                        lowPriorityItems.append(toDoItem)
                        tableView.insertRows(at: [IndexPath(row: lowPriorityItems.count - 1, section: 2)], with: .automatic)
                    }
                case 1:
                    mediumPriorityItems.remove(at: row)
                    tableView.deleteRows(at: [IndexPath(row: row, section: 1)], with: .automatic)
                    if toDoItem.priorityLevel == .high {
                        highPriorityItems.append(toDoItem)
                        tableView.insertRows(at: [IndexPath(row: highPriorityItems.count - 1, section: 0)], with: .automatic)
                    }
                    if toDoItem.priorityLevel == .low {
                        lowPriorityItems.append(toDoItem)
                        tableView.insertRows(at: [IndexPath(row: lowPriorityItems.count - 1, section: 2)], with: .automatic)
                    }
                case 2:
                    lowPriorityItems.remove(at: row)
                    tableView.deleteRows(at: [IndexPath(row: row, section: 2)], with: .automatic)
                    if toDoItem.priorityLevel == .high {
                        highPriorityItems.append(toDoItem)
                        tableView.insertRows(at: [IndexPath(row: highPriorityItems.count - 1, section: 0)], with: .automatic)
                    }
                    if toDoItem.priorityLevel == .medium {
                        mediumPriorityItems.append(toDoItem)
                        tableView.insertRows(at: [IndexPath(row: mediumPriorityItems.count - 1, section: 1)], with: .automatic)
                    }
                default:
                    fatalError()
                }
            tableView.deselectRow(at: originalIndexPath, animated: true)
        }
        toDoItemsUpdate()
        dismiss(animated: true, completion: nil)
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
   
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         if isEditing  == true {
            navTrashButton.isEnabled = true
         } else {
            navTrashButton.isEnabled = false
         }
    }
    
    // When Accessory button tapped
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        // go to Add edit screen
        let addEditTVC = AddEditToDoItemTableViewController(style: .insetGrouped)
        addEditTVC.delegate = self
        let addEditNC = UINavigationController(rootViewController: addEditTVC)
        present(addEditNC, animated: true, completion: nil)
        
        // store original indexPath
        addEditTVC.originalIndexPath = indexPath
        
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
    
    // MOVE ROW: use with showsReorderControl
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {

        // Update model
        switch sourceIndexPath.section {
        case 0:
            var removeItem = highPriorityItems.remove(at: sourceIndexPath.row)
            switch destinationIndexPath.section {
            case 0:
                highPriorityItems.insert(removeItem, at: destinationIndexPath.row)
            case 1:
                removeItem.priorityLevel = .medium
                mediumPriorityItems.insert(removeItem, at: destinationIndexPath.row)
            case 2:
                removeItem.priorityLevel = .low
                lowPriorityItems.insert(removeItem, at: destinationIndexPath.row)
            default:
                fatalError()
            }
        case 1:
            var removeItem = mediumPriorityItems.remove(at: sourceIndexPath.row)
            switch destinationIndexPath.section {
            case 0:
                removeItem.priorityLevel = .high
                highPriorityItems.insert(removeItem, at: destinationIndexPath.row)
            case 1:
                mediumPriorityItems.insert(removeItem, at: destinationIndexPath.row)
            case 2:
                removeItem.priorityLevel = .low
                lowPriorityItems.insert(removeItem, at: destinationIndexPath.row)
            default:
                fatalError()
            }
        case 2:
            var removeItem = lowPriorityItems.remove(at: sourceIndexPath.row)
            switch destinationIndexPath.section {
            case 0:
                removeItem.priorityLevel = .high
                highPriorityItems.insert(removeItem, at: destinationIndexPath.row)

            case 1:
                removeItem.priorityLevel = .medium
                mediumPriorityItems.insert(removeItem, at: destinationIndexPath.row)
            case 2:
                lowPriorityItems.insert(removeItem, at: destinationIndexPath.row)
            default:
                fatalError()
            }
        default:
            fatalError()
        }
        // update model
        toDoItemsUpdate()
    }
}

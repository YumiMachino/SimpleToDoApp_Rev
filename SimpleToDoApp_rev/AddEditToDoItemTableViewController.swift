//
//  AddEditToDoItemTableViewController.swift
//  SimpleToDoApp_rev
//
//  Created by Yumi Machino on 2021/01/11.
//

import UIKit

protocol AddEditToDoDelegate: class {
    func add(_ toDoItem: ToDoItem)
    func edit(_ toDoItem: ToDoItem, _ originalIndexPath: IndexPath, _ originalPriorityLevel: priorityLevel)
}


class AddEditToDoItemTableViewController: UITableViewController {
    
    let sections:[String] = ["ToDo item", "Priority"]
    
    let saveButton =  UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveToDoItem))
    
    var item: ToDoItem?
    var originalIndexPath: IndexPath?
 
    // receive those whose delegate
    weak var delegate: AddEditToDoDelegate?
    
    // prepare cell to use (no deque reusable cell)
    var titleCell = AddEditTableViewCell()
    var segmentControlCell = SegmentCtrlTableViewCell()
    
    var itemPriorityLevel: priorityLevel?

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        
        if item == nil {
            title = "Add ToDo Item"
        } else {
            title = "Edit ToDo Item"
            titleCell.textField.text = item?.title
            switch item?.priorityLevel {
            case .high:
                segmentControlCell.segmentControl.selectedSegmentIndex = 0
            case .medium:
                segmentControlCell.segmentControl.selectedSegmentIndex = 1
            case .low:
                segmentControlCell.segmentControl.selectedSegmentIndex = 2
            default:
                fatalError()
            }
        }
        segmentControlCell.segmentControl.addTarget(self, action: #selector(segmentControlValueChanged(_:)), for: .touchUpInside)
        // navigation buttons
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismissTVC))
        navigationItem.rightBarButtonItem = saveButton
        updateSaveBtnState()
        // Observe text field
        titleCell.textField.addTarget(self, action: #selector(textEditingChanged(_:)), for: .editingChanged)
    }
    
    // priority might change while editing ?
    @objc
    func segmentControlValueChanged(_ sender : UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            item?.priorityLevel = .high
        } else if sender.selectedSegmentIndex == 1 {
            item?.priorityLevel = .medium
        }else if sender.selectedSegmentIndex == 2 {
            item?.priorityLevel = .low
        } else {
            fatalError()
        }
    }
    
    func segmentValue() -> priorityLevel {
        switch segmentControlCell.segmentControl.selectedSegmentIndex {
        case 0:
            return priorityLevel.high
        case 1:
            return priorityLevel.medium
        case 2:
            return priorityLevel.low
        default:
            fatalError("Error - no priority defined")
        }
    }
    
    @objc
    func dismissTVC(){
        dismiss(animated: true, completion: nil)
    }
    
    @objc
    func saveToDoItem(){
        // create an item, add to model
        let newItem = ToDoItem(title: titleCell.textField.text!, priorityLevel: segmentValue() , isCompletedIndicator: false)
        // update model
        if item == nil {
            delegate?.add(newItem)
        } else {
            //original priorityとoriginal path
            if let originalPriority = item?.priorityLevel, let originalIndexPath = originalIndexPath  {
            delegate?.edit(newItem, originalIndexPath, originalPriority )
            }
        }
    }
            
    func updateSaveBtnState(){
        saveButton.isEnabled = checkText(titleCell.textField)
        
    }

    private func checkText(_ textField: UITextField) -> Bool {
        guard let text = titleCell.textField.text, text.count >= 1 else {return false}
        return true
    }
    
    @objc
    func textEditingChanged(_ sender: UITextField) {
        updateSaveBtnState()
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath {
        case [0, 0]:
            return titleCell
        case [1, 0]:
            return segmentControlCell
        default:
            fatalError("Error")
        }
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath {
        case [0, 0]:
            return 80
        case [1, 0]:
            return 100
        default:
            return 44.0
        }
    }
}
    


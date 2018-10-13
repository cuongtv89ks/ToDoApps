//
//  ViewController.swift
//  ToDoApps
//
//  Created by Olive Union on 29/09/2018.
//  Copyright © 2018 Olive Union. All rights reserved.
//

import UIKit

class ChecklistViewController: UITableViewController {
    
    var toDoList : ToDoList
    var tableData : [[ChecklistItem?]?]!
    
    required init?(coder aDecoder: NSCoder) {
        toDoList = ToDoList()
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.leftBarButtonItem = editButtonItem
        tableView.allowsMultipleSelectionDuringEditing = true
        
        let sectionTableCount = UILocalizedIndexedCollation.current().sectionTitles.count
        var allSections = [[ChecklistItem?]?](repeating: nil, count: sectionTableCount)
        var sectionNumbers = 0
        let collation = UILocalizedIndexedCollation.current()
        for item in toDoList.toDos {
            sectionNumbers = collation.section(for: item, collationStringSelector: #selector(getter: ChecklistItem.text))
            if allSections[sectionNumbers] == nil {
                allSections[sectionNumbers] = [ChecklistItem?]()
            }
            allSections[sectionNumbers]!.append(item)
        }
        tableData = allSections
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: true)
        tableView.setEditing(tableView.isEditing, animated: true)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData[section] == nil ? 0 : tableData[section]!.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChecklistItem", for: indexPath)
        //let item = toDoList.toDos[indexPath.row]
        if let item = tableData[indexPath.section]?[indexPath.row] {
            configureText(for: cell, with: item)
            configureCheckMark(for: cell, with: item)
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.isEditing {
            return
        }
        if let cell = tableView.cellForRow(at: indexPath) {
            let item = toDoList.toDos[indexPath.row]
            item.toogleChecked()
            configureCheckMark(for: cell, with: item)
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        toDoList.toDos.remove(at: indexPath.row)
        
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
        
//        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        toDoList.move(item: toDoList.toDos[sourceIndexPath.row], to: destinationIndexPath.row)
        tableView.reloadData()
    }
    
    @IBAction func addItem(_ sender: Any) {
        let newRowIndex = toDoList.toDos.count
        _ = toDoList.newToDo()
        
        let indexPath = IndexPath(row: newRowIndex, section: 0)
        let indexPaths = [indexPath]
        
        tableView.insertRows(at: indexPaths, with: .automatic)
    }
    
    func configureText(for cell: UITableViewCell, with item: ChecklistItem) {
        if let checklistCell = cell as? ChecklistTableViewCell {
            checklistCell.todoTextLabel.text = item.text
        }
    }
    
    @IBAction func deleteItems(_ sender: Any) {
        if let selectedRows = tableView.indexPathsForSelectedRows {
            var items = [ChecklistItem]()
            for indexPath in selectedRows {
                items.append(toDoList.toDos[indexPath.row])
            }
            toDoList.remove(items: items)
            tableView.beginUpdates()
            tableView.deleteRows(at: selectedRows, with: .automatic)
            tableView.endUpdates()
        }
    }
    
    func configureCheckMark(for cell: UITableViewCell, with item: ChecklistItem) {
        guard let checklistCell = cell as? ChecklistTableViewCell else {
            return
        }
        if item.checked {
            checklistCell.checkmarkLabel.text = "√"
        } else {
            checklistCell.checkmarkLabel.text = ""
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddItemSegue" {
            if let addItemViewController = segue.destination as? ItemDetailViewController {
                addItemViewController.delegate = self
                addItemViewController.todoList = toDoList
            }
        } else if (segue.identifier == "EditItemSegue") {
                if let addItemViewController = segue.destination as? ItemDetailViewController {
                if let cell = sender as? UITableViewCell,
                    let indexPath = tableView.indexPath(for: cell) {
                    let item = toDoList.toDos[indexPath.row]
                    addItemViewController.itemToEdit = item
                    addItemViewController.delegate = self
                }
            }
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return tableData.count
    }
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return UILocalizedIndexedCollation.current().sectionTitles
    }
    
    override func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        return UILocalizedIndexedCollation.current().section(forSectionIndexTitle: index)
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return UILocalizedIndexedCollation.current().sectionTitles[section]
    }
}

extension ChecklistViewController: ItemDetailViewControllerDelegate {
    func itemDetailViewControllerDidCancel(_ controller: ItemDetailViewController) {
        navigationController?.popViewController(animated: true)
    }
    
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishAdding item: ChecklistItem) {
        navigationController?.popViewController(animated: true)
        
        let newRowIndex = toDoList.toDos.count - 1
        //toDoList.toDos.append(item)
        let indexPath = IndexPath(row: newRowIndex, section: 0)
        let indexPaths = [indexPath]
        tableView.insertRows(at: indexPaths, with: .automatic)
        
    }
    
    func addItemViewController(_ controller: ItemDetailViewController, didFinishEditing item: ChecklistItem) {
        if let index = toDoList.toDos.index(of: item) {
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = tableView.cellForRow(at: indexPath) {
                configureText(for: cell, with: item)
            }
        }
        navigationController?.popViewController(animated: true)
    }
    
    
}

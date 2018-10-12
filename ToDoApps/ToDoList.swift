//
//  ToDoList.swift
//  ToDoApps
//
//  Created by Olive Union on 03/10/2018.
//  Copyright © 2018 Olive Union. All rights reserved.
//

import Foundation


class ToDoList {
    var toDos: [ChecklistItem] = []
    
    init() {
        let row0Item = ChecklistItem()
        let row1Item = ChecklistItem()
        let row2Item = ChecklistItem()
        let row3Item = ChecklistItem()
        let row4Item = ChecklistItem()
        
        row0Item.text = "Take a jog"
        row1Item.text = "Watch a movie"
        row2Item.text = "Do excercise"
        row3Item.text = "Let's play game"
        row4Item.text = "Walk the dog"
        
        toDos.append(row0Item)
        toDos.append(row1Item)
        toDos.append(row2Item)
        toDos.append(row3Item)
        toDos.append(row4Item)
    }
    
    func newToDo() -> ChecklistItem {
        let item = ChecklistItem()
        item.checked = true
        item.text = randomDescription()
        toDos.append(item)
        return item
    }
    
    func move(item: ChecklistItem, to index: Int) {
        guard let currentIndex = toDos.index(of: item) else {
            return
        }
        toDos.remove(at: currentIndex)
        toDos.insert(item, at: index)
    }
    
    func remove(items: [ChecklistItem]){
        for item in items {
            if let index = toDos.index(of: item) {
                toDos.remove(at: index)
            }
        }
    }
    
    private func randomDescription() -> String {
        let title = ["New todo item",
                     "Generic todo",
                     "Fill me out",
                     "I need something to do",
                     "Much to do nothing"]
        let randomIndex = Int.random(in: 0...(title.count-1))
        return title[randomIndex]
    }
}

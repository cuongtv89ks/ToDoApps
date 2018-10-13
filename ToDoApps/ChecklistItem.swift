//
//  ChecklistItem.swift
//  ToDoApps
//
//  Created by Olive Union on 30/09/2018.
//  Copyright © 2018 Olive Union. All rights reserved.
//

import Foundation


class ChecklistItem: NSObject {
    @objc var text = ""
    var checked = false
    
    func toogleChecked() {
        checked = !checked
    }
}

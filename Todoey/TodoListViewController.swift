//
//  ViewController.swift
//  Todoey
//
//  Created by Hongbo Niu on 2018-01-24.
//  Copyright © 2018 Hongbo Niu. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    let itemArray = ["Find Mike", "Buy Eggs", "Destroy somth"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    //MARK: - Tableview Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row]
        return cell
    }
    
    //MARK: - Tableview Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let cell = tableView.cellForRow(at: indexPath)
        
        if let text = cell?.textLabel?.text! {
            print(text)
        }
        
        if(cell?.accessoryType == .checkmark){
            cell?.accessoryType = .none
        }else{
            cell?.accessoryType = .checkmark
        }

        tableView.deselectRow(at: indexPath, animated: true)
    }
}


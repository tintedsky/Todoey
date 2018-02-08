//
//  ViewController.swift
//  Todoey
//
//  Created by Hongbo Niu on 2018-01-24.
//  Copyright © 2018 Hongbo Niu. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListViewController: UITableViewController {
    var todoItems:Results<Item>?
    let realm = try! Realm()
    /*Here we load items only when we have real values for todoItems*/
    var selectedCategory:Category?{
        didSet{
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
    }

    //MARK: - Tableview Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        if let item = todoItems?[indexPath.row]{
            cell.textLabel?.text = item.title
            cell.accessoryType = item.isDone ? .checkmark : .none
        }else{
            cell.textLabel?.text = "No items added yet"
        }

        return cell
    }
    
    //MARK: - Tableview Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let item = todoItems?[indexPath.row]{ //Here assigned reference, not a copy
            do{
                try realm.write {
                    item.isDone = !(item.isDone)
                }
            }catch{
                print("Error flipping over item.isdone, \(error)")
            }
        }
        
        tableView.reloadData()

        /* Select the current row after saving items */
        tableView.selectRow(at: indexPath, animated: true, scrollPosition: UITableViewScrollPosition(rawValue: indexPath.row)!)
    }
    
    //MARK: - manipulate new items
    @IBAction func removeItem(_ sender: UIBarButtonItem) {
        if let indexpath = tableView.indexPathForSelectedRow {
            if let item = todoItems?[indexpath.row]{
                do{
                    try realm.write{
                        realm.delete(item)
                    }
                }catch{
                    print("Error deleting item \(error)")
                }
                tableView.reloadData()
            }

        }
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()

        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)

        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create a item"
            //Here add a new reference, essence for today!!!
            textField = alertTextField
        }

        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //what will happen once the button "Add Item" is clicked.
            if let text = textField.text {
                if !text.isEmpty {
                    if let category = self.selectedCategory{
                        do {
                            try self.realm.write{
                                let newItem = Item()
                                newItem.title = text
                                newItem.date = Date()
                                category.items.append(newItem)
                            }
                        }catch{
                            print("Error saving new items, \(error)")
                        }
                    }
                    
                    self.tableView.reloadData()
                }
            }
        }

        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    // Add itemArray to encoder
    
    func loadItems(){
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)

        tableView.reloadData()
    }
}

//MARK: - Search Bar Methods

extension TodoListViewController:UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "date", ascending: true)
        tableView.reloadData()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}

//
//  ViewController.swift
//  Todoey
//
//  Created by Hongbo Niu on 2018-01-24.
//  Copyright © 2018 Hongbo Niu. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {
    var itemArray = [Item]()
    
    /*Here we load items only when we have real values for itemArray*/
    var selectedCategory:Category?{
        didSet{
            loadItems()
        }
    }
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
    }

    //MARK: - Tableview Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
        cell.accessoryType = item.isDone ? .checkmark : .none
        return cell
    }
    
    //MARK: - Tableview Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        itemArray[indexPath.row].isDone = !itemArray[indexPath.row].isDone
        saveItems()
        
        /* Select the current row after saving items */
        tableView.selectRow(at: indexPath, animated: true, scrollPosition: UITableViewScrollPosition(rawValue: indexPath.row)!)
    }
    
    //MARK: - manipulate new items
    @IBAction func removeItem(_ sender: UIBarButtonItem) {
        if let indexpath = tableView.indexPathForSelectedRow {
            context.delete(itemArray[indexpath.row])
            itemArray.remove(at: indexpath.row)
            saveItems()
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
                    let item = Item(context: self.context)
                    item.title = text
                    item.isDone = false
                    item.parentCategory = self.selectedCategory
                    self.itemArray.append(item)
                    self.saveItems()
                }
            }
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    // Add itemArray to encoder
    func saveItems(){
        do {
            try context.save()
        } catch{
            print("Error saving context \(error)")
        }
        tableView.reloadData()
    }
    
    func loadItems(with request:NSFetchRequest<Item> = Item.fetchRequest(), predicate:NSPredicate? = nil){
        
        let loadPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", (selectedCategory?.name)!)
        
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [loadPredicate, additionalPredicate])
        }else{
            request.predicate = loadPredicate
        }
        
        do{
            itemArray = try context.fetch(request)
        }catch{
            print("Error fetching data from context \(error)")
        }
        
        tableView.reloadData()
    }
}

//MARK: - Search Bar Methods

extension TodoListViewController:UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request:NSFetchRequest<Item> = Item.fetchRequest()
        let searchPredicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadItems(with: request, predicate: searchPredicate)
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

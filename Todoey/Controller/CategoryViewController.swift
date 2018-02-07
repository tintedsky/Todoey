//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Hongbo Niu on 2018-01-30.
//  Copyright © 2018 Hongbo Niu. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {
    let realm = try! Realm()
    
    var categories:Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
    }
    
    //MARK: - Add New Categories    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var categoryField = UITextField()
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create a category"
            categoryField = alertTextField
        }
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            if let text = categoryField.text {
                let newCategory = Category()
                newCategory.name = text
                self.save(category:newCategory)
            }
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No categories added yet"

        return cell
    }
    
    //MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destVC = segue.destination as? TodoListViewController{
            if segue.identifier == "goToItems" {
                if let indexpath = tableView.indexPathForSelectedRow {
                    destVC.selectedCategory = categories?[indexpath.row]
                }
            }
        }
    }
    
    //MARK: - Data Manipulation Methods
    func loadCategories(){
        /* Load objects only by one statement */
        categories = realm.objects(Category.self)
        tableView.reloadData()
    }
    
    // Add categoryArray to encoder
    func save(category:Category){
        do {
            try realm.write {
                realm.add(category)
            }
        } catch{
            print("Error saving context \(error)")
        }
        
        tableView.reloadData()
    }
}

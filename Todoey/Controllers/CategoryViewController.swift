//
//  CategoryViewController.swift
//  Todoey
//
//  Created by gopalakrishna on 05/03/19.
//  Copyright © 2019 gopalakrishna. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {
    var realm = try! Realm()
    
    var categories: Results<Category>?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategory()
       
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No Category list Yet"
        return cell
    }
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destVC = segue.destination as! TodoListViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destVC.selectedCategory = categories?[indexPath.row]
        }
    }
    
    // MARK: - Add barbutton Action
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textFld = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            let category = Category()
            category.name = textFld.text!
            self.save(category: category)
        }
        
        alert.addTextField { (alertTextFld) in
            alertTextFld.placeholder = "Enter New Category"
            textFld = alertTextFld
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func save(category: Category){
        do{
            try realm.write {
                realm.add(category)
            }
        }catch{
            print("Error saving context:\(error)")
        }
        tableView.reloadData()
    }
    
    func loadCategory(){
       categories = realm.objects(Category.self)
        tableView.reloadData()
    }
}

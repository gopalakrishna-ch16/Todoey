//
//  CategoryViewController.swift
//  Todoey
//
//  Created by gopalakrishna on 05/03/19.
//  Copyright © 2019 gopalakrishna. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    var categoryArray = [Category]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
loadCategory()
       
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        let category = categoryArray[indexPath.row]
        cell.textLabel?.text = category.name
        return cell
    }
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destVC = segue.destination as! TodoListViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destVC.selectedCategory = categoryArray[indexPath.row]
        }
    }
    
    // MARK: - Add barbutton Action
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textFld = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            let category = Category(context: self.context)
            category.name = textFld.text!
            self.categoryArray.append(category)
            self.saveCategory()
        }
        
        alert.addTextField { (alertTextFld) in
            alertTextFld.placeholder = "Enter New Category"
            textFld = alertTextFld
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func saveCategory(){
        do{
        try context.save()
        }catch{
            print("Error saving context:\(error)")
        }
        tableView.reloadData()
    }
    
    func loadCategory(){
        let reruest: NSFetchRequest<Category> = Category.fetchRequest()
        do{
     categoryArray = try context.fetch(reruest)
        }catch{
            print("Error fetching Context:\(error)")
        }
        
        tableView.reloadData()
    }
}

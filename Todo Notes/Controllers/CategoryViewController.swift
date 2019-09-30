//
//  CategoryViewController.swift
//  Todo Notes
//
//  Created by Arslan Khalid on 28/09/2019.
//  Copyright © 2019 Arslan Khalid. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    var categoryArray = [Categories]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()
    }
    
    //MARK - TableView delegate methods
   
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let row = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        row.textLabel?.text = categoryArray[indexPath.row].catName
        
        return row
    }
    
    //MARK: - add New Category to list
    @IBAction func addNewCategory(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New ToDo's Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Category", style: .default) { (alertaction) in
        
        let category = Categories(context: self.context)
        category.catName = textField.text!
        self.categoryArray.append(category)
        self.saveCategory()
        }
        
        alert.addTextField { (categorytextfield) in
            categorytextfield.placeholder = "enter new category"
            textField = categorytextfield
        }
        alert.addAction(action)
        present(alert, animated: true, completion: .none)
    }
    
    //MARK: - TableView Swipe Behavior
    override func tableView(_ tableView: UITableView,
                            leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
    {
        let closeAction = UIContextualAction(style: .normal, title:  "Update", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            print("OK, marked as Closed")
            success(true)
        })
        closeAction.image = UIImage(named: "tick")
        closeAction.backgroundColor = .darkGray
        return UISwipeActionsConfiguration(actions: [closeAction])
        
    }
    override func tableView(_ tableView: UITableView,
                            trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
    {
        let modifyAction = UIContextualAction(style: .normal, title:  "Delete", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            
            self.context.delete(self.categoryArray[indexPath.row])
            self.categoryArray.remove(at: indexPath.row)
            self.saveCategory()
            
            success(true)
        })
        modifyAction.backgroundColor = .red
        
        return UISwipeActionsConfiguration(actions: [modifyAction])
    }

    //MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(categoryArray[indexPath.row].catName!)
        performSegue(withIdentifier: "gotoItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray[indexPath.row]
        }
        
    }
    
    //MARK: - TableView Datasource Methods.
    func saveCategory()  {
        
        do{
        try context.save()
        }catch {
            print("Error saving Category \(error)")
        }
        tableView.reloadData()
    }
    
    func loadCategories() {
        let req : NSFetchRequest<Categories> = Categories.fetchRequest()
        do{
        categoryArray = try context.fetch(req)
        }catch {
            print("error loading data \(error)")
        }
    }

}

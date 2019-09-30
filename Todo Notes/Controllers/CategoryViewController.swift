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
    
    //MARK - add New Category to list
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

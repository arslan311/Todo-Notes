//
//  ViewController.swift
//  Todo Notes
//
//  Created by Arslan Khalid on 26/09/2019.
//  Copyright © 2019 Arslan Khalid. All rights reserved.
//

import UIKit
import CoreData

class TodoListController: UITableViewController  {
    
    var itemsArray = [CellModel]()
    //let defaults = UserDefaults.standard
    var selectedCategory : Categories? {
        didSet{
            loadItems()
        }
    }
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet weak var searchBar: UISearchBar!
    override func viewDidLoad() {
        super.viewDidLoad()
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
    
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemsArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let row = tableView.dequeueReusableCell(withIdentifier: "TodoListCell", for: indexPath)
        
        let item = itemsArray[indexPath.row]
        row.textLabel?.text = item.todoMessage
      
        row.accessoryType = item.isChecked ? .checkmark : .none

        return row
    }
    
    //MARK - Tableview delegate methods.
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        itemsArray[indexPath.row].isChecked = !itemsArray[indexPath.row].isChecked
        
        saveItems()
        
        let cell = tableView.cellForRow(at: indexPath)
        let bgColorView = UIView()
        bgColorView.backgroundColor = .purple
        cell!.selectedBackgroundView = bgColorView

        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    
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
            
            self.context.delete(self.itemsArray[indexPath.row])
            self.itemsArray.remove(at: indexPath.row)
        
            self.saveItems()
            
            success(true)
        })
        modifyAction.backgroundColor = .red
        
        return UISwipeActionsConfiguration(actions: [modifyAction])
    }


    //MARK - ADD A NEW TODO LIST ITEMS ON CLICK OF + BUTTON
    
    @IBAction func todoAddButton(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new Todo Item", message: "", preferredStyle: .alert)
        
        let action1 = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            let item = CellModel(context: self.context)
            item.todoMessage = textField.text!
            item.isChecked = false
            item.parentCategory = self.selectedCategory
            self.itemsArray.append(item)
            //self.defaults.set(self.itemsArray, forKey: "TodoArray")
            self.saveItems()
        }
        alert.addTextField { (todoTextField) in
            todoTextField.placeholder = "add new todo"
            textField = todoTextField
        }
        alert.addAction(action1)
        present(alert, animated: true, completion: nil)
    }
    
    func saveItems()  {
        do{
           try context.save()
        }catch{
            print("Error saving context \(error)")
        }
        tableView.reloadData()
    }
    
    
    func loadItems(with request: NSFetchRequest<CellModel> = CellModel.fetchRequest(), predicate : NSPredicate? = nil) {
        
        let categorypredicate = NSPredicate(format: "parentCategory.catName MATCHES %@", selectedCategory!.catName!)
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categorypredicate, additionalPredicate])
        }else{
            request.predicate = categorypredicate
        }
        do{
           itemsArray = try context.fetch(request)
        }catch {
            print("error request fetching data \(error)")
        }
         tableView.reloadData()
    }

}

extension TodoListController : UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        if(searchBar.text!.isEmpty){
            loadItems()
        }
        let request : NSFetchRequest<CellModel> = CellModel.fetchRequest()
        
         
        let predicate = NSPredicate(format: "todoMessage contains[cd] %@", searchBar.text!)
        request.predicate = predicate
        request.sortDescriptors = [NSSortDescriptor(key: "todoMessage", ascending: true)]
        
        loadItems(with: request, predicate: predicate)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count == 0 {
            loadItems()
            DispatchQueue.main.async {
                 searchBar.resignFirstResponder()
            }
           
        }
        
    }
    
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        if !searchText.isEmpty {
//
//            var predicate: NSPredicate = NSPredicate()
//            predicate = NSPredicate(format: "todoMessage contains[cd] '\(searchText)'")
//            guard (UIApplication.shared.delegate as? AppDelegate) != nil else { return }
//            //let managedObjectContext = appDelegate.persistentContainer.viewContext
//            let request : NSFetchRequest<CellModel> = CellModel.fetchRequest()
//            request.predicate = predicate
//            do {
//                itemsArray = try context.fetch(request)
//            } catch let error as NSError {
//                print("Could not fetch. \(error)")
//            }
//        }
//        tableView.reloadData()
//    }
}


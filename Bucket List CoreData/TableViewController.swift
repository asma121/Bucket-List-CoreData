//
//  TableViewController.swift
//  Bucket List CoreData
//
//  Created by admin on 16/12/2021.
//

import UIKit
import CoreData

class TableViewController: UITableViewController , SavingItemDelegate {
    
    
    var items = [ItemEntity]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        getItem()

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath)
        let item = items[indexPath.row]
        cell.textLabel?.text = item.text
        return cell
    }
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        performSegue(withIdentifier: "goToSegue", sender: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
         let item = items[indexPath.row].text!
        deleteItem(itemText: item)
        
    }
    
    func saveItem(controller: ViewController, item: Item, itemIndex: NSIndexPath?) {
        if let ip = itemIndex {
            let oldText =  items[ip.row].text!
            updateItem(oldItemText: oldText, newItemText: item.text)
        }else{
            storeItem(item: item)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if sender is UIBarButtonItem {
            let destination = segue.destination as! ViewController
            destination.delegate = self
        }else if sender is NSIndexPath {
            let destination = segue.destination as! ViewController
            destination.delegate = self
            
            let currentIndex = sender as! NSIndexPath
            let currentItem = items[currentIndex.row]
            destination.itemIndexEd = currentIndex
            destination.itemTextEd = currentItem.text
        }
    }
    

}

extension TableViewController  {
    
    func getContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    func storeItem(item : Item){
        let context = getContext()
        let itemE = ItemEntity.init(context: context)
        itemE.text = item.text
        
        do{
            try context.save()
            getItem()
        }catch{
            print(error.localizedDescription)
        }
    }
    
    func getItem() {
        let context = getContext()
        let request = NSFetchRequest<ItemEntity>.init(entityName: "ItemEntity")
        
        do{
            items = try context.fetch(request)
            tableView.reloadData()
        }catch{
            print(error.localizedDescription)
        }
    }
    
    func updateItem(oldItemText:String , newItemText:String){
            let context = getContext()
            let request = NSFetchRequest<ItemEntity>.init(entityName: "ItemEntity")
            let predicate = NSPredicate.init(format: "text == %@", oldItemText)
        request.predicate = predicate
        
        do{
            let arr = try context.fetch(request)
            let item = arr.first
            item?.text = newItemText
            try context.save()
            getItem()
        }catch{
            print(error.localizedDescription)
        }
    }
    
    func deleteItem(itemText : String ){
        let context = getContext()
        let request = NSFetchRequest<ItemEntity>.init(entityName: "ItemEntity")
        let predicate = NSPredicate.init(format: "text == %@", itemText)
        request.predicate = predicate
        
        do{
            if let item = try context.fetch(request).first {
                context.delete(item)
                try context.save()
                getItem()
            }
        }catch{
            print(error.localizedDescription)
        }
    }
}

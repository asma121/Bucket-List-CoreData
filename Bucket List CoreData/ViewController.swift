//
//  ViewController.swift
//  Bucket List CoreData
//
//  Created by admin on 16/12/2021.
//

import UIKit

class ViewController: UIViewController {
    

    @IBOutlet weak var itemTextField: UITextField!
    var itemTextEd:String?
    var itemIndexEd:NSIndexPath?
    var delegate : SavingItemDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        itemTextField.text = itemTextEd
    }

    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        if let item = itemTextField.text , !item.isEmpty{
            delegate?.saveItem(controller: self , item: Item(text:item), itemIndex: itemIndexEd)
            navigationController?.popViewController(animated: true)
        }
        
    }
    
}


struct Item {
    var text:String
}

protocol SavingItemDelegate {
    func saveItem(controller : ViewController , item :Item , itemIndex : NSIndexPath?)
}


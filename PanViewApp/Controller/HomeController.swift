//
//  HomeController.swift
//  PanViewApp
//
//  Created by Joel Gil on 11/25/19.
//  Copyright © 2019 Joel Gil. All rights reserved.
//

import UIKit
import CoreData

private let reuseIdentifier = "Cell"

class HomeController: UITableViewController, UISearchResultsUpdating, UISearchBarDelegate, UISearchControllerDelegate  {
    
    // MARK: - Properties
    
    var delegate: HomeControllerDelegate?
    var filteredTableData = [NSManagedObject]()
    var resultSearchController = UISearchController()
    var itemArray = [NSManagedObject]()
    
    let storeImageView: UIImageView = {
           let iv = UIImageView()
           iv.image = #imageLiteral(resourceName: "thriftstore")
           iv.contentMode = .scaleAspectFill
           iv.clipsToBounds = true
           iv.layer.borderWidth = 3
           return iv
       }()
   
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        configureNavigationBar()
    }
    
    // MARK: - viewDidAppear
    override func viewDidAppear(_ animated: Bool) {
              super.viewDidAppear(animated)
              loaddb()
    }
    override func viewWillAppear(_ animated: Bool) {
              super.viewDidAppear(animated)
              loaddb()
    }
    
    // MARK: - UITableView
      override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         if (self.resultSearchController.isActive) {
             return filteredTableData.count
         }
         else {
             return itemArray.count
         }
      }
      
      override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                 
          if (self.resultSearchController.isActive) {
              let cell =
                  tableView.dequeueReusableCell(withIdentifier: "Cell")
                      as UITableViewCell?
              let _item = filteredTableData[(indexPath as NSIndexPath).row]
              cell?.textLabel?.text = _item.value(forKey: "note") as! String?
              cell?.detailTextLabel?.text = ">>"
              cell?.imageView?.image = storeImageView.image
              return cell!
          }
          else {
              let cell =
                  tableView.dequeueReusableCell(withIdentifier: "Cell")
                      as UITableViewCell?
              let _item = itemArray[(indexPath as NSIndexPath).row]
              cell?.textLabel?.text = _item.value(forKey: "note") as! String?
              cell?.detailTextLabel?.text = ">>"
              cell?.imageView?.image = storeImageView.image
              return cell!
          }
          
      }
      
      override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
      {
          print("You selected cell #\((indexPath as NSIndexPath).row)")
      }
    
      override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
          // Return false if you do not want the specified item to be editable.
          return false
      }
      
      // MARK: - Search
      func updateSearchResults(for searchController: UISearchController){
             filteredTableData.removeAll(keepingCapacity: false)
             //search for field in CoreData
             let searchPredicate = NSPredicate(format: "note CONTAINS[c] %@", searchController.searchBar.text!)
             let array = (itemArray as NSArray).filtered(using: searchPredicate)
             filteredTableData = array as! [NSManagedObject]
             
             self.tableView.reloadData()
      }
    
    // MARK: - Handlers
    
    @objc func handleMenuToggle() {
        delegate?.handleMenuToggle(forMenuOption: nil)
    }
    
    @objc func handleNewItem() {
        let controller = AddItemController()
        present(UINavigationController(rootViewController: controller), animated: true, completion: nil)
    }
    
    
    func configureNavigationBar() {
        navigationController?.navigationBar.barTintColor = .darkGray
        navigationController?.navigationBar.barStyle = .black
        
        navigationItem.title = "Welcome!"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "ic_menu_white_3x").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleMenuToggle))

        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "icons8-mobile-order-50").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleNewItem))
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.tableFooterView = UIView(frame: .zero)
    }
    
    func loaddb()
       {
           let managedContext = (UIApplication.shared.delegate
               as! AppDelegate).persistentContainer.viewContext
           
           //let fetchRequest = NSFetchRequest(entityName:"Contact")
           let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Item")
           
           do {
               let fetchedResults = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
               if let results = fetchedResults {
                   itemArray = results
                   //tableView.reloadData()
               } else {
                   print("Could not fetch")
               }
           } catch let error as NSError {
               // failure
               print("Fetch failed: \(error.localizedDescription),\(error.userInfo)")
           }
       }
}

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
private let reuseItemIdentifier = "ItemOptionCell"
var itemsTableView: UITableView!

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
        configureItemTableView()  //TODO: Fix the exception later on.
        NotificationCenter.default.addObserver(self, selector: #selector(loaddb), name: NSNotification.Name(rawValue: "load"), object: nil)
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
            
            let cell = tableView.dequeueReusableCell(withIdentifier: reuseItemIdentifier, for: indexPath) as! ItemOptionCell
            let _item = filteredTableData[(indexPath as NSIndexPath).row]
            cell.titleLabel.text = _item.value(forKey: "note") as! String?
            cell.descriptionLabel.text = _item.value(forKey: "store") as! String?
            let _cat = _item.value(forKey: "category") as! String?
            cell.categoryLabel.text = _cat

            cell.pictureImageView.image = storeImageView.image
                       
            if let imageData = _item.value(forKey: "video") as? NSData {
               if let image = UIImage(data:imageData as Data) as? UIImage {
                cell.pictureImageView.image = image
               }
            }
            
            let dateFormatter = DateFormatter()
           dateFormatter.dateFormat = "MMMM dd, yyyy"
           let createdAt = _item.value(forKey: "createdat") as! Date?
           let createdAtFormatted = dateFormatter.string(from: createdAt ?? Date())
                      
           cell.createdAtLabel.text = "Created at \(createdAtFormatted)"
            return cell

          }
          else {
            
            //
            //let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier) as! ItemOptionCell?
            let _item = itemArray[(indexPath as NSIndexPath).row]

            //New
            let cell = tableView.dequeueReusableCell(withIdentifier: reuseItemIdentifier, for: indexPath) as! ItemOptionCell
            cell.titleLabel.text = _item.value(forKey: "note") as! String?
            cell.descriptionLabel.text = _item.value(forKey: "store") as! String?
            let _cat = _item.value(forKey: "category") as! String?
            let _sub = _item.value(forKey: "subcategory") as! String?
            cell.categoryLabel.text = _cat

            cell.pictureImageView.image = storeImageView.image
                       
            if let imageData = _item.value(forKey: "video") as? NSData {
               if let image = UIImage(data:imageData as Data) as? UIImage {
                cell.pictureImageView.image = image
               }
            }
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMMM dd, yyyy"
            let createdAt = _item.value(forKey: "createdat") as! Date?
            let createdAtFormatted = dateFormatter.string(from: createdAt ?? Date())
                       
            cell.createdAtLabel.text = "Created at \(createdAtFormatted)"
            return cell
            //
            
          }          
      }
      
      override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        let _item = itemArray[(indexPath as NSIndexPath).row]
        
        //Call ViewController
        print("You selected cell #\((indexPath as NSIndexPath).row)")
        let controller = ViewItemController()
        controller.itemdb = _item
        present(UINavigationController(rootViewController: controller), animated: true, completion: nil)
            
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
        controller.fullItem = "No"
        present(UINavigationController(rootViewController: controller), animated: true, completion: nil)
        
        //refresh tableView
        print("refreshing data afeter saving new item")
        loaddb()
    }
    
    //MARK: Configure General elements
    func configureItemTableView() {
        itemsTableView = UITableView()
        itemsTableView.delegate = self
        itemsTableView.dataSource = self
        
        tableView.register(ItemOptionCell.self, forCellReuseIdentifier: reuseItemIdentifier)
        //itemsTableView.backgroundColor = .darkGray
        //itemsTableView.separatorStyle = .none
        tableView.rowHeight = 100
        
        view.addSubview(itemsTableView)
        itemsTableView.translatesAutoresizingMaskIntoConstraints = false
        itemsTableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        itemsTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        itemsTableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        itemsTableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
    }
    
    func configureNavigationBar() {
        navigationController?.navigationBar.barTintColor = .darkGray
        navigationController?.navigationBar.barStyle = .black
        
        navigationItem.title = "Welcome!"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "ic_menu_white_3x").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleMenuToggle))

        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "icons8-add-64").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleNewItem))
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.tableFooterView = UIView(frame: .zero)
    }
    
    @objc func loaddb()
       {
           let managedContext = (UIApplication.shared.delegate
               as! AppDelegate).persistentContainer.viewContext
           
            //let fetchRequest = NSFetchRequest(entityName:"Contact")
            let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Item")
            let sort = NSSortDescriptor(key: "createdat", ascending: false)
            fetchRequest.sortDescriptors = [sort]
        
            //Get the items created the las 24 hours
            let twenty4HoursAgo = Date().addingTimeInterval(-86400)
            let filterPredicate = NSPredicate(format: "createdat >= %@", twenty4HoursAgo as NSDate)
            fetchRequest.predicate = filterPredicate
           
           //print(NSSearchPathForDirectoriesInDomains(.applicationSupportDirectory, .userDomainMask, true).last!);

           do {
               let fetchedResults = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            
               if let results = fetchedResults {
                itemArray = results

                //_ = (itemArray as NSArray).filtered(using: searchPredicate)
                
                   self.tableView.reloadData()
               } else {
                   print("Could not fetch")
               }
           } catch let error as NSError {
               // failure
               print("Fetch failed: \(error.localizedDescription),\(error.userInfo)")
           }
       }
}

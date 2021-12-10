//
//  locationsVC.swift
//  FisherMap
//
//  Created by Fırat GÜLEÇ on 18.01.2021.
//

import UIKit
import CoreLocation

private let reuseIdentifier = "LocationCell"

class locationsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var currentLocation = CLLocationCoordinate2D()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    private var cellitems = [Locationdata]()
    
    let tableView: UITableView = {
        let table = UITableView()
        table.register(LocationCell.self, forCellReuseIdentifier: reuseIdentifier)
    
        return table
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Location List"
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.frame = view.bounds
        tableView.tableFooterView = UIView()
        tableView.rowHeight = 80
        getAllItems()
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellitems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celliteme = cellitems[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! LocationCell
        cell.usernameLabel.text = celliteme.locName
        cell.messageTextLabel.text = celliteme.locSub
        cell.imageView?.image = UIImage(named: celliteme.imageName!)
        cell.favoriteImageView.isHidden = celliteme.favorite
        
        
        let firsLocation = CLLocation(latitude: celliteme.cLat, longitude: celliteme.cLon)
        let secondLocation = CLLocation(latitude: currentLocation.latitude, longitude: currentLocation.longitude)
        let distance: CLLocationDistance = firsLocation.distance(from: secondLocation) / 1000
        let dist = "\(String(format:"%.02f", distance))"
        //KM ve MIL olarak çalışma yapılacak.
        cell.timestampLabel.text = "\(dist) KM"
        return cell
    }
    //Empty
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(cellitems[indexPath.row].favorite)
    }
    
    
    //Leading Swipe Actions
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        // GO..
        let goAction = UIContextualAction(style: .normal, title: "GO") { (action, view, completionHandler) in
            //go action
            completionHandler(true)
        }
        goAction.backgroundColor = .systemGreen
        let swipe = UISwipeActionsConfiguration(actions: [goAction])
        return swipe
    }
    
    //Edit Rows Actions
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        // DELETE..
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            let deleteitem = self.cellitems[indexPath.row]
            self.deleteItem(item: deleteitem )
            self.cellitems.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .fade)
        }
        
        // FAVORITE..
        let actionTitle = cellitems[indexPath.row].favorite ? "Unfavorite" : "Favorite"
        let favoriteAction = UITableViewRowAction(style: .normal, title: actionTitle) { [self] (action, indexPath) in
            var cellitem = self.cellitems[indexPath.row]
            cellitem.favorite.toggle()
            let cell = tableView.cellForRow(at: indexPath) as! LocationCell
            self.cellitems[indexPath.row] = cellitem
            self.tableView.reloadRows(at: [indexPath], with: .automatic)
            
            let updateitem = self.cellitems[indexPath.row]
                            if cellitems[indexPath.row].favorite == false {
                            self.updateItem(item: updateitem, favorite: false)
                            }else {
                                self.updateItem(item: updateitem, favorite: true)
                            }
        }
        // EDIT..
        let editAction = UITableViewRowAction(style: .normal, title: "Edit") { (action, indexPath) in
            //Edit Action - Update action..
        }
        
        favoriteAction.backgroundColor = UIColor(red: 17/255, green: 154/255, blue: 237/255, alpha: 1)
        editAction.backgroundColor = .systemYellow
        return [deleteAction, favoriteAction, editAction]
    }
    
    
    
    
    // MARK: - CoreDATA fetch (get, create, update, delete)
    
    //Get
    func getAllItems() {
        do {
            cellitems = try context.fetch(Locationdata.fetchRequest())
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }catch {
            //error
        }
    }
    
   //Update
    func updateItem(item: Locationdata, favorite: Bool) {
        item.favorite = favorite
        do {
            try context.save()
        }catch {
            //error
        }
    }
    //Delete
    func deleteItem(item: Locationdata) {
        context.delete(item)
        do {
            try context.save()
        }catch {
            //error
        }
    }
    
    
    
}
     

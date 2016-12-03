//
//  TableViewController.swift
//  qonto
//
//  Created by Igor Angelov on 30/11/2016.
//  Copyright © 2016 Igor Angelov. All rights reserved.
//

import UIKit


enum DisplayType {
    case User
    case Album
}

class TableViewController: UITableViewController {

    var userSelected : Int?{
        didSet {
            self.displayType = .Album
        }
    }
    
    var displayType : DisplayType = .User
    
    var items = [Any]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
    
        
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if(displayType == .User) {
            //get list of users
            self.configureTableViewWithUsers()
        }else{
            //get list of albums
            self.configureTableViewWithAlbums()
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

        let item  = items[indexPath.row] as! [String:Any]

        if(displayType == .Album)
        {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "albumCell", for: indexPath) as? AlbumTableViewCell else {
                return UITableViewCell()
            }

            let album = Album.init(dict: item)
            let albumViewModel = AlbumViewModel.init(album: album)
            cell.albumViewModel = albumViewModel
            return cell
        }
        else{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath) as? UserTableViewCell else {
                return UITableViewCell()
            }
            
            let user = User.init(dict: item)
            let userViewModel = UserViewModel.init(user:user)
            cell.userViewModel = userViewModel
            
            return cell

        }
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let item = items[indexPath.row] as! [String:Any]
        if(displayType == .Album)
        {

            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            
            let detailVC = mainStoryboard.instantiateViewController(withIdentifier: "galleryController") as! GalleryViewController
            detailVC.idAlbumSelected = item["id"] as? Int
            
            self.navigationController?.pushViewController(detailVC, animated: true)

            return
        }else{

            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            
            let detailVC = mainStoryboard.instantiateViewController(withIdentifier: "TableViewController") as! TableViewController
            detailVC.userSelected = item["id"] as? Int
            
            self.navigationController?.pushViewController(detailVC, animated: true)

        }
        
        
        
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

   
    func configureTableViewWithAlbums(){
        
        //get list of album for user id
        ServicesManager.getUserAlbums(userId: userSelected!){ (error, jsonResponse) in
            guard let array  = jsonResponse as? [Any] else { return }
            self.items = array
            self.tableView.reloadData()
        }
        
    }

    func configureTableViewWithUsers(){
        
        //get list of users
        ServicesManager.getUsers { (error, jsonResponse) in
            guard let array  = jsonResponse as? [Any] else { return }
            self.items = array
            self.tableView.reloadData()
        }
        
    }

    
}

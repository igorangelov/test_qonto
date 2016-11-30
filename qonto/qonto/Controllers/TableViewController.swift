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
            self.configureTableView()
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
        
        //get list of user
        self.configureTableView()
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


        guard let cell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath) as? UserTableViewCell else {
            return UITableViewCell()
        }
        
        var object = item["username"] as? String
        if(displayType == .Album)
        {
            object = item["title"] as? String
        }
        
        cell.userNameLabel.text = object


        return cell
    }
    

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = items[indexPath.row] as! [String:Any]
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
       
        let detailVC = mainStoryboard.instantiateViewController(withIdentifier: "TableViewController") as! TableViewController
        detailVC.userSelected = item["id"] as? Int
        self.navigationController?.pushViewController(detailVC, animated: true)
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func configureTableView(){
        
        //get list of album for user id
        if(displayType == .Album)
        {
            ServicesManager.getUserAlbums(userId: userSelected!){ (error, jsonResponse) in
                guard let array  = jsonResponse as? [Any] else { return }
                self.items = array
                self.tableView.reloadData()
            }
        }else{
            
            ServicesManager.getUsers { (error, jsonResponse) in
                guard let array  = jsonResponse as? [Any] else { return }
                self.items = array
                self.tableView.reloadData()
            }
        }
        

    }

}

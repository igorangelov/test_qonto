//
//  GalleryViewController.swift
//  qonto
//
//  Created by Igor Angelov on 02/12/2016.
//  Copyright © 2016 Igor Angelov. All rights reserved.
//

import UIKit

class GalleryViewController: UIViewController {

    @IBOutlet weak var collectionView : UICollectionView!
    
    var items = [Any]()
    var idAlbumSelected : Int?{
        didSet {
            self.configureCollectionView()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func configureCollectionView(){
        
        //get list of album for user id
        ServicesManager.getAlbumPhotos(albumId: idAlbumSelected!){ (error, jsonResponse) in
            guard let array  = jsonResponse as? [Any] else { return }
            self.items = array
            self.collectionView.reloadData()
        }
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

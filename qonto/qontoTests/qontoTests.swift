//
//  qontoTests.swift
//  qontoTests
//
//  Created by Igor Angelov on 30/11/2016.
//  Copyright © 2016 Igor Angelov. All rights reserved.
//

import XCTest
@testable import qonto

class qontoTests: XCTestCase {
    
    var userVM : UserViewModel!
    var albumVM : AlbumViewModel!
    var photoVM : PhotoViewModel!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
 
        let user = User.init(dict: [ "id": 1,
                                     "name": "Leanne Graham",
                                     "username": "Bret",
                                     "email": "Sincere@april.biz",
                                     "phone": "1-770-736-8031 x56442",
                                     "website": "hildegard.org",
    
                      ])
        
        userVM = UserViewModel.init(user: user)
        
        let album = Album.init(dict: ["userId": 2,
                                      "id": 11,
                                      "title": "quam nostrum impedit mollitia quod et dolor"
            ])
        
        albumVM = AlbumViewModel.init(album: album)
        
        let photo = Photo.init(dict: ["albumId": 1,
                                      "id": 1,
                                      "title": "accusamus beatae ad facilis cum similique qui sunt",
                                      "url": "http://placehold.it/600/92c952",
                                      "thumbnailUrl": "http://placehold.it/150/30ac17"])
        photoVM = PhotoViewModel.init(photo: photo)
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    // MARK: - Test user
    func testUser(){
        XCTAssert(userVM.nameText == "Bret")
    }
    
    // MARK: - Test album
    func testAlbum(){
        XCTAssert(albumVM.titleText == "quam nostrum impedit mollitia quod et dolor")
    }
    
    // MARK: - Test Photo
    func testPhoto(){
        XCTAssert(photoVM.titleText == "accusamus beatae ad facilis cum similique qui sunt")
        XCTAssert(photoVM.urlPhoto == "http://placehold.it/150/30ac17")
    }
}

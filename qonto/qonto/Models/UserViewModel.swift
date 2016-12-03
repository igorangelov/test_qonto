//
//  UserViewModel.swift
//  qonto
//
//  Created by Igor Angelov on 01/12/2016.
//  Copyright © 2016 Igor Angelov. All rights reserved.
//

import UIKit

class UserViewModel: NSObject {

    private let user : User
    var nameText : String
    
    init(user: User)
    {
        self.user = user
        self.nameText = self.user.userName
    }
}

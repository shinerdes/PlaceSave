//
//  Users.swift
//  PlaceSave
//
//  Created by 김영석 on 11/07/2019.
//  Copyright © 2019 김영석. All rights reserved.
//

import Foundation

class Users {
    
    
    private var _email: String
    private var _provider: String
    
    var email: String {
        return _email
    }
    
    var provider: String {
        return _provider
    }
    
    init(email: String, provider: String) {
        self._email = email
        self._provider = provider
    }
    
}

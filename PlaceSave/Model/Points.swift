//
//  Point.swift
//  PlaceSave
//
//  Created by 김영석 on 23/07/2019.
//  Copyright © 2019 김영석. All rights reserved.
//

import Foundation

class Points {
    private var _email: String
    private var _address: String
    private var _latitue: String
    private var _longitude: String
    private var _storename: String
    private var _image: String
    private var _uid: String
    
    var email: String {
        return _email
    }
    var address: String {
        return _address
    }
    var latitue: String {
        return _latitue
    }
    var longitude: String {
        return _longitude
    }
    var storename: String {
        return _storename
    }
    var image: String {
        return _image
    }

    var uid: String {
        return _uid
    }
    
    
    init(email: String, address: String, latitue: String, longitude: String, storename: String, image: String, uid: String){
        self._email = email
        self._address = address
        self._latitue = latitue
        self._longitude = longitude
        self._storename = storename
        self._image = image
        self._uid = uid
        
        
    }
    
    
}

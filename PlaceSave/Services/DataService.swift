//
//  DataService.swift
//  PlaceSave
//
//  Created by 김영석 on 08/07/2019.
//  Copyright © 2019 김영석. All rights reserved.
//

import Foundation
import Firebase

let DB_BASE = Database.database().reference()

class DataService {
    
    // 유저의 정보 users
    // 장소의 저장 points
    
    static let instance = DataService()
    
    private var _REF_BASE = DB_BASE
    private var _REF_USERS = DB_BASE.child("users")
    private var _REF_POINTS = DB_BASE.child("points")
    
    
    var REF_BASE: DatabaseReference {
        return _REF_BASE
    }
    
    var REF_USERS: DatabaseReference {
        return _REF_USERS
    }
    
    var REF_POINTS: DatabaseReference {
        return _REF_POINTS
    }
    
    func createDBUser(uid: String, userData: Dictionary<String, Any>) {
        REF_USERS.child(uid).updateChildValues(userData)
    }
    
    func getAllUsers(handler: @escaping (_ users: [Users]) -> ()) {
        var usersArray = [Users]()
        REF_USERS.observeSingleEvent(of: .value) { (userSnapshot) in
            guard let userSnapshot = userSnapshot.children.allObjects as?
                [DataSnapshot] else { return }
            
            for allUsers in userSnapshot {
                let email = allUsers.childSnapshot(forPath: "email").value as! String
                let provider = allUsers.childSnapshot(forPath: "provider").value as! String
                let allUsers = Users(email: email, provider: provider)
                usersArray.append(allUsers)
                
            }
            
            handler(usersArray)
        }
    }
    
    func uploadPost(forUID uid: String, forEmail email: String, forAddress address: String, forLatitude latitue: String, forLongitude longitude: String, forStoreName storename: String, forImage image: String, sendComplete: @escaping (_ status: Bool) -> ()) {
        
        
        REF_POINTS.childByAutoId().updateChildValues(["uid": uid, "email": email, "address": address, "latitue": latitue, "longitude": longitude, "storename": storename, "image": image])
        sendComplete(true)
        
    }
    
    func getAllPoints(handler: @escaping (_ points: [Points]) -> ()) {
        var pointArray = [Points]()
        REF_POINTS.observeSingleEvent(of: .value) { (pointSnapshot) in
            guard let pointSnapshot = pointSnapshot.children.allObjects as? [DataSnapshot] else { return }
            
            for point in pointSnapshot {
                //    init(email: String, address: String, latitue: String, longitude: String, storename: String, image: String){
                let email = point.childSnapshot(forPath: "email").value as! String
                let address = point.childSnapshot(forPath: "address").value as! String
                let latitue = point.childSnapshot(forPath: "latitue").value as! String
                let longitude = point.childSnapshot(forPath: "longitude").value as! String
                let storename = point.childSnapshot(forPath: "storename").value as! String
                let image = point.childSnapshot(forPath: "image").value as! String
                let uid = point.childSnapshot(forPath: "uid").value as! String
                let point = Points(email: email, address: address, latitue: latitue, longitude: longitude, storename: storename, image: image, uid: uid)
                
                pointArray.append(point)
            }
            handler(pointArray)
        }
    }
    
    func getAddress(forUID uid: String, handler: @escaping (_ username: String) -> ()) { //
        REF_POINTS.observeSingleEvent(of: .value) { (userSnapshot) in
            guard let userSnapshot = userSnapshot.children.allObjects as? [DataSnapshot] else { return }
            for user in userSnapshot {
                if user.key == uid {
                    handler(user.childSnapshot(forPath: "address").value as! String)
                }
            }
        }
    }
    
    func getStorename(forUID uid: String, handler: @escaping (_ username: String) -> ()) { //
        REF_POINTS.observeSingleEvent(of: .value) { (userSnapshot) in
            guard let userSnapshot = userSnapshot.children.allObjects as? [DataSnapshot] else { return }
            for user in userSnapshot {
                if user.key == uid {
                    handler(user.childSnapshot(forPath: "storename").value as! String)
                }
            }
        }
    }
    
    func getLatitue(forUID uid: String, handler: @escaping (_ username: String) -> ()) { //
        REF_POINTS.observeSingleEvent(of: .value) { (userSnapshot) in
            guard let userSnapshot = userSnapshot.children.allObjects as? [DataSnapshot] else { return }
            for user in userSnapshot {
                if user.key == uid {
                    handler(user.childSnapshot(forPath: "latitue").value as! String)
                }
            }
        }
    }
    func getLongitude(forUID uid: String, handler: @escaping (_ username: String) -> ()) { //
        REF_POINTS.observeSingleEvent(of: .value) { (userSnapshot) in
            guard let userSnapshot = userSnapshot.children.allObjects as? [DataSnapshot] else { return }
            for user in userSnapshot {
                if user.key == uid {
                    handler(user.childSnapshot(forPath: "longitude").value as! String)
                }
            }
        }
    }
    
    func getImage(forUID uid: String, handler: @escaping (_ username: String) -> ()) { //
        REF_POINTS.observeSingleEvent(of: .value) { (userSnapshot) in
            guard let userSnapshot = userSnapshot.children.allObjects as? [DataSnapshot] else { return }
            for user in userSnapshot {
                if user.key == uid {
                    handler(user.childSnapshot(forPath: "image").value as! String)
                }
            }
        }
    }
    
}



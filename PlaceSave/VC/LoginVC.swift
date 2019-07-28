//
//  LoginVC.swift
//  PlaceSave
//
//  Created by 김영석 on 28/06/2019.
//  Copyright © 2019 김영석. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

// 로그인을 위한 VC
// ONLY 구글 계정, 로그인 되면 GoogleMapVC로 넘어간다



class LoginVC: UIViewController, GIDSignInUIDelegate, GIDSignInDelegate  {
    
    var usersArray = [Users]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var error : NSError?
        
        
        if error != nil{
            print(error ?? "google error")
            return
        }
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
        
        let googleSignInButton = GIDSignInButton()
        googleSignInButton.center = view.center
        view.addSubview(googleSignInButton)
        
        
        
        // Do any additional setup after loading the view.
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if error != nil{
            print(error ?? "google error")
            return
        }
        
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        Auth.auth().currentUser?.linkAndRetrieveData(with: credential) { (authResult, error) in
            
            print("뭔차이지?")
            print("뭘까요")
            
            // ...
        }
        
        Auth.auth().signInAndRetrieveData(with: credential) { (authResult, error) in
            if let error = error {
                // ...
                return
            } // 구글 계정 연동 하는 로그인
            // 이 파트에서는 auth에서 계정은 생성이 된다
            
            guard let user = authResult?.user else {
                //userCreationComplete(false, error)
                return
            }
            
            var redundancyCheck = 0 // 중복성 체크. 구글 계정이 겹치면 안됨.
            
            
            
            // let userData = ["provider": user.providerID, "email": user.email]//
            // DataService.instance.createDBUser(uid: user.uid, userData: userData)
            print("Successfully registered user!")
            
            DataService.instance.getAllUsers { (returnAllUsers) in
                
                self.usersArray = returnAllUsers.reversed()
                print("그저 테스트")
                for i in 0 ..< self.usersArray.count {
                    print("\(self.usersArray[i].email)")
                    
                    if user.email! == self.usersArray[i].email {
                        redundancyCheck = redundancyCheck + 1
                    } else {
                        
                    }
                    
                }
                
                print(user.email!)
                print(redundancyCheck)
                
                if redundancyCheck == 0 {
                    // 신규 생성
                    let userData = ["provider": user.providerID, "email": user.email]
                    DataService.instance.createDBUser(uid: user.uid, userData: userData)
                    // DB에 계정 생성. AUTH에 이미 계정은 들어간 상태니깐
                    
                    print("Successfully registered user!")
                    self.performSegue(withIdentifier: "showMapVC", sender: nil)
                    
                    
                } else {
                    // 이미 생성되어있으면 그냥 이동만
                    self.performSegue(withIdentifier: "showMapVC", sender: nil)
                    
                    
                }
                
            }
            
            
            
            // User is signed in
            // ...
        }
    }
    
    
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

//
//  MapVC.swift
//  PlaceSave
//
//  Created by 김영석 on 09/07/2019.
//  Copyright © 2019 김영석. All rights reserved.
//

import UIKit
import GoogleSignIn
import Firebase
import GoogleMaps
import EzPopup


class MapVC: UIViewController {
    
    
    
    var imsiAddress = "" // 주소 임시저장지
    var imsiLatitude = "" // 위도 임시저장지
    var imsiLongitude = "" // 경도 임시저장지
    var imsiStoreName = "None"  // StoreName 임시저장지
    
    
    var redundancyCheckArray = [Points]() // 중복성체크하는 array
    
    var saveimage = UIImage(named: "bakery") // 저장하는 이미지
    var saveOffset = 0 // offset. marker의 유무
    
    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet private weak var mapCenterPinImage: UIImageView!
    @IBOutlet private weak var pinImageVerticalConstraint: NSLayoutConstraint!
    @IBOutlet weak var mapView: GMSMapView!
    private var searchedTypes = ["bakery"] // 카테고리
    //private var searchedTypes = ["bakery", "bar", "cafe", "grocery_or_supermarket", "restaurant"] // 임시용
    private let locationManager = CLLocationManager()
    private let dataProvider = GoogleDataProvider()
    private let searchRadius: Double = 1250
    
    var imageSet = "bakery" // google에서 불러오는 사진이 없으면 기본 셋팅해주는 이미지. 카테고리에 따라 바뀜.
    
    let pickerVC = TypeChangeVC.instantiate()
    let menuVC = MenuPopVC.instantiate()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        mapView.delegate = self
        // Do any additional setup after loading the view.
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.title = (Auth.auth().currentUser?.email)!
    }
    
    
    
    @IBAction func menuBtnWasPressed(_ sender: Any) {
        guard let menuVC = menuVC else { return }
        menuVC.delegate = self
        
        let popupVC = PopupViewController(contentController: menuVC, position: .topRight(CGPoint(x: 16, y: 36)), popupWidth: 150, popupHeight: 135)
        popupVC.canTapOutsideToDismiss = true
        popupVC.cornerRadius = 5
        present(popupVC, animated: true, completion: nil)
        
    }
    
    
    
    @IBAction func touchlogout(_ sender: UIButton) {
        
        
        let logoutPopup = UIAlertController(title: "Logout?", message: "Are you sure you want to logout?", preferredStyle: .alert)
        let logoutAction = UIAlertAction(title: "Logout", style: .destructive) { (buttonTapped) in
            do {
                
                
                
                GIDSignIn.sharedInstance().signOut()
                GIDSignIn.sharedInstance().disconnect()
                
                
                
                try Auth.auth().signOut()
                let LoginVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as? LoginVC
                self.present(LoginVC!, animated: true, completion: nil)
                
                
                
            } catch {
                print(error)
            }
        }
        let logoutCancel = UIAlertAction(title: "Cancel", style: .default) { (buttonTapped) in
            do {
                
            } catch {
                
            }
        }
        
        
        logoutPopup.addAction(logoutAction)
        logoutPopup.addAction(logoutCancel)
        present(logoutPopup, animated: true, completion: nil)
        
        
    }
    
    func fetchNearbyPlaces(coordinate: CLLocationCoordinate2D) {
        mapView.clear() // 새로고침
        
        dataProvider.fetchPlacesNearCoordinate(coordinate, radius:searchRadius, types: searchedTypes) { places in
            places.forEach {
                let marker = PlaceMarker(place: $0)
                marker.map = self.mapView
            }
        }
    }
    
    private func reverseGeocodeCoordinate(_ coordinate: CLLocationCoordinate2D) {
        let geocoder = GMSGeocoder()
        
        geocoder.reverseGeocodeCoordinate(coordinate) { response, error in
            self.addressLbl.unlock()
            
            guard let address = response?.firstResult(), let lines = address.lines else {
                return
            }
            
            self.addressLbl.text = lines.joined(separator: "\n")
            self.imsiAddress = lines.joined(separator: "\n") // 임시 주소 저장
            self.imsiLatitude = String(coordinate.latitude) // 임시 위도 저장
            self.imsiLongitude = String(coordinate.longitude) // 임시 경도 저장
            print(coordinate.latitude)
            print(coordinate.longitude)
            print(self.imsiAddress) // 여기까지는 올바르게 다 찍힘
            let labelHeight = self.addressLbl.intrinsicContentSize.height
            self.mapView.padding = UIEdgeInsets(top: self.view.safeAreaInsets.top, left: 0,
                                                bottom: labelHeight, right: 0)
            
            UIView.animate(withDuration: 0.25) {
                self.pinImageVerticalConstraint.constant = ((labelHeight - self.view.safeAreaInsets.top) * 0.5)
                self.view.layoutIfNeeded()
            }
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
    
    
    func rotateImage(image: UIImage) -> UIImage { // 파일 회전 // PNG파일로 저장시 화면서 회전되어서 저장되는데 그것을 잡아주는 과정 
        
        if (image.imageOrientation == UIImage.Orientation.up ) {
            return image
        }
        
        UIGraphicsBeginImageContext(image.size)
        
        image.draw(in: CGRect(origin: CGPoint.zero, size: image.size))
        let copy = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return copy!
    }
}


extension MapVC: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        guard status == .authorizedWhenInUse else {
            return
        }
        
        locationManager.startUpdatingLocation()
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            return
        }
        
        mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
        locationManager.stopUpdatingLocation()
        fetchNearbyPlaces(coordinate: location.coordinate)
    }
}





extension MapVC: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        reverseGeocodeCoordinate(position.target)
    }
    
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        addressLbl.lock()
        
        if (gesture) {
            mapCenterPinImage.fadeIn(0.25)
            mapView.selectedMarker = nil
            fetchNearbyPlaces(coordinate: mapView.camera.target) // 무브 땡길때 마다 refresh
            
            imsiStoreName = "None" // 이동시 marker가 사라기지 때문에 storename은 none처리
            saveOffset = 0 // 이동시 marker는 사라지기 때문에
            
        }
        
        
        // 화면을 움직인다 -> 핀의 위치가 달라짐
        
    }
    
    
    
    func mapView(_ mapView: GMSMapView, didTapAt marker: GMSMarker) { // 짧은 텝
        
        guard let placeMarker = marker as? PlaceMarker else {
            return
        }
        
        
    }
    
    
    
    func mapView(_ mapView: GMSMapView, markerInfoContents marker: GMSMarker) -> UIView? {
        
        guard let placeMarker = marker as? PlaceMarker else {
            return nil
        }
        guard let infoView = UIView.viewFromNibName("MarkerInfoView") as? MarkerInfoView else {
            return nil
        }
        
        
        saveOffset = 1 // marker가 생겼으니깐
        infoView.nameLabel.text = placeMarker.place.name
        if let photo = placeMarker.place.photo {
            infoView.placePhoto.image = photo // 마커에 이미지
            saveimage = photo // 임시 이미지
            
        } else {
            infoView.placePhoto.image = UIImage(named: imageSet) // 이미지 없으면 마커에 기본 카테고리 이미지
            saveimage = UIImage(named: imageSet)! // 임시 이미지
            
        }
        
        // viewload시 offset 1, view가 disappear되면 0
        
        
        print(placeMarker.place.name)
        imsiStoreName = placeMarker.place.name // 임시 저장하는 가게 이름에 marker pop시 저장
        
        print(imsiAddress) //이게 그러면 markerinfocontents가 먼저 들어간다는 소리
        
        // 만약에 버튼을 누르면 여기서 주소, 좌표랑 해서 정보를 보내줘야 함
        // view가 appear 하냐 아니냐가 판단 기준
        // move -> marker
        
        return infoView
        
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        mapCenterPinImage.fadeOut(0.25)
        return false
    }
    
    func didTapMyLocationButton(for mapView: GMSMapView) -> Bool {
        mapCenterPinImage.fadeIn(0.25)
        mapView.selectedMarker = nil
        return false
    }
}


extension MapVC: TypeChangeDelegate {
    func typeChangeVC(sender: TypeChangeVC, didSelectNumber number: Int) {
        dismiss(animated: true) {
            //["bakery", "bar", "cafe", "grocery_or_supermarket", "restaurant"]
            // number 기준
            switch number
            { // 카테고리가 바뀔시 : 서치되는 카테고리 변경. 기본 셋팅 되는 이미지 파일도 변경
            case 0:
                self.mapView.clear()
                print("0")
                self.searchedTypes[0] = "bakery"
                self.fetchNearbyPlaces(coordinate: self.mapView.camera.target)
                self.imageSet = "bakery"
            case 1:
                self.mapView.clear()
                print("1")
                self.searchedTypes[0] = "bar"
                self.fetchNearbyPlaces(coordinate: self.mapView.camera.target)
                self.imageSet = "bar"
            case 2:
                self.mapView.clear()
                print("2")
                self.searchedTypes[0] = "cafe"
                self.fetchNearbyPlaces(coordinate: self.mapView.camera.target)
                self.imageSet = "cafe"
            case 3:
                self.mapView.clear()
                print("3")
                self.searchedTypes[0] = "grocery_or_supermarket"
                self.fetchNearbyPlaces(coordinate: self.mapView.camera.target)
                self.imageSet = "grocery_or_supermarket"
            case 4:
                self.mapView.clear()
                print("4")
                self.searchedTypes[0] = "restaurant"
                self.fetchNearbyPlaces(coordinate: self.mapView.camera.target)
                self.imageSet = "restaurant"
            default:
                print("error!")
            }
            
            
        }
    }
}

extension MapVC: MenuPopDelegate {
    func menuPopVC(sender: MenuPopVC, didSelectNumber number: Int) {
        dismiss(animated: true) {
            switch number {
            case 0:
                
                guard let pickerVC = self.pickerVC else { return }
                
                pickerVC.delegate = self
                
                let popupVC = PopupViewController(contentController: pickerVC, position: .topRight(CGPoint(x: 16, y: 36)), popupWidth: 150, popupHeight: 220)
                popupVC.canTapOutsideToDismiss = true
                popupVC.cornerRadius = 5
                self.present(popupVC, animated: true, completion: nil) // 끝남
                
                
            case 1:
                print("이거는 저장테이블 이동")
                self.performSegue(withIdentifier: "showSaveDataTable", sender: nil)
                
            case 2:
                if self.saveOffset == 1 { // offset 1 .marker가 있는 상태에서 버튼을 눌렀을 경우. 데이터를 저장하기 위한 과정을 시작한다
                    var redundancyCheck = 0 //database 중복 검사
                    let uid = (Auth.auth().currentUser?.uid)!
                    let email = (Auth.auth().currentUser?.email)!
                    
                    print("시작점")
                    DataService.instance.getAllPoints { (returnPoint) in
                        for i in returnPoint {
                            if i.email == (Auth.auth().currentUser?.email)! && i.latitue == self.imsiLatitude && i.longitude == self.imsiLongitude
                            {
                                
                                self.redundancyCheckArray.append(i)
                                // place저장시 같은 계정 + 위도, 경도가 다 같으면 중복 된다는 판정을 내려서 중복성 체크 array에 집어 넣음
                            }
                        }
                        
                        
                        redundancyCheck = self.redundancyCheckArray.count // 중복성 카운터
                        print("중복성 체크 \(redundancyCheck)")
                        // 현재 가지고 있는 위도 경도
                        // 계정 x 위도 x 경도
                        
                        
                        if redundancyCheck == 0 { //중복되는 곳이 없다
                            
                            var willSaveImage = self.saveimage
                            willSaveImage = self.rotateImage(image: willSaveImage!) // 90도 돌림
                            if let data = willSaveImage!.pngData() // 데이터는 존재한다.
                                
                            {
                                
                                
                                print("아니 왜 안되냐야야야야야111")
                                
                                let storageRef = Storage.storage(url: "gs://placesave-1f910.appspot.com/").reference()
                                
                                // 주소로 image name 저장
                                let placeImageRef = storageRef.child("images/\(email)_\(self.imsiLatitude)_\(self.imsiLongitude).png")
                                // email - 위도 - 경도
                                
                                
                                
                                let uploadTask = placeImageRef.putData(data, metadata: nil) { (metadata, error) in
                                    // storage에 저장되는 putData는 제일 마지막 순서
                                    
                                    guard let metadata = metadata else {
                                        // Uh-oh, an error occurred!
                                        return
                                    }
                                    
                                    print(metadata)
                                    // Metadata contains file metadata such as size, content-type.
                                    let size = metadata.size
                                    // You can also access to download URL after upload.
                                    placeImageRef.downloadURL { (url, error) in
                                        guard let downloadURL = url else {
                                            // Uh-oh, an error occurred!
                                            return
                                        }
                                    }
                                    let savedAlert = UIAlertController(title: "Success!", message: "This plce has been saved", preferredStyle: .alert)
                                    let okCancel = UIAlertAction(title: "확인", style: .default) { (buttonTapped) in
                                        do {
                                            
                                        } catch {
                                            
                                        }
                                        
                                        
                                    }
                                    
                                    savedAlert.addAction(okCancel)
                                    self.present(savedAlert, animated: true, completion: nil)
                                    // 확인 알람
                                    // 여기까지가 이미지를 storage에 올리는 과정
                                }
                                
                                
                                
                                
                                print("아니 왜 안되냐야야야야야444")
                                
                            }
                            
                            
                            
                            
                            
                            // 사진을 일단 저장함 -> 그 사진에 대한 string을 불러옴 -> string을 uploadpost에 저장
                            
                            
                            DataService.instance.uploadPost(forUID: uid, forEmail: email, forAddress: self.imsiAddress, forLatitude: self.imsiLatitude, forLongitude: self.imsiLongitude, forStoreName: self.imsiStoreName, forImage: "images/\(email)_\(self.imsiLatitude)_\(self.imsiLongitude).png", sendComplete: { (isComplete) in
                                if isComplete == true {
                                    print("저장 완료")
                                }
                                
                            })
                            // uid
                            // account (어짜피 gmail.com 이라서 따로 uid를 팔 필요는 없다)
                            // 주소
                            // 위도
                            // 경도
                            // 가게 이름
                            // 이미지
                            
                            
                        } else { // 중복되는곳이 있다. redundancy
                            let redundancyAlert = UIAlertController(title: "ERROR", message: "There are overlaaping places in the database", preferredStyle: .alert)
                            let okCancel = UIAlertAction(title: "확인", style: .default) { (buttonTapped) in
                                do {
                                    
                                } catch {
                                    
                                }
                                
                                
                            }
                            
                            redundancyAlert.addAction(okCancel)
                            self.present(redundancyAlert, animated: true, completion: nil)
                            
                            // 데이터 추가가 아닌 에러 alert로 대체
                        }
                        
                        
                        
                    }
                } else { // marker가 없는 offset 0의 상태면 데이터 저장을 하지 않는다.
                    let noPlaceAlert = UIAlertController(title: "ERROR", message: "The place didn't show up.", preferredStyle: .alert)
                    let okCancel = UIAlertAction(title: "확인", style: .default) { (buttonTapped) in
                        do {
                            
                        } catch {
                            
                        }
                        
                        
                    }
                    noPlaceAlert.addAction(okCancel)
                    self.present(noPlaceAlert, animated: true, completion: nil)
                    print("경고 알림으로 대신")
                    
                }
                
                
            default:
                print("error")
            }
        }
    }
    
    
}



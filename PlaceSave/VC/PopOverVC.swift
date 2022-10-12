

import UIKit
import GoogleSignIn
import Firebase
import GoogleMaps

class PopOverVC: UIViewController {

    @IBOutlet weak var popOverView: UIView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    
    
    var popoverLatitude = ""
    var popoverLongitude = ""
    
    var popOverStoreTitle = "테스트"
    var popOverStoreImage = UIImage()
    
    var popOverSaveImage = UIImage()
    
    var redundancyCheckArray = [Points]()
    
    var popOverAddress = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        popOverView.layer.cornerRadius = 10
        titleLbl.text = popOverStoreTitle
        imageView.image = popOverStoreImage
        // Do any additional setup after loading the view.
    }
    

    @IBAction func popOverViewTap(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)

    }
    
    
    
    @IBAction func cancelBtnWasPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func saveBtnWasPressed(_ sender: Any) {
        var redundancyCheck = 0 //database 중복 검사
        let uid = (Auth.auth().currentUser?.uid)!
        let email = (Auth.auth().currentUser?.email)!
        
        print("시작점")
        DataService.instance.getAllPoints { (returnPoint) in
            for i in returnPoint {
                if i.email == (Auth.auth().currentUser?.email)! && i.latitue == self.popoverLatitude && i.longitude == self.popoverLongitude
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
                
                var willSaveImage = self.popOverSaveImage
                willSaveImage = self.rotateImage(image: willSaveImage) // 90도 돌림
                if let data = willSaveImage.pngData() // 데이터는 존재한다.
                    
                {
                    
                    
                    print("아니 왜 안되냐야야야야야111")
                    
                    let storageRef = Storage.storage(url: "gs://placesave-1f910.appspot.com/").reference()
                    
                    // 주소로 image name 저장
                    let placeImageRef = storageRef.child("images/\(email)_\(self.popoverLatitude)_\(self.popoverLongitude).png")
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
                    
                    
                    
                    
                    
                }
                
                
                
                
                
                // 사진을 일단 저장함 -> 그 사진에 대한 string을 불러옴 -> string을 uploadpost에 저장
                
                
                DataService.instance.uploadPost(forUID: uid, forEmail: email, forAddress: self.popOverAddress, forLatitude: self.popoverLatitude, forLongitude: self.popoverLongitude, forStoreName: self.popOverStoreTitle, forImage: "images/\(email)_\(self.popoverLatitude)_\(self.popoverLongitude).png", sendComplete: { (isComplete) in
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
                
                
            } else { // 중복되는곳이 있다. redundancy // 중복성 체크가 안되는중
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
        
    }
    
    
    
    
    
    
    func rotateImage(image: UIImage) -> UIImage { // 파일 회전 // PNG파일로 저  장시 화면서 회전되어서 저장되는데 그것을 잡아주는 과정
        
        if (image.imageOrientation == UIImage.Orientation.up ) {
            return image
        }
        
        UIGraphicsBeginImageContext(image.size)
        
        image.draw(in: CGRect(origin: CGPoint.zero, size: image.size))
        let copy = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return copy!
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

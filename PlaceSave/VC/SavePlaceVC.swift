
import UIKit
import Firebase

class SavePlaceVC: UIViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    
     var pointArray = [Points]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        

        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func backBtnWasPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DataService.instance.getAllPoints { (returnPoint) in
            for i in returnPoint {
                if i.email == (Auth.auth().currentUser?.email)! {
                  
                    self.pointArray.append(i)
                }
            }
            // 현재 로그인한 계정의 데이터만 array에 넣기
            self.tableView.reloadData()
        }
      
        self.navigationItem.title = (Auth.auth().currentUser?.email)!
       
        
        
    }
    
    // 데이터를 불러와야하는 과정
 
    
    

}


extension SavePlaceVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pointArray.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "savePlaceCell") as? SavePlaceCell else { return UITableViewCell() }
        
        let point = pointArray[indexPath.row]
        
        let storageRef = Storage.storage().reference().child("\(point.image)")
        storageRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
              if let error = error {
                 print(error)
              }
               else {
                  cell.configureCell(image: UIImage(data: data!)!, name: point.storename, address: point.address, coord: "\(point.latitue) / \(point.longitude)")
                
                }
                
            }
        
        // 뽑아야 할 것들
        // image | storename, address, latitue, longitude
        
        
        
        
        return cell
    }
    
        // delete를 뽑아내는 과정
        // row edit로 밀어낼시 삭제로 간다
        // 저장된 place의 uid를 추적해서 uid를 날리는 쪽으로
        //
}

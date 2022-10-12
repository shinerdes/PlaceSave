

import UIKit

var doneStore = ""

protocol StoreTypeTableVCDelegate: AnyObject {
  func typeDone(_ controller: StoreTypeTableVC, didSelectTypes types: String)
}

class StoreTypeTableVC: UITableViewController {
    
 
    private let storeType = ["bakery", "bar", "cafe", "grocery_or_supermarket", "restaurant"]
    weak var delegate: StoreTypeTableVCDelegate?
    var selectedStore: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        

    }
    override func viewWillAppear(_ animated: Bool) {
        print(selectedStore)
    }
 
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return storeType.count // 수정
        
    }


    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "typecell", for: indexPath) as! StoreTypeCell
 
        cell.storeTypeLbl.text = storeType[indexPath.row]
        cell.storeTypeImage.image = UIImage(named: storeType[indexPath.row])
        
 
        if cell.storeTypeLbl.text == selectedStore {
           
            cell.storeTypeCheckImage.image = UIImage(named: "greencheck")

        } else {
            cell.storeTypeCheckImage.image = UIImage()
        }
      
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        
        print(indexPath.row)
        print(storeType[indexPath.row])
        selectedStore = storeType[indexPath.row]
        
        tableView.reloadData()
        

    }
    

    
}

extension StoreTypeTableVC {
    
    @IBAction func doneBtnWasPressed(_ sender: AnyObject) {
        

        let mapVC = self.storyboard?.instantiateViewController(withIdentifier: "MapVC") as! MapVC

        searchedTypes[0] = selectedStore
        imageSet = selectedStore

        self.navigationController!.popViewController(animated: true)

    }
}

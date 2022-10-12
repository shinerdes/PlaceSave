
import UIKit

protocol MenuPopDelegate: class {
    func menuPopVC(sender: MenuPopVC, didSelectNumber number: Int)
}


class MenuPopVC: UIViewController {
    
    private var menuList = ["Type Change", "Saved Table", "Save Place!"]

    @IBOutlet weak var tableView: UITableView!
    weak var delegate: MenuPopDelegate?
    
    
    static func instantiate() -> MenuPopVC? {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "\(MenuPopVC.self)") as? MenuPopVC
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "\(UITableViewCell.self)")
        tableView.separatorInset = UIEdgeInsets.zero
        // Do any additional setup after loading the view.
    }
    

}


extension MenuPopVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(UITableViewCell.self)", for: indexPath)
        cell.textLabel?.text = menuList[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        delegate?.menuPopVC(sender: self, didSelectNumber: indexPath.row)
    }
    
    
}

//
//  TypeChangeVC.swift
//  PlaceSave
//
//  Created by 김영석 on 19/07/2019.
//  Copyright © 2019 김영석. All rights reserved.
//

import UIKit

protocol TypeChangeDelegate: class {
    func typeChangeVC(sender: TypeChangeVC, didSelectNumber number: Int)
}
class TypeChangeVC: UIViewController {
    
    private var searchedTypes = ["bakery", "bar", "cafe", "supermarket", "restaurant"]
    
    @IBOutlet weak var tableView: UITableView!
    weak var delegate: TypeChangeDelegate?
    
    static func instantiate() -> TypeChangeVC? {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "\(TypeChangeVC.self)") as? TypeChangeVC
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "\(UITableViewCell.self)")
        tableView.separatorInset = UIEdgeInsets.zero
        // Do any additional setup after loading the view.
    }
    


}

extension TypeChangeVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchedTypes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(UITableViewCell.self)", for: indexPath)
        cell.textLabel?.text = searchedTypes[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        delegate?.typeChangeVC(sender: self, didSelectNumber: indexPath.row)
    }
}

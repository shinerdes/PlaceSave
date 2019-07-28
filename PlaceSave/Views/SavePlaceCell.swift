//
//  SavePlaceCell.swift
//  PlaceSave
//
//  Created by 김영석 on 20/07/2019.
//  Copyright © 2019 김영석. All rights reserved.
//

import UIKit

class SavePlaceCell: UITableViewCell {


    @IBOutlet weak var placeImage: UIImageView!
    @IBOutlet weak var placeNameLbl: UILabel!
    @IBOutlet weak var placeAddressLbl: UILabel!
    @IBOutlet weak var placeCoordLbl: UILabel!
    
    func configureCell(image: UIImage, name: String, address: String, coord: String) {
        self.placeImage.image = image
        self.placeNameLbl.text = name
        self.placeAddressLbl.text = address
        self.placeCoordLbl.text = coord
    
    }
}

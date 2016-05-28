//
//  MemeTableCell.swift
//  9gag_mock
//
//  Created by MIRKO on 5/27/16.
//  Copyright © 2016 XZM. All rights reserved.
//

import Foundation
import UIKit

class MemeTableCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var memeImage: UIImageView!
    var imageUrl: NSURL!
}
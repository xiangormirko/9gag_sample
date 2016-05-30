//
//  MemeCollectionViewCell.swift
//  9gag_mock
//
//  Created by MIRKO on 5/30/16.
//  Copyright © 2016 XZM. All rights reserved.
//

import Foundation
import UIKit

class MemeCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var memeImage: UIImageView!
    @IBOutlet weak var memeCaption: UILabel!
    var imageUrl: NSURL!
}
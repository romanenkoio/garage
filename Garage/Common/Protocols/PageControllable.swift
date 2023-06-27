//
//  PageControllable.swift
//  Garage
//
//  Created by Vlad Kulakovsky  on 26.06.23.
//

import UIKit

protocol PageControllable: AnyObject {
    var tableViewDelegate: UITableView? { get set}
}

//
//  BasicRoute.swift
//  Garage
//
//  Created by Illia Romanenko on 6.06.23.
//

import Foundation

enum CommonNavigationRoute: Routable {
    case close
    case closeToRoot
    case confirmPopup(vm: ConfirmPopupViewController.ViewModel)
}

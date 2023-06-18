//
//  BasicPageController.swift
//  Garage
//
//  Created by Illia Romanenko on 19.06.23.
//

import Foundation
import UIKit
import Combine

class BasicPageController: UIPageViewController {
    var cancellables: Set<AnyCancellable> = []
    
    private(set) var vm: ViewModel
    
    init(vm: ViewModel) {
        self.vm = vm
        super.init(
            transitionStyle: .scroll,
            navigationOrientation: .horizontal
        )
        binding()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
    }
    
    func binding() {
        cancellables.removeAll()
        
        vm.$controllers.sink { [weak self] controllers in
            self?.setViewControllers(
                controllers,
                direction: .forward,
                animated: true
            )
        }
        .store(in: &cancellables)
    }
}

extension BasicPageController: UIPageViewControllerDataSource {
    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerBefore viewController: UIViewController
    ) -> UIViewController? {
        guard let viewControllerIndex = vm.controllers.firstIndex(of: viewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else {
            return nil
        }
        
        guard vm.controllers.count > previousIndex else {
            return nil
        }
        
        return vm.controllers[safe: previousIndex]
    }
    
    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerAfter viewController: UIViewController
    ) -> UIViewController? {
        guard let viewControllerIndex = vm.controllers.firstIndex(of: viewController) else {
              return nil
          }
          
          let nextIndex = viewControllerIndex + 1
          let orderedViewControllersCount = vm.controllers.count

          guard orderedViewControllersCount != nextIndex else {
              return nil
          }
          
          guard orderedViewControllersCount > nextIndex else {
              return nil
          }
          
          return vm.controllers[nextIndex]
    }
}

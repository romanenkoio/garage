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
        delegate = self
    }
    
    func binding() {
        cancellables.removeAll()
        
        vm.$controllers.sink { [weak self] controllers in
            guard let vc = controllers.first else { return }
            self?.setViewControllers(
                [vc],
                direction: .forward,
                animated: true
            )
        }
        .store(in: &cancellables)
        
        vm.$index.sink { [weak self] value in
            self?.slideToPage(index: value)
        }
        .store(in: &cancellables)
    }
    
    private func slideToPage(index: Int) {
        let count = vm.controllers.count
        if index < count {
            if index > vm.index {
                if let vc = vm.controllers[safe: index] {
                    self.setViewControllers(
                        [vc],
                        direction: .forward,
                        animated: true,
                        completion: { (complete) -> Void in
                            self.vm.index = index
                        })
                }
            } else if index < vm.index {
                if let vc = vm.controllers[safe: index] {
                    self.setViewControllers(
                        [vc],
                        direction: .reverse,
                        animated: true,
                        completion: { (complete) -> Void in
                            self.vm.index = index
                        })
                }
            }
        }
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
                
        return vm.controllers[safe: nextIndex]
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        guard let firstViewController = viewControllers?.first,
              let firstViewControllerIndex = vm.controllers.firstIndex(of: firstViewController)
        else {
            self.vm.index = 0
            return 0
        }
        self.vm.index = firstViewControllerIndex
        return firstViewControllerIndex
    }
}

extension BasicPageController: UIPageViewControllerDelegate {
    func pageViewController(
        _ pageViewController: UIPageViewController,
        didFinishAnimating finished: Bool,
        previousViewControllers: [UIViewController],
        transitionCompleted completed: Bool
    ) {
        if completed {
            vm.setIndexCandidate()
        }
    }
    
    func pageViewController(
        _ pageViewController: UIPageViewController,
        willTransitionTo pendingViewControllers: [UIViewController]
    ) {
        guard let controller = pendingViewControllers.first,
              let index = vm.controllers.firstIndex(of: controller)
        else { return }
        
        vm.indexCandidate = index
    }
}

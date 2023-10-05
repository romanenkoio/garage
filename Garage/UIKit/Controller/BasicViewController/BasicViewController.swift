//
//  BasicViewController.swift
//  Logogo
//
//  Created by Illia Romanenko on 13.05.23.
//

import UIKit
import Combine
import SPIndicator

class BasicViewController: UIViewController {
    var cancellables: Set<AnyCancellable> = []
    
    typealias Coordinator = BasicCoordinator

    private var coordinator: Coordinator!
    private(set) var viewModel = BasicControllerModel()
    private(set) var isWillAppeared: Bool = false
    
    lazy var scroll: UIScrollView = {
        let scroll = UIScrollView()
        scroll.showsHorizontalScrollIndicator = false
        return scroll
    }()
    
     lazy var contentView: BasicView = {
        let view = BasicView()
        return view
    }()
    
    private lazy var header = BasicStackView()
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    deinit {
//        print("deinit BasicController")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configure()
        binding()
        setupGestures()
        layoutElements()
        makeConstraints()
        coordinator = BasicCoordinator(vc: self)
        self.navigationItem.setHidesBackButton(true, animated: false)
        hideTabBar(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if !self.isWillAppeared {
            self.isWillAppeared = true
            self.singleWillAppear()
        }
    }

    func singleWillAppear() { }

    func binding() {
        cancellables.removeAll()
        viewModel.isLoadind.sink { [weak self] value in
            guard let self else { return }
            value ? self.showLoader() : self.dismissLoader()
        }
        .store(in: &cancellables)
    }
    
    func makeConstraints() {
        contentView.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.leading.trailing.equalTo(view)
        }
        
        self.scroll.snp.makeConstraints { (make) in
            // Uncomment after fix controllers with AutoLayout bug
//            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
//            make.leading.trailing.bottom.equalToSuperview()
            
            // Remove this constraint after fix bug
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func hideNavBar(_ value: Bool) {
        navigationController?.setNavigationBarHidden(value, animated: true)
    }
    
    func hideTabBar(_ value: Bool) {
        self.tabBarController?.tabBar.isHidden = value
    }

    func disableScrollView() {
        scroll.removeFromSuperview()
        view.addSubview(contentView)
        
        contentView.snp.remakeConstraints { (make) in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.bottom.leading.trailing.equalToSuperview()
        }
    }

    func layoutElements() {
        view.addSubview(header)
        view.addSubview(scroll)
        scroll.addSubview(contentView)
    }
    
    func configure() {}
    
    private func setupGestures() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tap.delegate = self
        self.view.addGestureRecognizer(tap)

        self.navigationController?.interactivePopGestureRecognizer?.delegate = self as UIGestureRecognizerDelegate
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }

    @objc func hideKeyboard() {
        self.view.endEditing(true)
    }
}

extension BasicViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        gestureRecognizer.cancelsTouchesInView = gestureRecognizer is UIScreenEdgePanGestureRecognizer
     
        return true
    }
}

// MARK: navbar buttons

extension BasicViewController {
    func makeLeftNavBarButtons(buttons: [NavBarButton.ViewModel]) {
        let views = buttons.map({
            let view = NavBarButton()
            view.setViewModel($0)
            return UIBarButtonItem(customView: view)
        })
        self.navigationItem.leftBarButtonItems = views
    }
    
    func makeRightNavBarButton(buttons: [NavBarButton.ViewModel]) {
        let views = buttons.map({
            let view = NavBarButton()
            view.setViewModel($0)
            return UIBarButtonItem(customView: view)
        })
        self.navigationItem.rightBarButtonItems = views
    }
    
    func makeCloseButton(side: ButtonSide) {
        let image: UIImage?
        switch side {
        case .left:
            image = UIImage(named: "back_arrow_ic")
        case .right:
            image = UIImage(named: "back_ic")
        }
        
        let closeButton = NavBarButton()
        let vm = NavBarButton.ViewModel(
            action: .touchUpInside { [weak self] in
                self?.coordinator.navigateTo(CommonNavigationRoute.close)
            },
            image: image)
        
        closeButton.setViewModel(vm)
        
        switch side {
        case .left:
            self.navigationItem.leftBarButtonItems = [UIBarButtonItem(customView: closeButton)]
        case .right:
            self.navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: closeButton)]
        }
        self.hideNavBar(false)
    }
    
    func makeLogoNavbar() {
        let logoImageView = UIImageView(frame: .init(x: 0, y: 0, width: 123, height: 31))
        logoImageView.image = UIImage(named: "logo")
        logoImageView.contentMode = .scaleAspectFit
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: logoImageView)
    }
}

extension BasicViewController {
    enum ButtonSide {
        case left
        case right
    }
}



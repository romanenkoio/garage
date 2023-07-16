//
//  BasicViewController.swift
//  Logogo
//
//  Created by Illia Romanenko on 13.05.23.
//

import UIKit
import Combine

class BasicViewController: UIViewController {
    var cancellables: Set<AnyCancellable> = []
    
    typealias Coordinator = BasicCoordinator

    private var coordinator: Coordinator!
    private(set) var viewModel = BasicControllerModel()
    private(set) var isWillAppeared: Bool = false
    private(set) var tableView = UITableView()

    lazy var scroll: UIScrollView = {
        let scroll = UIScrollView()
        return scroll
    }()
    
     lazy var contentView: BasicView = {
        let view = BasicView()
        return view
    }()
    
    lazy var loaderView: BasicView = {
        let view = BasicView()
        view.backgroundColor = .clear
        view.cornerRadius = 0
        return view
    }()
    
    lazy var spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.style = .large
        spinner.color = .primaryBlue
        return spinner
    }()
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    deinit {
        print("deinit BasicController")
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
            value ? self.startLoader() : self.stopLoader()
        }
        .store(in: &cancellables)
    }
    
    func makeConstraints() {
        contentView.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.leading.trailing.equalTo(view)
        }
        
        self.scroll.snp.makeConstraints { (make) in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        loaderView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        spinner.snp.makeConstraints { make in
            make.center.equalToSuperview()
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
            make.top.bottom.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
        }
    }

    func layoutElements() {
        view.addSubview(scroll)
        scroll.addSubview(contentView)
        view.addSubview(loaderView)
        loaderView.addSubview(spinner)
        loaderView.isHidden = true
        view.bringSubviewToFront(loaderView)
    }
    
    func configure() {}
    
    private func setupGestures() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tap.delegate = self
        self.view.addGestureRecognizer(tap)
    }

    @objc func hideKeyboard() {
        self.view.endEditing(true)
    }
    
    func startLoader() {
        view.bringSubviewToFront(loaderView)
        spinner.startAnimating()
        loaderView.isHidden = false
    }
    
    func stopLoader() {
        spinner.stopAnimating()
        loaderView.isHidden = true
    }
}

extension BasicViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        gestureRecognizer.cancelsTouchesInView = false
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
    
    func makeCloseButton(isLeft: Bool = false) {
        let closeButton = NavBarButton()
        let vm = NavBarButton.ViewModel(
            action: .touchUpInside { [weak self] in
                self?.coordinator.navigateTo(CommonNavigationRoute.close)
            },
            image: isLeft ? UIImage(named: "back_arrow_ic") : UIImage(named: "back_ic"))
        closeButton.setViewModel(vm)
        if isLeft {
            self.navigationItem.leftBarButtonItems = [UIBarButtonItem(customView: closeButton)]
        } else {
            self.navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: closeButton)]
        }
        self.hideNavBar(false)
    }
    
    func makeLogoNavbar() {
        let logoImageView = UIImageView(frame: .init(x: 0, y: 0, width: 123, height: 31))
        logoImageView.image = UIImage(named: "logo")
        logoImageView.contentMode = .scaleAspectFit
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: logoImageView)
        
        let proImageView = UIImageView(frame: .init(x: 0, y: 0, width: 61, height: 30))
        proImageView.image = UIImage(named: "sub")
        proImageView.contentMode = .scaleAspectFit
        navigationItem.rightBarButtonItem =  UIBarButtonItem(customView: proImageView)
    }
}

extension BasicViewController: PageControllable {
    var tableViewDelegate: UITableView? {
        get { tableView }
        set { tableView = newValue! }
    }
}

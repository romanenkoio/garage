//
//  BasicModalPresentationController.swift
//  Garage
//
//  Created by Vlad Kulakovsky  on 13.06.23.
//

import UIKit
import Combine

class BasicModalPresentationController: UIViewController {
    var cancellables: Set<AnyCancellable> = []
    
    typealias Coordinator = BasicCoordinator

    private var coordinator: Coordinator!
    private(set) var viewModel = BasicControllerModel()

    private(set) var isWillAppeared: Bool = false

    private lazy var scroll: UIScrollView = {
        let scroll = UIScrollView()
        scroll.delaysContentTouches = false
        return scroll
    }()
    
     lazy var contentView: BasicView = {
        let view = BasicView()
        return view
    }()
    
    lazy var loaderView: BasicView = {
        let view = BasicView()
        view.backgroundColor = .black.withAlphaComponent(0.5)
        view.cornerRadius = 0
        return view
    }()
    
    lazy var spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.style = .medium
        spinner.tintColor = .primaryPink
        return spinner
    }()
    
    public var minimumVelocityToHide: CGFloat = 1500
    public var minimumScreenRatioToHide: CGFloat = 0.5
    public var animationDuration: TimeInterval = 0.2
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        modalTransitionStyle = .crossDissolve
        modalPresentationStyle = .overFullScreen
        configure()
        binding()
        setupGestures()
        layoutElements()
        makeConstraints()
        coordinator = BasicModalCoordinator(modalVC: self)
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
        viewModel.$title.sink { [weak self] title in
            self?.title = title
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

    func disableScrollView() {
        scroll.removeFromSuperview()
        view.addSubview(contentView)
        
        contentView.snp.remakeConstraints { (make) in
            make.top.bottom.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
        }
    }
    
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
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(onPan(_:)))
        panGesture.delegate = self
        self.view.addGestureRecognizer(panGesture)
    }

    @objc private func hideKeyboard() {
        self.view.endEditing(true)
    }
    
    func startLoader() {
        spinner.startAnimating()
        loaderView.isHidden = false
    }
    
    func stopLoader() {
        spinner.stopAnimating()
        loaderView.isHidden = true
    }
    
    // Listen for pan gesture
          
    func slideViewVerticallyTo(_ y: CGFloat) {
        self.view.frame.origin = CGPoint(x: 0, y: y)
    }

    @objc func onPan(_ panGesture: UIPanGestureRecognizer) {
        
        switch panGesture.state {
                
            case .began, .changed:
                // If pan started or is ongoing then
                // slide the view to follow the finger
                let translation = panGesture.translation(in: view)
                let y = max(0, translation.y)
                slideViewVerticallyTo(y)
                
            case .ended:
                // If pan ended, decide it we should close or reset the view
                // based on the final position and the speed of the gesture
                let translation = panGesture.translation(in: view)
                let velocity = panGesture.velocity(in: view)
                let closing = (translation.y > self.view.frame.size.height * minimumScreenRatioToHide) ||
                (velocity.y > minimumVelocityToHide)
                
                if closing {
                    UIView.animate(
                        withDuration: 0.2,
                        delay: 0,
                        options: .preferredFramesPerSecond60) {
                            // If closing, animate to the bottom of the view
                            self.slideViewVerticallyTo(self.view.frame.size.height)
                            self.view.alpha = 0
                        } completion: { isCompleted in
                            if isCompleted {
                                // Dismiss the view when it dissapeared
                                self.dismiss(animated: false, completion: nil)
                            }
                        }
                } else {
                    // If not closing, reset the view to the top
                    UIView.animate(withDuration: animationDuration, animations: {
                        self.slideViewVerticallyTo(0)
                    })
                }
                
            default:
                // If gesture state is undefined, reset the view to the top
                UIView.animate(withDuration: animationDuration, animations: {
                    self.slideViewVerticallyTo(0)
                })
                
        }
    }
    
}

extension BasicModalPresentationController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        gestureRecognizer.cancelsTouchesInView = false
        return true
    }
}


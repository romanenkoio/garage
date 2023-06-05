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
    
    private lazy var scroll: UIScrollView = {
        let scroll = UIScrollView()
        scroll.delaysContentTouches = false
        return scroll
    }()
    
     lazy var contentView: BasicView = {
        let view = BasicView()
        return view
    }()
    
    init() {
        super.init(nibName: nil, bundle: nil)
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
    }
    
    func binding() {}
    
    func makeConstraints() {
        contentView.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.leading.trailing.equalTo(view)
        }
        
        self.scroll.snp.makeConstraints { (make) in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
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
    }
    
    func configure() {}
    
    private func setupGestures() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        self.view.addGestureRecognizer(tap)
    }

    @objc private func hideKeyboard() {
        self.view.endEditing(true)
    }
    
}

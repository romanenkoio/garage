//
//  PhotoView.swift
//  Garage
//
//  Created by Vlad Kulakovsky  on 13.06.23.
//

import UIKit

class PhotoView: BasicView {
    lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.isUserInteractionEnabled = true
        return view
    }()
    
    lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.maximumZoomScale = 4
        scroll.minimumZoomScale = 1
        scroll.delegate = self
        return scroll
    }()
    
    private(set) var viewModel: ViewModel?
    private var navIsHidden = false
    override func initView() {
        makeLayout()
        makeConstraints()
        setupGestures()
        backgroundColor = .clear
        self.isUserInteractionEnabled = true
    }
    
    private func makeLayout() {
        addSubview(scrollView)
        scrollView.addSubview(imageView)
    }
    
    private func makeConstraints() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.height.equalTo(scrollView)
        }
    }
    
    private func setupGestures() {
        let scrollViewDoubleTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(onDoubleTap(sender: )))
        scrollViewDoubleTapRecognizer.numberOfTapsRequired = 2
        scrollViewDoubleTapRecognizer.delegate = self
        scrollViewDoubleTapRecognizer.cancelsTouchesInView = true
        scrollViewDoubleTapRecognizer.delaysTouchesBegan = true
        scrollView.addGestureRecognizer(scrollViewDoubleTapRecognizer)
        
        
        let imageViewSingleTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageViewDidTap))
        imageViewSingleTapRecognizer.delaysTouchesBegan = true
        imageViewSingleTapRecognizer.numberOfTapsRequired = 1
        imageViewSingleTapRecognizer.delegate = self
        imageView.addGestureRecognizer(imageViewSingleTapRecognizer)
        
        imageViewSingleTapRecognizer.require(toFail: scrollViewDoubleTapRecognizer)
    }
    
    func setViewModel(_ vm: ViewModel) {
        cancellables.removeAll()

        self.viewModel = vm
        vm.$image
            .sink { [weak self] in self?.imageView.image = $0 }
            .store(in: &cancellables)
    }
    
    @objc func onDoubleTap(sender: UITapGestureRecognizer) {
        let scale = min(scrollView.zoomScale * 2.5, scrollView.maximumZoomScale)
       
        if scale != scrollView.zoomScale, scrollView.zoomScale != 2.5 {
           
            let point = sender.location(in: imageView)
            
            let scrollSize = scrollView.frame.size
            let size = CGSize(width: scrollSize.width / scale,
                              height: scrollSize.height / scale)
            let origin = CGPoint(x: point.x - size.width / 2,
                                 y: point.y - size.height / 2)
            scrollView.zoom(to:CGRect(origin: origin, size: size), animated: true)
        } else {
            scrollView.setZoomScale(1, animated: true)
            
        }
    }
    
    @objc private func imageViewDidTap(sender: UITapGestureRecognizer) {
        viewModel?.singleTapAction()
    }
}

extension PhotoView: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        if scrollView.zoomScale > 1 {
                viewModel?.zoomAction()
            if let image = imageView.image {
                let ratioW = imageView.frame.width / image.size.width
                let ratioH = imageView.frame.height / image.size.height
                
                let ratio = ratioW < ratioH ? ratioW : ratioH
                let newWidth = image.size.width * ratio
                let newHeight = image.size.height * ratio
                let conditionLeft = newWidth*scrollView.zoomScale > imageView.frame.width
                let left = 0.5 * (conditionLeft ? newWidth - imageView.frame.width : (scrollView.frame.width - scrollView.contentSize.width))
                let conditioTop = newHeight*scrollView.zoomScale > imageView.frame.height
                
                let top = 0.5 * (conditioTop ? newHeight - imageView.frame.height : (scrollView.frame.height - scrollView.contentSize.height))
                
                scrollView.contentInset = UIEdgeInsets(top: top, left: left, bottom: top, right: left)
            }
        } else {
            scrollView.contentInset = .zero
        }
    }
}

extension PhotoView: UIGestureRecognizerDelegate {

}

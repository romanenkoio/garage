//
//  BasicIMageScrollableView.swift
//  Garage
//
//  Created by Vlad Kulakovsky  on 9.06.23.
//

import Foundation
import UIKit
import Photos
import PhotosUI
import Combine

enum BasicImageListViewType {
    case addPhoto
    case watchPhoto
}

class BasicImageListView: BasicView {
    enum ImageType {
        case delete
        case append
    }
    
    private var imagePicker: PHPickerViewController {
        var configuration = PHPickerConfiguration()
        configuration.filter = .images
        configuration.selectionLimit = 5 - (self.viewModel?.items.count ?? 5)
        configuration.preferredAssetRepresentationMode = .current
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        return picker
    }
    
    private var cameraPicker: UIImagePickerController {
        let picker = UIImagePickerController()
        picker.cameraCaptureMode = .photo
        picker.delegate = self
        return picker
    }
    
    private var alertController: UIAlertController  {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let choisePhotoAction = UIAlertAction(title: "Выбрать из галереи", style: .default) { [weak self] _ in
            self?.presentPicker()
        }
    
        if let takePhotoAction = action(for: .camera, title: "Сделать фото") { alert.addAction(takePhotoAction)}
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel)
        alert.addAction(choisePhotoAction)
        alert.addAction(cancelAction)
        return alert
    }
    
    private lazy var stack: BasicStackView = {
        let stack = BasicStackView()
        stack.axis = .horizontal
        stack.spacing = 10
        stack.distribution = .fillEqually
        return stack
    }()
    
    private var items: [BasicImageViewWithButton] = []
    private(set) var viewModel: ViewModel?
    
    override init() {
        super.init()
        layoutElements()
        makeConstraints()
    }
    
    private func layoutElements() {
        addSubview(stack)
    }
    
    private func makeConstraints() {
        stack.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        snp.makeConstraints { make in
            make.height.equalTo(60)
        }
    }
    
    func setViewModel(_ vm: ViewModel) {
        self.viewModel = vm
        
        vm.$items.sink {[weak self] images in
            self?.stack.clearArrangedSubviews()
            self?.items.removeAll()
            
            stride(from: 0, to: 5, by: 1).forEach { cycleIndex in
                self?.makeItems(
                    atFirst: cycleIndex,
                    for: .append
                )
                
                images.enumerated().forEach { imageIndex, image in
                    
                    if imageIndex == cycleIndex {
                        self?.makeItems(
                            atFirst: imageIndex,
                            atSecond: cycleIndex,
                            for: .delete,
                            with: image
                        )
                    }
                }
            }
        }
        .store(in: &cancellables)
    }
    
    func makeItems(
        atFirst index: Int,
        atSecond secondIndex: Int? = nil,
        for type: ImageType,
        with image: UIImage? = nil
    ) {
        switch type {
            case .append:
                let imageView = BasicImageViewWithButton()
                imageView.setViewModel(
                    .init(
                        image: UIImage(),
                        buttonStyle: .addImage,
                        buttonVM: .init(
                            action: .touchUpInside {[weak self] in
                                self?.viewModel?.selectedIndex = index
                                self?.presentAlert()
                            })
                    )
                )

                items.append(imageView)
                stack.addArrangedSubview(imageView)
                
            case .delete:
                guard let image,
                      let secondIndex else { return }
                
                self.stack.arrangedSubviews[index].removeFromSuperview()
                self.items.remove(at: index)
                
                let imageView = BasicImageViewWithButton()
                imageView.setViewModel(
                    .init(
                        image: image,
                        buttonStyle: .removeImage,
                        buttonVM: .init(
                            action: .touchUpInside {[weak self] in
                                self?.viewModel?.items.remove(at: secondIndex)
                            })
                    )
                )
                
                items.append(imageView)
                stack.addArrangedSubview(imageView)
        }
            
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func action(for type: UIImagePickerController.SourceType, title: String) -> UIAlertAction? {
        guard UIImagePickerController.isSourceTypeAvailable(type) else {
            return nil
        }
        
        return UIAlertAction(title: title, style: .default) { [weak self] _ in
            self?.presentPicker()
        }
    }
    
    @objc private func presentAlert() {
        let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
        sceneDelegate?.window?.rootViewController?.present(alertController, animated: true)
    }
    
    private func presentPicker() {
        let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
        sceneDelegate?.window?.rootViewController?.present(imagePicker, animated: true)
    }

}

extension BasicImageListView: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)

        guard !results.isEmpty else {
            // Пользователь не выбрал ни одного элемента
            return
        }
        
        for result in results {
            let itemProvider = result.itemProvider
            if itemProvider.canLoadObject(ofClass: UIImage.self) {
                itemProvider.loadObject(ofClass: UIImage.self) { [weak self] (image, error) in
                    if let image = image as? UIImage {
                        DispatchQueue.main.async {
                            self?.displaySelectedImage(image)
                        }
                    }
                }
            }
        }
    }
    
    func displaySelectedImage(_ image: UIImage) {
        self.viewModel?.didAddedImage(image)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
    }
}

extension BasicImageListView: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
}

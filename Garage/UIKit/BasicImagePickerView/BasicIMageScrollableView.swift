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
import SnapKit

class BasicImageListView: BasicView {
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
    
    private lazy var descriptionLabel = BasicLabel()
    
    private lazy var editButton = BasicButton()
    
    private lazy var stack: BasicStackView = {
        let stack = BasicStackView()
        stack.axis = .horizontal
        stack.spacing = 10
        stack.distribution = .fillEqually
        return stack
    }()
    
    private var items: [BasicImageButton] = []
    private(set) var viewModel: ViewModel?
    
    override init() {
        super.init()
        layoutElements()
        makeConstraints()
        backgroundColor = .clear
        cornerRadius = 0
    }
    
    private func layoutElements() {
        addSubview(stack)
        addSubview(descriptionLabel)
        addSubview(editButton)
    }
    
    private func makeConstraints() {
        descriptionLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalToSuperview()
            make.trailing.equalTo(editButton).inset(10)
        }
        
        editButton.snp.remakeConstraints { make in
            make.centerY.equalTo(descriptionLabel)
            make.trailing.equalToSuperview()
        }
        
        stack.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(5)
            make.leading.trailing.bottom.equalToSuperview().inset(UIEdgeInsets.horizintal)
        }
    }
    
    func setViewModel(_ vm: ViewModel) {
        self.viewModel = vm
        
        if let descriptionLabelVM = vm.descriptionLabelVM {
            descriptionLabel.setViewModel(descriptionLabelVM)
        }
        
        if let editButtonVM = vm.editButtonVM {
            editButton.setViewModel(editButtonVM)
        }

    
        vm.$items.sink {[weak self] images in
            self?.stack.clearArrangedSubviews()
            self?.items.removeAll()
            
            stride(from: 0, to: 5, by: 1).forEach { cycleIndex in
                self?.makeItems(at: cycleIndex)
                
                images.enumerated().forEach { imageIndex, image in
                    
                    if imageIndex == cycleIndex {
                        self?.makeRemoveItems(at: imageIndex, with: image)
                    }
                }
            }
        }
        .store(in: &cancellables)
        
        vm.$editingEnabled.sink { value in
            self.items.forEach { imageButton in
                guard let value else { return }
                imageButton.viewModel?.buttonVM?.isHidden = !value
            }
        }
        .store(in: &cancellables)
        
        vm.$selectedIndex.sink { [weak self] index in
            guard let index else { return }
            self?.presentPhotoViewVC(vm, on: index)
        }
        .store(in: &cancellables)
    }
    
    private func makeRemoveItems(at index: Int, with image: UIImage) {
        self.stack.arrangedSubviews[index].removeFromSuperview()
        self.items.remove(at: index)
        guard let vm = viewModel else { return }
        
        let imageView = BasicImageButton()
        imageView.setViewModel(.init(
            action: { [weak self] in
                self?.viewModel?.selectedIndex = index
            },
            image: image
            ,
            buttonVM: .init(
                style: .removeImage,
                action: .touchUpInside { [weak self] in
                    self?.viewModel?.items.remove(at: index)
                })
        ))
        
        items.append(imageView)
        stack.addArrangedSubview(imageView)
    }
    
    func makeItems(at index: Int) {
        let imageView = BasicImageButton()
        imageView.setViewModel(.init(
            action: {[weak self] in
                print("test from view")
            },
            image: UIImage(),
            buttonVM: .init(
                style: .addImage,
                action: .touchUpInside {[weak self] in
                    self?.presentAlert()
                })
        ))
        
        items.append(imageView)
        stack.addArrangedSubview(imageView)
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
    
    private func presentPhotoViewVC(_ vm: ViewModel, on index: Int) {
        let fullSizePhotoViewVC = FullSizePhotoViewController(
            vm: FullSizePhotoViewController.ViewModel(
                images: vm.items,
                selectedIndex: index
            )
        )
        
        let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
        sceneDelegate?.window?.rootViewController?.present(fullSizePhotoViewVC, animated: true)
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

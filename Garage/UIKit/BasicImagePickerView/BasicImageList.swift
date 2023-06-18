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
    private lazy var stack: BasicStackView = {
        let stack = BasicStackView()
        stack.axis = .vertical
        stack.spacing = 13
        stack.distribution = .fill
        return stack
    }()
    
    private lazy var imageStack: BasicStackView = {
        let stack = BasicStackView()
        stack.axis = .horizontal
        stack.spacing = 10
        stack.distribution = .fillEqually
        return stack
    }()
    
    private lazy var descriptionLabel: BasicLabel = {
        let label = BasicLabel()
        label.textColor = ColorScheme.current.textColor
        label.font = .custom(size: 14, weight: .bold)
        return label
    }()
    
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
        picker.sourceType = .camera
        picker.cameraCaptureMode = .photo
        picker.delegate = self
        return picker
    }
    
    private var alertController: UIAlertController  {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let choisePhotoAction = UIAlertAction(title: "Выбрать из галереи", style: .default) { [weak self] _ in
            guard let self else { return }
            presentOnRootViewController(self.imagePicker, animated: true)
        }
        
        let takePhotAction = UIAlertAction(title: "Сделать фото", style: .default) { [weak self] _ in
            guard let self else { return }
            presentOnRootViewController(self.cameraPicker, animated: true)
        }
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel)
        alert.addAction(takePhotAction)
        alert.addAction(choisePhotoAction)
        alert.addAction(cancelAction)
        return alert
    }
    
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
        stack.addArrangedSubviews([descriptionLabel,imageStack])
    }
    
    private func makeConstraints() {
        stack.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func setViewModel(_ vm: ViewModel) {
        self.viewModel = vm
        
        if let descriptionLabelVM = vm.descriptionLabelVM {
            descriptionLabel.setViewModel(descriptionLabelVM)
        }
    
        vm.$items.sink {[weak self] images in
            self?.imageStack.clearArrangedSubviews()
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
        self.imageStack.arrangedSubviews[index].removeFromSuperview()
        self.items.remove(at: index)
        guard let vm = viewModel else { return }
        
        let imageView = BasicImageButton()
        imageView.setViewModel(
            .init(
                action: { vm.selectedIndex = index },
                style: .photo,
                image: image,
                buttonVM: .init(
                    style: .removeImage,
                    action: .touchUpInside { vm.items.remove(at: index) }
                )
            )
        )
        
        items.append(imageView)
        imageStack.addArrangedSubview(imageView)
    }
    
    func makeItems(at index: Int) {
        let imageView = BasicImageButton()
        imageView.alpha = viewModel?.editingEnabled ?? false ? 1 : 0
        imageView.setViewModel(
            .init(
                style: .empty,
                image: UIImage(),
                buttonVM: .init(
                    style: .addImage,
                    action: .touchUpInside { [weak self] in
                        guard let self else { return }
                        self.presentOnRootViewController(self.alertController, animated: true)
                        
                    }
                )
            )
        )
        
        items.append(imageView)
        imageStack.addArrangedSubview(imageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func presentPhotoViewVC(_ vm: ViewModel, on index: Int) {
        let fullSizePhotoViewVC = FullSizePhotoViewController(
            vm: FullSizePhotoViewController.ViewModel(
                images: vm.items,
                selectedIndex: index
            )
        )
        
        presentOnRootViewController(fullSizePhotoViewVC, animated: true)
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
                        guard let compressedImageData = image.jpegData(compressionQuality: 0.8) else { return }
                        guard let compressedImage = UIImage(data: compressedImageData) else { return }
                        DispatchQueue.main.async {
                            self?.displaySelectedImage(compressedImage)
                        }
                    }
                }
            }
        }
    }
    
    func displaySelectedImage(_ image: UIImage) {
        self.viewModel?.didAddedImage(image)
    }
}

extension BasicImageListView: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        guard let image = info[.originalImage] as? UIImage else { return }
        guard let compressedImageData = image.jpegData(compressionQuality: 0.8) else { return }
        guard let compressedImage = UIImage(data: compressedImageData) else { return }
        displaySelectedImage(compressedImage)
    }
}

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

class BasicImageViewWithButton: UIImageView {
    var cancellables: Set<AnyCancellable> = []
    lazy var actionButton = BasicButton()
    private(set) var viewModel: ViewModel?
    private(set) var buttonStyle: ButtonStyle?
    
    init() {
        super.init(frame: .zero)
        snp.makeConstraints { make in
            make.height.width.equalTo(55)
        }
        layer.borderWidth = 1
        layer.borderColor = UIColor.gray.withAlphaComponent(0.5).cgColor
        cornerRadius = 8
        backgroundColor = .primaryGray
        contentMode = .scaleToFill
        isUserInteractionEnabled = true
        makeLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func makeLayout() {
        addSubview(actionButton)
    }
    
    private func makeConstraints() {
        switch buttonStyle {
            case .addImage:
                actionButton.snp.remakeConstraints { make in
                    make.center.equalToSuperview()
                    make.height.width.equalTo(35)
                }
            case .removeImage:
                actionButton.snp.remakeConstraints { make in
                    make.trailing.top.equalToSuperview()
                    make.height.width.equalTo(20)
                }
            default:
                break
        }
    }
    
    func setViewModel(_ vm: ViewModel) {
        actionButton.setViewModel(vm.buttonVM)
        
        vm.$image.sink {[weak self] image in
            guard let self else { return }
            self.image = image
        }
        .store(in: &cancellables)
        
        vm.$buttonStyle.sink {[weak self] style in
            self?.buttonStyle = style
            self?.makeConstraints()
        }
            .store(in: &cancellables)
    }
    
    @objc func testAction() {
        print("testAction")
    }
}

extension BasicImageViewWithButton {
    class ViewModel: BasicViewModel {
        var buttonVM: BasicButton.ViewModel
        @Published var image: UIImage
        @Published var buttonStyle: ButtonStyle
        
        init(buttonVM: BasicButton.ViewModel, image: UIImage, buttonStyle: ButtonStyle) {
            self.buttonVM = buttonVM
            self.image = image
            self.buttonStyle = buttonStyle
            buttonVM.style = buttonStyle
        }
    }
}


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
        let choisePhotoAction = UIAlertAction(title: "Выбрать фото", style: .default) {[weak self] _ in
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
        makeItems()
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
        vm.$items.sink { images in
            images.enumerated().forEach {[weak self] index, image in
                self?.items[index].setViewModel(
                    .init(buttonVM:
                            .init(action:
                                    .touchUpInside {
                                        self?.removeImages(at: index, vm: vm)
                                        vm.items.remove(at: index)
                                    }),
                          image: image,
                          buttonStyle: .removeImage
                    )
                )
            }
        }
        .store(in: &cancellables)
        
        
    }
    
    func makeItems(with images: [UIImage]? = nil) {
        stack.clearArrangedSubviews()
        self.items.removeAll()
        guard images == nil else { return }
            stride(from: 0, to: 5, by: 1).forEach { index in
                let imageView = BasicImageViewWithButton()
                imageView.setViewModel(
                    .init(buttonVM:
                            .init(action:
                                    .touchUpInside {
                                            self.viewModel?.selectedIndex = index
                                            self.presentAlert()
                                    }),
                          image: UIImage(),
                          buttonStyle: .addImage
                    )
                )
                
                self.items.append(imageView)
                stack.addArrangedSubview(imageView)
        }
    }
    
    private func removeImages(at index: Int, vm: ViewModel) {
        
        self.items[index].setViewModel(
            .init(buttonVM:
                    .init(action:
                            .touchUpInside {
                                self.presentAlert()
                                vm.selectedIndex = index
                            }
                    ),
                  image: UIImage(),
                  buttonStyle: .addImage
            )
        )
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

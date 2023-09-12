//
//  CreateServiseViewController.swift
//  Garage
//
//  Created by Illia Romanenko on 7.06.23.
//  
//

import UIKit
import Photos
import PhotosUI

class CreateServiseViewController: BasicViewController {

    // - UI
    typealias Coordinator = CreateServiseControllerCoordinator
    typealias Layout = CreateServiseControllerLayoutManager
    
    // - Property
    private(set) var vm: ViewModel
    
    // - Manager
    private var coordinator: Coordinator!
    private var layout: Layout!
    
    private var imagePicker: PHPickerViewController {
        var configuration = PHPickerConfiguration()
        configuration.filter = .images
        configuration.selectionLimit = 1
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
        picker.cameraDevice = .rear
        return picker
    }

    init(vm: ViewModel) {
        self.vm = vm
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
    }
    
    private func setupNavBar() {
        makeCloseButton(side: .left)

        guard case .edit(_) = vm.mode else {
            title = "Добавление сервиса"
            
            let readQRButton = NavBarButton.ViewModel(action: .touchUpInside { [weak self] in
                guard let self else { return }
                self.coordinator.navigateTo(CommonNavigationRoute.presentOnTop(alertController))
            }, image: UIImage(named: "qr_ic"))
            makeRightNavBarButton(buttons: [readQRButton])
            return
        }
        
        let deleteButton = NavBarButton.ViewModel(
            action: .touchUpInside { [weak self] in
                let vm = Dialog.ViewModel(
                    title: .text("Вы уверены, что хотите удалить сервис?")
                ) { [weak self] in
                    self?.vm.removeService() { [weak self] in
                        self?.dismiss(animated: true)
                        self?.coordinator.navigateTo(CommonNavigationRoute.close)
                    }
                }
                self?.coordinator.navigateTo(CommonNavigationRoute.confirmPopup(vm: vm))
            },
            image: UIImage(named: "delete_ic")
        )
        title = "Изменение сервиса"
        makeRightNavBarButton(buttons: [deleteButton])
    }

    override func configure() {
        configureCoordinator()
        configureLayoutManager()
    }

    override func binding() {
        layout.saveButton.setViewModel(vm.saveButtonVM)
        layout.nameInput.setViewModel(vm.nameInputVM)
        layout.phoneInput.setViewModel(vm.phoneInputVM)
        layout.specialisationInput.setViewModel(vm.specialisationInputVM)
        layout.adressInput.setViewModel(vm.adressInputVM)
        layout.commentInput.setViewModel(vm.commenntInputVM)
        
        vm.saveCompletion = { [weak self] in
            self?.coordinator.navigateTo(CommonNavigationRoute.close)
        }
    }
    
    private var alertController: UIAlertController  {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let choisePhotoAction = UIAlertAction(title: "Из галереи", style: .default) { [weak self] _ in
            guard let self else { return }
            self.coordinator.navigateTo(CommonNavigationRoute.presentOnTop(imagePicker))
        }
        
        let takePhotAction = UIAlertAction(title: "Камера", style: .default) { [weak self] _ in
            guard let self else { return }
            self.coordinator.navigateTo(CreateServiseNavigationRoute.readServiceCamera(vm.qrReaderVM))
        }
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel)
        alert.addAction(takePhotAction)
        alert.addAction(choisePhotoAction)
        alert.addAction(cancelAction)
        return alert
    }
}

// MARK: -
// MARK: - Configure

extension CreateServiseViewController {

    private func configureCoordinator() {
        coordinator = CreateServiseControllerCoordinator(vc: self)
    }
    
    private func configureLayoutManager() {
        layout = CreateServiseControllerLayoutManager(vc: self)
    }
    
}

extension CreateServiseViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]
    ) {
        picker.dismiss(animated: true)
        
        guard let image = info[.originalImage] as? UIImage,
              let qrData = QRGenerator().readQRImage(image)
        else { return }
        
        vm.qrReaderVM.found(code: qrData)
    }
}

extension CreateServiseViewController: PHPickerViewControllerDelegate {
    func picker(
        _ picker: PHPickerViewController,
        didFinishPicking results: [PHPickerResult]
    ) {
        picker.dismiss(animated: true)
        
        guard !results.isEmpty,
              let photo = results.first
        else { return }
        
        let itemProvider = photo.itemProvider
        if itemProvider.canLoadObject(ofClass: UIImage.self) {
            itemProvider.loadObject(ofClass: UIImage.self) { [weak self] (image, error) in
                guard let image = image as? UIImage,
                      let qrData = QRGenerator().readQRImage(image)
                else { return }
                DispatchQueue.main.async {
                    self?.vm.qrReaderVM.found(code: qrData)
                }
            }
        }
    }
}

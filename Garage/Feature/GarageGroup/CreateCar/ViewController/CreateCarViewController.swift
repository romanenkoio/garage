//
//  CreateCarViewController.swift
//  Garage
//
//  Created by Illia Romanenko on 6.06.23.
//  
//

import UIKit
import Photos
import PhotosUI

class CreateCarViewController: BasicViewController {

    // - UI
    typealias Coordinator = CreateCarControllerCoordinator
    typealias Layout = CreateCarControllerLayoutManager
    
    // - Property
    private(set) var vm: ViewModel
    
    // - Manager
    private(set) var coordinator: Coordinator!
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
        title = "Добавить машину"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        hideNavBar(false)
        setupNavBar()
    }

    override func configure() {
        configureCoordinator()
        configureLayoutManager()
    }

    private func setupNavBar() {
        makeCloseButton(isLeft: true)
        
        guard case .edit(_) = vm.mode else {
            title = "Изменить машину"
            return
        }

        let deleteButton = NavBarButton.ViewModel(
            action: .touchUpInside { [weak self] in
                let vm = Popup.ViewModel(titleVM: .init(.text("Вы уверены, что хотите удалить машину?")))
                vm.confirmButton.action = .touchUpInside { [weak self] in
                    self?.vm.removeCar() { [weak self] in
                        self?.dismiss(animated: true)
                        self?.coordinator.navigateTo(CommonNavigationRoute.closeToRoot)
                    }
                }
                self?.coordinator.navigateTo(CommonNavigationRoute.confirmPopup(vm: vm))
            },
            image: UIImage(named: "delete_ic")
        )
        makeRightNavBarButton(buttons: [deleteButton])
    }
    
    private var alertController: UIAlertController  {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let choisePhotoAction = UIAlertAction(title: "Из галереи", style: .default) { [weak self] _ in
            guard let self else { return }
            self.coordinator.navigateTo(CommonNavigationRoute.presentOnTop(imagePicker))
        }
        
        let takePhotAction = UIAlertAction(title: "Камера", style: .default) { [weak self] _ in
            guard let self else { return }
            self.coordinator.navigateTo(CommonNavigationRoute.presentOnTop(cameraPicker))
        }
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel)
        alert.addAction(takePhotAction)
        alert.addAction(choisePhotoAction)
        alert.addAction(cancelAction)
        return alert
    }
    
    override func binding() {
        super.binding()
        layout.brandField.setViewModel(vm.brandFieldVM)
        layout.modelField.setViewModel(vm.modelFieldVM)
        layout.winField.setViewModel(vm.winFieldVM)
        layout.yearField.setViewModel(vm.yearFieldVM)
        layout.mileageField.setViewModel(vm.mileageFieldVM)
        layout.saveButton.setViewModel(vm.saveButtonVM)
        layout.carImage.setViewModel(vm.carImage)
        
        vm.carImage.action = { [weak self] in
            guard let self else { return }
            coordinator.navigateTo(CommonNavigationRoute.presentOnTop(alertController))
        }
        
        vm.isLoadind.sink { [weak self] value in
            value ? self?.showLoader() : self?.removeLoader()
        }
        .store(in: &cancellables)
        
        vm.succesCreateCompletion = { [weak self] in
            self?.coordinator.navigateTo(CommonNavigationRoute.close)
        }
        
        vm.suggestionCompletion = { [weak self] items in
            let vm = SelectionViewController.ViewModel(cells: items)

            vm.selectionSuccess = { [weak self] selectedItem in
                if let selected = selectedItem as? Brand {
                    self?.vm.brandFieldVM.text = selected.name
                    self?.vm.modelFieldVM.actionImageVM?.isEnabled = true
                    self?.vm.modelFieldVM.text = .empty
                } else if let seleted = selectedItem as? Model {
                    self?.vm.modelFieldVM.text = seleted.modelName
                }
                self?.dismiss(animated: true)
            }
           
            self?.coordinator.navigateTo(CreateCarNavigationRoute.selectSuggestion(vm))
        }
    }
}

// MARK: -
// MARK: - Configure

extension CreateCarViewController {

    private func configureCoordinator() {
        coordinator = CreateCarControllerCoordinator(vc: self)
    }
    
    private func configureLayoutManager() {
        layout = CreateCarControllerLayoutManager(vc: self)
    }
    
}

extension CreateCarViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        guard !results.isEmpty else {
            // Пользователь не выбрал ни одного элемента
            return
        }
        
        guard let photo = results.first else { return }
        
        let itemProvider = photo.itemProvider
        if itemProvider.canLoadObject(ofClass: UIImage.self) {
            itemProvider.loadObject(ofClass: UIImage.self) { [weak self] (image, error) in
                if let image = image as? UIImage, let resized = image.resizeImage() {
                    DispatchQueue.main.async {
                        self?.vm.carImage.logoVM.set(from: resized)
                    }
                }
            }
        }
    }
}

extension CreateCarViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        if let image = info[.originalImage] as? UIImage {
            self.vm.carImage.logoVM.set(from: image)
        }
    }
}

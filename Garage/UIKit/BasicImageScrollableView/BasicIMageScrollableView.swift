//
//  BasicIMageScrollableView.swift
//  Garage
//
//  Created by Vlad Kulakovsky  on 9.06.23.
//

import Foundation
import UIKit
import TLPhotoPicker
import Photos

class BasicImageScrollableView: BasicView {
    var selectedAssets = [TLPHAsset]()
    
    lazy private var imagePicker: TLPhotosPickerViewController = {
        let picker = TLPhotosPickerViewController()
        var configure = TLPhotosPickerConfigure()
        configure.allowedVideo = false
        configure.doneTitle = "Выбрать"
        /// TODO:
        /// настроить конфигурацию и заполнить делегатные методы
        picker.configure = configure
        picker.delegate = self
        return picker
    }()
    
    lazy private var alertController: UIAlertController = {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let choisePhotoaction = UIAlertAction(title: "Выбрать фото", style: .default) {[weak self] _ in
            self?.presentPicker()
        }
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel)
        alert.addAction(choisePhotoaction)
        alert.addAction(cancelAction)
        return alert
    }()
    
    lazy private var testButton = BasicButton()
    
    override init() {
        super.init()
        testButton.addTarget(self, action: #selector(presentAlert), for: .touchUpInside)
        layoutElements()
        makeConstraints()
    }
    
    private func layoutElements() {
        addSubview(testButton)
    }
    
    private func makeConstraints() {
        testButton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func setViewModel(_ vm: ViewModel) {
        testButton.setViewModel(vm.buttonVM)
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

extension BasicImageScrollableView: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
}

extension BasicImageScrollableView: TLPhotosPickerViewControllerDelegate {
    func dismissPhotoPicker(withPHAssets: [PHAsset]) {
        
    }
    
    func dismissPhotoPicker(withTLPHAssets: [TLPhotoPicker.TLPHAsset]) {
        
    }
    
    func shouldDismissPhotoPicker(withTLPHAssets: [TLPhotoPicker.TLPHAsset]) -> Bool {
        self.selectedAssets = withTLPHAssets
        return true
    }
    
    func dismissComplete() {
        
    }
    
    func photoPickerDidCancel() {
        
    }
    
    func canSelectAsset(phAsset: PHAsset) -> Bool {
        return true
    }
    
    func didExceedMaximumNumberOfSelection(picker: TLPhotoPicker.TLPhotosPickerViewController) {
        
    }
    
    func handleNoAlbumPermissions(picker: TLPhotoPicker.TLPhotosPickerViewController) {
        
    }
    
    func handleNoCameraPermissions(picker: TLPhotoPicker.TLPhotosPickerViewController) {
        
    }
}

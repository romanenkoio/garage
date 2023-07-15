//
//  QrServiceReaderViewController.swift
//  Garage
//
//  Created by Illia Romanenko on 15.07.23.
//  
//

import UIKit
import AVFoundation

class QrServiceReaderViewController: BasicViewController {

    // - UI
    typealias Coordinator = QrServiceReaderControllerCoordinator
    typealias Layout = QrServiceReaderControllerLayoutManager
    
    // - Property
    private(set) var vm: ViewModel
    
    // - Manager
    private var coordinator: Coordinator!
    private var layout: Layout!
    
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
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
        view.backgroundColor = UIColor.black
        startSession()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        startSestion()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
            DispatchQueue.global().async { [weak self] in
                guard let self else { return }
                if (captureSession?.isRunning == true) {
                    captureSession.stopRunning()
                }
            }
    }
    
    func startSestion() {
        DispatchQueue.global().async { [weak self] in
            guard let self else { return }
            
            if (captureSession?.isRunning == false) {
                captureSession.startRunning()
            }
        }
    }

    override func configure() {
        configureCoordinator()
        configureLayoutManager()
    }

    override func binding() {
        
    }
    
    private func startSession() {
        view.backgroundColor = UIColor.black
              captureSession = AVCaptureSession()

              guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
              let videoInput: AVCaptureDeviceInput

              do {
                  videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
              } catch {
                  return
              }

              if (captureSession.canAddInput(videoInput)) {
                  captureSession.addInput(videoInput)
              } else {
                  failed()
                  return
              }

              let metadataOutput = AVCaptureMetadataOutput()

              if (captureSession.canAddOutput(metadataOutput)) {
                  captureSession.addOutput(metadataOutput)

                  metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
                  metadataOutput.metadataObjectTypes = [.qr]
              } else {
                  failed()
                  return
              }

              previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
              previewLayer.frame = view.layer.bounds
              previewLayer.videoGravity = .resizeAspectFill
              view.layer.addSublayer(previewLayer)

        DispatchQueue.global().async { [weak self] in
            guard let self else { return }
            captureSession.startRunning()
        }
    }
    
    private func failed() {
        let ac = UIAlertController(title: "Возникла проблема", message: "Вероятно Ваша камера повреждена. Пожалуйста, воспользуйтесь сканированием из библиотеки", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
        captureSession = nil
    }
}

// MARK: -
// MARK: - Configure

extension QrServiceReaderViewController {

    private func configureCoordinator() {
        coordinator = QrServiceReaderControllerCoordinator(vc: self)
    }
    
    private func configureLayoutManager() {
        layout = QrServiceReaderControllerLayoutManager(vc: self)
    }
    
}

extension QrServiceReaderViewController: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        captureSession.stopRunning()
        
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            vm.found(code: stringValue)
        }
        
        dismiss(animated: true)
    }
}

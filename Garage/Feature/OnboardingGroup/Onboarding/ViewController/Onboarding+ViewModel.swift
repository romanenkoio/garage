//
//  Onboarding+ViewModel.swift
//  Garage
//
//  Created by Illia Romanenko on 3.07.23.
//  
//

import UIKit

extension OnboardingViewController {
    final class ViewModel: BasicViewModel {
        let nextButton = AlignedButton.ViewModel(buttonVM: .init(title: "Дальше"))
        let collectionVM = BasicCollectionView.GenericViewModel<OnboardingArticle>()
        
        @Published var currentPath = IndexPath(row: 0, section: 0)

        var closeCompletion: Completion?
        
        override init() {
            collectionVM.setCells(OnboardingArticle.allCases)
            super.init()
            
            nextButton.buttonVM.action = .touchUpInside { [weak self] in
                guard let self else { return }
                if collectionVM.cells.count > currentPath.row + 1 {
                    currentPath = IndexPath(row: currentPath.row + 1, section: 0)
                    if collectionVM.cells.count == currentPath.row + 1 {
                        nextButton.buttonVM.title = "Закрыть"
                    }
                } else {
                    SettingsManager.sh.write(value: false, for: .isFirstLaunch)
                    closeCompletion?()
                }
            }
        }
    }
}



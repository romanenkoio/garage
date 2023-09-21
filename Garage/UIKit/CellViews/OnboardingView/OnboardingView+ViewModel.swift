//
//  OnboardingView+ViewModel.swift
//  Garage
//
//  Created by Illia Romanenko on 3.07.23.
//

import UIKit

extension OnboardingView {
    final class ViewModel: BasicViewModel {
        @Published var image: UIImage?
        
        let type: OnboardingArticle
        let titleVM: BasicLabel.ViewModel
        let subtitleVM: BasicLabel.ViewModel
        
        init(type: OnboardingArticle) {
            self.image = type.image
            self.type = type
            self.titleVM = .init(.text(type.title))
            self.subtitleVM = .init(.text(type.subtitle))
        }
    }
}

enum OnboardingArticle: String, CaseIterable {
    case servises
    case history
    case warnings
    case documents
    
    var image: UIImage? {
        return UIImage(named: "\(self.rawValue)_onb")
    }
    
    var title: String {
        switch self {
        case .servises:     return "Добавляйте свои сервисы"
        case .history:      return "Веди историю обслуживания авто"
        case .warnings:     return "Получай важные напоминания"
        case .documents:    return "Держи все документы в одном месте"
        }
    }
    
    var subtitle: String {
        switch self {
        case .servises:     return "Теперь под рукой контакты всех автосервисов"
        case .history:      return "История обслуживания авто всегда доступна"
        case .warnings:     return "Вы не упустите ничего важного"
        case .documents:    return "Мы напомним о сроке действия документа"
        }
    }
}


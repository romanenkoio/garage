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
            self.titleVM = .init(text: type.title)
            self.subtitleVM = .init(text: type.subtitle)
        }
    }
}

enum OnboardingArticle: CaseIterable {
    case servises
    case history
    case warnings
    
    var image: UIImage? {
        switch self {
        case .servises:     return UIImage(named: "service_onb")
        case .history:      return UIImage(named: "history")
        case .warnings:     return UIImage(named: "warning")
        }
    }
    
    var title: String {
        switch self {
        case .servises:     return "Добавляйте свои сервисы"
        case .history:      return "Добавляйте свои сервисы"
        case .warnings:     return "Получай важные напоминания"
        }
    }
    
    var subtitle: String {
        switch self {
        case .servises:     return "Теперь под рукой контакты всех автосервисов"
        case .history:      return "История обслуживания авто всегда доступна"
        case .warnings:     return "Вы не упустите ничего важного"
        }
    }
}


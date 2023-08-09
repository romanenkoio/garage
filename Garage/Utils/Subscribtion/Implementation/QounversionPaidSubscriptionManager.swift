//
//  QounversionPaidSubscriptionManager.swift
//  Garage
//
//  Created by Yauheni Zhurauski on 30.07.23.
//

import Qonversion

enum SubscriptionType: String {
    case month = "Month"
    case year = "Year"
    case lifetime = "Lifetime"
    case noneType
    
    init?(product: Qonversion.Product) {
        switch product.storeID {
        case "GarageMonthFullAccessSubscribe":
            self = .month
        case "GarageYearFullAccessSubscribe":
            self = .year
        case "GarageFullAccessLifetime":
            self = .lifetime
        default:
            self = .noneType
        }
    }
    
    var priceTitle: String {
        switch self {
        case .month:
            return "месяц"
        case .year:
            return "год"
        case .lifetime, .noneType:
            return .empty
        }
    }
    
    var duration: String {
        switch self {
        case .month:
            return "Месяц"
        case .year:
            return "Год"
        case .lifetime:
                return "Навсегда"
        case .noneType:
            return .empty
        }
    }
    
    var cancelTitle: String {
        switch self {
        case .month, .year:
            return "отмена в любой момент"
        case .lifetime:
            return "разовый платёж"
        case .noneType:
            return .empty
        }
    }
}

final class QounversionPaidSubscriptionManager: SubscriptionsHandler, SubscriptionChecker {

    enum Error: Swift.Error {
        case noAvailableSubscriptions
        case noProductFoundWithGivenID
    }
    
    public init() {}
    
    public func subscriptionStatus(completion: @escaping (Result<PaidSubscriptionInfo?, Swift.Error>) -> Void) {
        Qonversion.shared().checkEntitlements { (entitlements, error) in
            if let error = error {
                completion(.failure(error))
            }
            var subscriptionInfo: PaidSubscriptionInfo?
            
            if let month = entitlements[SubscriptionType.month.rawValue], month.isActive {
                subscriptionInfo = PaidSubscriptionInfo(status: .active, expirationDate: month.expirationDate, productID: month.productID, type: .month)
            } else if let year = entitlements[SubscriptionType.year.rawValue], year.isActive {
                subscriptionInfo = PaidSubscriptionInfo(status: .active, expirationDate: year.expirationDate, productID: year.productID, type: .year)
            } else if let lifetime = entitlements[SubscriptionType.lifetime.rawValue], lifetime.isActive {
                subscriptionInfo = PaidSubscriptionInfo(status: .active, expirationDate: lifetime.expirationDate, productID: lifetime.productID, type: .lifetime)
            } else {
                subscriptionInfo = PaidSubscriptionInfo(status: .inactive, expirationDate: nil, productID: nil, type: .noneType)
            }
            completion(.success(subscriptionInfo))
        }
    }

    public func getOfferings(completion: @escaping (Result<[PaidSubscription], Swift.Error>) -> Void) {
        retrieveOfferings { result in
            switch result {
            case .success(let products):
                completion(.success(products.toSubscriptions()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    public func purchase(
        subscription: PaidSubscription,
        completion: @escaping (Swift.Error?) -> Void
    ) {
        retrieveOfferings { [weak self] result in
            switch result {
            case .success(let products):
                let searchedProduct = products.first { $0.storeID == subscription.id }
                guard let searchedProduct = searchedProduct else {
                    completion(Error.noProductFoundWithGivenID)
                    return
                }
                self?.purchase(product: searchedProduct, completion: completion)
            case .failure(let error):
                completion(error)
            }
        }
    }

    public func restore(completion: @escaping (Swift.Error?)->Void) {
        Qonversion.shared().restore { (_, error) in
            completion(error)
        }
    }
    
    public func currentSubscription(
        subscriptionID: String,
        completion: @escaping (Result<PaidSubscription, Swift.Error>
        ) -> Void) {
        retrieveOfferings { result in
            switch result {
            case .success(let products):
                let searchedProduct = products.filter { $0.qonversionID == subscriptionID }.first
                guard let searchedProduct = searchedProduct, let currency = searchedProduct.skProduct?.prettyCurrency,
                        let price = searchedProduct.skProduct?.price else {
                    completion(.failure(Error.noProductFoundWithGivenID))
                    return
                }
                completion(.success(PaidSubscription(id: searchedProduct.storeID, currency: currency, price: price, type: .lifetime)))
            case .failure(let error):
                completion(.failure((error)))
            }
        }
    }

    // Helpers
    private func retrieveOfferings(completion: @escaping (Result<[Qonversion.Product], Swift.Error>) -> Void) {
        Qonversion.shared().offerings { (offerings, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let products = offerings?.main?.products else {
                completion(.failure(Error.noAvailableSubscriptions))
                return
            }
            completion(.success(products))
        }
    }

    private func purchase(
        product: Qonversion.Product,
        completion: @escaping (Swift.Error?) -> Void
    ) {
        Qonversion.shared().purchaseProduct(product) { (_, error, isCancelled) in
            completion(error)
        }
    }

}

fileprivate extension Array where Element == Qonversion.Product {

    func toSubscriptions() -> [PaidSubscription] {
        let temp = self.filter { $0.skProduct != nil }
        return temp.map { PaidSubscription(
            id: $0.storeID,
            currency: $0.skProduct!.prettyCurrency,
            price: $0.skProduct!.price,
            type: SubscriptionType(product: $0) ?? .noneType
        )
        }
    }
}


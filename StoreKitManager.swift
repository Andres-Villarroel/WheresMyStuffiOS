import Foundation
import StoreKit
import os

class StoreKitManager: ObservableObject{
    let log = Logger(subsystem: "WheresMyStuff", category: "StoreKit")
    
    private var productID = ["com.andresvillarroel.FlashFind.fullVersion"]
    @Published var storeProducts = [Product]()
//    @Published var purchasedProducts = [Product]()
    @Published var purchasedProducts = Set<Product>()   //using set instead of an array so that duplicates do not get appended.
    var transactionListener: Task<Void, Error>?
    @Published var entitlements = [Transaction]()   //used to handle refunds
    
    init(){
        log.info("StoreKitManager init triggered")
        transactionListener = listenForTransactions()
        
        Task{
            await requestProducts()
            //must be called after the products are already fetched
            await updateCurrentEntitlements()
        }
        log.info("StoreKitManager init finished")
    }
    
    @MainActor
    func requestProducts() async {
        log.info("requestProducts() triggered")
        do {
            storeProducts = try await Product.products(for: productID)
        } catch {
            log.error("Error requesting products. Error: \(error)")
        }
    }
    
    @MainActor
    func purchase(_ product: Product) async throws -> Transaction? {
        log.info("purchase(product) triggered.")
        log.info("Is purchasedItems array empty before purchase: \(self.purchasedProducts.isEmpty)")
        let result = try await product.purchase()
        
        switch result {
            //        case .success(let verificationResult):
            case .success(.verified(let transaction)):
            log.info("PURHCASE STATUS: Verified purhcase confirmed.")
                purchasedProducts.insert(product)
                await transaction.finish()
                return transaction
            case .userCancelled:
            log.info("PURCHASE STATUS: User cancelled purchase.")
                return nil
            case .pending:
                return nil
            default:
                return nil
        }
        
    }
    
    @MainActor
    func didPurchaseFullVersion() -> Bool {
        return !purchasedProducts.isEmpty
    }
    
    //errors can occur after the purchase was successfully made, the transaction might be missed. This will solve that problem by listening to transaction updates provided by StoreKit in real time.
    func listenForTransactions() -> Task < Void, Error > {
        log.info("listenForTransactions() triggered.")
        return Task.detached {
            for await result in Transaction.updates {
                await self.handle(transactionVerification: result)
            }
        }
    }
    
    @MainActor
    private func handle(transactionVerification result: VerificationResult<Transaction> ) async {
        log.info("handle() triggered.")
        switch result {
        case let.verified(transaction):
            guard let product = self.storeProducts.first(where: {
                $0.id == transaction.productID
            })
            else {
                return
            }
            self.purchasedProducts.insert(product)
            await transaction.finish()
        default:
            return
        }
    }
    
    private func updateCurrentEntitlements() async {
        log.info("updateCurrentEntitlements() triggered.")
        for await result in Transaction.currentEntitlements {
            await self.handle(transactionVerification: result)
        }
        log.info("updateCurrentEntitlements() did purchase full version status: \(!self.purchasedProducts.isEmpty)")
    }
    
    @MainActor
    func restore() async throws {
        log.info("restore() triggered.")
        log.info("Restore result detected purchased full version: \(self.purchasedProducts.isEmpty)")
        try await AppStore.sync()
    }
}

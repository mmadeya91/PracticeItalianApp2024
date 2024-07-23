//
//  InAppPurchaseModel.swift
//  PracticeItalianApp
//
//  Created by Matthew Madeya on 6/19/24.
//

import Foundation
import SwiftUI
import RevenueCat
class InAppPurchaseModel: ObservableObject {
    
    @Published var products = [InAppProduct]()
    @Published var userPurchasedPackage1 = false
    
    init() {
        self.products = TestData()
        
        var array = Set<String>()
        Purchases.shared.getCustomerInfo { (customerInfo, error) in
            
            
            array = customerInfo?.allPurchasedProductIdentifiers ?? Set(["default"])
            
            if array.contains("storyAudioPack1") {
                self.userPurchasedPackage1 = true
            }
            
            
            
        }
    }
    
    
    
    
    
    func makePurchase(product: InAppProduct){
        PurchaseService.purchase(productId: product.productId) {
            if product.productId != nil {
                if product.productId == "storyAudioPack1" {
                    self.userPurchasedPackage1  = true
                }
            }
        }
    }
}

struct InAppProduct{
    var productName: String
    var productId: String?
}

func TestData() -> [InAppProduct] {
    
    var array = [InAppProduct]()
    
    var p1 = InAppProduct(productName: "StoryAudioPack1", productId: "storyAudioPack1")
    
    array.append(p1)
    
    return array
    
    
    
}






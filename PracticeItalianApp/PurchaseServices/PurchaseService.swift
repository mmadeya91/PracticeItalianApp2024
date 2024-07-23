//
//  PurchaseService.swift
//  PracticeItalianApp
//
//  Created by Matthew Madeya on 6/19/24.
//

import Foundation
import SwiftUI
import RevenueCat

class PurchaseService {


    
    static func purchase(productId: String?, successfulPurchase:@escaping () -> Void) {
        guard productId != nil else{
            return
        }

      
        Purchases.shared.getProducts([productId!]) { (products) in
            
            if !products.isEmpty {
                

                
                Purchases.shared.purchase(product: products[0]){ (transaction, purchaserInfo, error, userCancelled) in
                    
                    if error == nil && !userCancelled {
                       
                        successfulPurchase()
                        
                    }
                    
                    
                }
                
                
            }
            
            
            
            
            
        }
    }
}

import Combine

final class CartService {
  @Published private var products: [String: Int] = [:]
  
  private var subscriptions = Set<AnyCancellable>()
  
  init() {
    Bus.receiveSync(&subscriptions, [K.addToCart]) { [weak self] (key: String, product: String) in
      self?.addProduct(product)
    }
    
    Bus.receiveSync(&subscriptions, [K.removeFromCart]) { [weak self] (key: String, product: String) in
      self?.removeProduct(product)
    }
    
    Bus.receiveSync(&subscriptions, [K.clearCart]) { [weak self] (key: String, product: String) in
      self?.clearCart()
    }
  }
  
  // +1
  private func addProduct(_ product: String) {
    if let count = products[product] {
      products[product] = count + 1
    } else {
      products[product] = 1
    }
    setupProducts()
  }
  
  // -1
  private func removeProduct(_ product: String) {
    if let count = products[product], count > 1 {
      products[product] = count - 1
    } else {
      products[product] = nil
    }
    setupProducts()
  }
  
  // clear cart
  private func clearCart() {
    products.removeAll()
    setupProducts()
  }
  
  private func setupProducts() {
    let productList = products.map { "\($0.key) | Quantity: \($0.value)" }
    Bus.send(K.cartList, productList)
  }
}

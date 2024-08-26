import Combine

final class ProductsService {
  @Published private var products: [String: Int] = [:]
  
  private var subscriptions = Set<AnyCancellable>()
  
  init() {
    Bus.receiveSync(&subscriptions, [K.initialProducts]) { [weak self] (_, v: [String: Int]) in
      self?.products = v
    }
    
    Bus.sendSync(&subscriptions, K.products, $products.eraseToAnyPublisher())
    
    Bus.receiveSync(&subscriptions, [K.addToCart]) { [weak self] (_, product: String) in
      self?.addToCart(product: product)
    }
    
    Bus.receiveSync(&subscriptions, [K.removeFromCart]) { [weak self] (_, product: String) in
      self?.removeFromCart(product: product)
    }
    
    Bus.receiveSync(&subscriptions, [K.clearCart]) { [weak self] (key: String, product: String) in
      self?.clearAllProducts()
    }
  }
  
  func addToCart(product: String) {
    products[product, default: 0] += 1
  }
  
  func removeFromCart(product: String) {
    if let count = products[product], count > 0 {
      products[product] = count - 1
    }
  }
  
  func clearAllProducts() {
      for key in products.keys {
        products[key] = 0
      }
    }
}

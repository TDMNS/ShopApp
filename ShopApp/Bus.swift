import Combine
import Foundation

public enum Bus {
  private static let eventPublisher = PassthroughSubject<(key: String, value: Any), Never>()
  
  public static var events: AnyPublisher<(key: String, value: Any), Never> { eventPublisher.eraseToAnyPublisher() }
}

extension Bus {
  static func receiveAsync<T>(
    _ subscriptions: inout Set<AnyCancellable>,
    _ keys: Set<String>,
    _ handler: @escaping ((String, T) -> Void)
  ) {
    eventPublisher
      .compactMap { convertKeyValue(keys, $0) }
      .receive(on: DispatchQueue.main)
      .sink { v in handler(v.0, v.1) }
      .store(in: &subscriptions)
  }
  
  static func receiveSync<T>(
    _ subscriptions: inout Set<AnyCancellable>,
    _ keys: Set<String>,
    _ handler: @escaping ((String, T) -> Void)
  ) {
    eventPublisher
      .compactMap { convertKeyValue(keys, $0) }
      .sink { v in handler(v.0, v.1) }
      .store(in: &subscriptions)
  }
  
  static func receiveSync<T>(
    _ subscriptions: inout Set<AnyCancellable>,
    _ keyFun: @escaping () -> String,
    _ handler: @escaping ((String, T) -> Void)
  ) {
    eventPublisher
      .compactMap { convertKeyValue(keyFun(), $0) }
      .sink { v in handler(v.0, v.1) }
      .store(in: &subscriptions)
  }
  
  static func sendSync<T>(
    _ subscriptions: inout Set<AnyCancellable>,
    _ key: String,
    _ node: AnyPublisher<T, Never>
  ) {
    node
      .sink { v in eventPublisher.send((key, v)) }
      .store(in: &subscriptions)
  }
  
  static func sendSync<T>(
    _ subscriptions: inout Set<AnyCancellable>,
    _ keyFun: @escaping () -> String,
    _ node: AnyPublisher<T, Never>
  ) {
    node
      .sink { v in eventPublisher.send((keyFun(), v)) }
      .store(in: &subscriptions)
  }
  
  static func send(_ key: String, _ value: Any) { eventPublisher.send((key, value)) }
}

extension Bus {
  static func deliver(_ key: String, _ dict: [String: Any]) {
    dict.forEach { eventPublisher.send((Bus.keyId(key, $0.key), $0.value)) }
  }
  
  static func convertKeyValue<T>(_ key: String?, _ v: (key: String, value: Any)) -> (String, T)? {
    guard let key,
          key == v.key,
          let value = v.value as? T else { return nil }
    
    return (key, value)
  }
  
  static func convertKeyValue<T>(_ keys: Set<String>, _ v: (key: String, value: Any)) -> (String, T)? {
    guard keys.contains(v.key), let value = v.value as? T else { return nil }
    
    return (v.key, value)
  }
  
  static func keyId(
    _ key: String,
    _ id: String?
  ) -> String {
    if let id {
      return "\(key):\(id)"
    }
    return key
  }
}


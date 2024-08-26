import Foundation
import Combine

public enum BusUI {}

extension BusUI {
  public final class Value<T>: ObservableObject {
    @Published public var v: T
    var subscriptions = Set<AnyCancellable>()

    public init(
      _ key: String,
      _ defaultValue: T
    ) {
      v = defaultValue
      Bus.receiveSync(
        &subscriptions,
        [key],
        { [weak self] (_, v: T) in self?.v = v }
      )
    }
  }
}

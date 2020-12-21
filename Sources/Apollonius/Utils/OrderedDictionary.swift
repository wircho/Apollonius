struct OrderedDictionary<Key: Hashable, Value> {
  var keys: [Key]
  var unorderedDictionary: [Key: Value]
  
  init() {
    keys = []
    unorderedDictionary = [:]
  }
}

extension OrderedDictionary: ExpressibleByDictionaryLiteral {
  init(dictionaryLiteral elements: (Key, Value)...) {
    keys = elements.map{ $0.0 }
    unorderedDictionary = .init(elements){ $1 }
  }
  
  var values: [Value] { return keys.map{ unorderedDictionary[$0]! } }
}

extension OrderedDictionary {
  mutating func unsafelyAppend(key: Key, value: Value) {
    guard !unorderedDictionary.keys.contains(key) else { fatalError("Key exists: \(key)") }
    keys.append(key)
    unorderedDictionary[key] = value
  }
  
  mutating func unsafelyInsert(key: Key, value: Value, at index: Int) {
    guard !unorderedDictionary.keys.contains(key) else { fatalError("Key exists: \(key)") }
    keys.insert(key, at: index)
    unorderedDictionary[key] = value
  }
  
  mutating func unsafelyRemove(key: Key) -> Int {
    let index = (keys.firstIndex {  $0 == key })!
    keys.remove(at: index)
    unorderedDictionary[key] = nil
    return index
  }
  
  subscript(_ key: Key) -> Value? {
    get { return unorderedDictionary[key] }
    set {
      guard let newValue = newValue else {
        keys.removeAll{ $0 == key }
        unorderedDictionary[key] = nil
        return
      }
      unsafelyAppend(key: key, value: newValue)
    }
  }
}

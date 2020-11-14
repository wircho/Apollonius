struct SortedDictionary<Key: Hashable, Value> {
  var keys: [Key]
  var unsortedDictionary: [Key: Value]
  
  init() {
    keys = []
    unsortedDictionary = [:]
  }
}

extension SortedDictionary: ExpressibleByDictionaryLiteral {
  init(dictionaryLiteral elements: (Key, Value)...) {
    keys = elements.map{ $0.0 }
    unsortedDictionary = .init(elements){ $1 }
  }
}

extension SortedDictionary {
  mutating func unsafelyAppend(key: Key, value: Value) {
    guard !unsortedDictionary.keys.contains(key) else { fatalError("Key exists: \(key)") }
    keys.append(key)
    unsortedDictionary[key] = value
  }
  
  mutating func unsafelyInsert(key: Key, value: Value, at index: Int) {
    guard !unsortedDictionary.keys.contains(key) else { fatalError("Key exists: \(key)") }
    keys.insert(key, at: index)
    unsortedDictionary[key] = value
  }
  
  mutating func unsafelyRemove(key: Key) -> Int {
    let index = (keys.firstIndex {  $0 == key })!
    keys.remove(at: index)
    unsortedDictionary[key] = nil
    return index
  }
  
  subscript(_ key: Key) -> Value? {
    get { return unsortedDictionary[key] }
    set {
      guard let newValue = newValue else {
        keys.removeAll{ $0 == key }
        unsortedDictionary[key] = nil
        return
      }
      unsafelyAppend(key: key, value: newValue)
    }
  }
}

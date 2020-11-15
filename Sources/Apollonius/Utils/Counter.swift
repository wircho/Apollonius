struct Counter {
  
  var _index = 0
  
  mutating func newIndex() -> Int {
    let index = _index
    _index += 1
    return index
  }
  
}

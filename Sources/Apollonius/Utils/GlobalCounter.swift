enum GlobalCounter {
  
  static var _index = 0
  
  static var index: Int {
    let index = _index
    _index += 1
    return index
  }
  
}

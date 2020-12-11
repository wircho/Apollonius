struct Unowned<Wrapped: AnyObject> {
  weak var _object: Wrapped?
  var object: Wrapped { return _object! }
  let identifier: ObjectIdentifier
  
  
  init(_ object: Wrapped) {
    self._object = object
    self.identifier = ObjectIdentifier(object)
  }
}

typealias AnyUnowned = Unowned<AnyObject>

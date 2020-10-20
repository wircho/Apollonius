struct Unowned<Wrapped: AnyObject> {
    weak var _object: Wrapped?
    var object: Wrapped { return _object! }
    init(_ object: Wrapped) { self._object = object }
}

struct Weak<Wrapped: AnyObject> {
    weak var object: Wrapped?
    init(_ object: Wrapped) { self.object = object }
}

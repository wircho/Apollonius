extension Canvas {
  internal func willDo(silently: Bool = false) -> Bool {
    guard silently || (undoManager?.isUndoRegistrationEnabled ?? true) else { return false }
    willChangeHandler?()
    return true
  }
  
  private func registerUndo(_ handler: @escaping (Canvas) -> Void) {
    undoManager?.beginUndoGrouping()
    undoManager?.registerUndo(withTarget: self, handler: handler)
    undoManager?.endUndoGrouping()
  }
  
  func add(_ item: Item, for key: ObjectIdentifier) {
    guard willDo() else { return }
    
    items.unsafelyAppend(key: key, value: item)
    item.update()
    
    registerUndo { canvas in
      _ = canvas.remove(only: key)
    }
  }
  
  func add(_ item: Item, for key: ObjectIdentifier, at index: Int) {
    guard willDo() else { return }
    
    items.unsafelyInsert(key: key, value: item, at: index)
    item.update()
    
    registerUndo { canvas in
      _ = canvas.remove(only: key)
    }
  }
  
  func add(_ handle: PointHandle, for key: ObjectIdentifier? = nil) {
    guard willDo() else { return }
    
    let key = key ?? handle.point.shape.key
    pointHandles[key] = handle
    
    registerUndo { canvas in
      _ = canvas.remove(handleFor: key)
    }
  }
  
  func remove(only key: ObjectIdentifier, silently: Bool = false) -> Item? {
    guard willDo(silently: silently) else { return nil }
    
    guard let item = items[key] else { return nil }
    let index = items.unsafelyRemove(key: key)
    
    guard !silently else { return item }
    
    registerUndo { canvas in
      canvas.add(item, for: key, at: index)
    }
    
    return item
  }
  
  func remove(handleFor key: ObjectIdentifier) -> PointHandle? {
    guard willDo() else { return nil }
    
    guard let handle = pointHandles[key] else { return nil }
    pointHandles[key] = nil
    
    registerUndo { canvas in
      canvas.add(handle, for: key)
    }
    
    return handle
  }
  
  func remove(from key: ObjectIdentifier) -> [Item] {
    guard willDo() else { return [] }
    
    let keysToDelete = gatherKeys(from: key)
    undoManager?.beginUndoGrouping()
    var deletedItems: [Item] = []
    for key in keysToDelete {
      guard let item = items[key] else { continue }
      let handle = pointHandles[key]
      deletedItems.append(item)
      let index = items.unsafelyRemove(key: key)
      pointHandles[key] = nil
      
      registerUndo { canvas in
        canvas.add(item, for: key, at: index)
        guard let handle = handle else { return }
        canvas.add(handle, for: key)
      }
    }
    undoManager?.endUndoGrouping()
    return deletedItems
  }
}

extension Canvas {
  func add(fragileIntersection: Intersection) {
    add(fragileIntersection)
    let key = fragileIntersection.shape.key
    fragileIntersection.shape.onNoChildren = {
      [weak self] in
      _ = self?.remove(only: key, silently: true)
    }
  }
  
  func add<Figure: FigureProtocol>(_ figure: Figure) {
    let key = figure.shape.key
    let item = Item(figure)!
    add(item, for: key)
  }
}

public extension Canvas {
  func remove(_ handle: PointHandle) {
    remove(handle.point)
  }
  
  func remove(_ point: Point) {
    _ = remove(from: point.shape.key)
  }
  
  func remove(_ circular: Circular) {
    _ = remove(from: circular.shape.key)
  }
  
  func remove(_ scalar: Scalar) {
    _ = remove(from: scalar.shape.key)
  }
  
  func remove(_ straight: Straight) {
    _ = remove(from: straight.shape.key)
  }
  
  func handle(for point: Point) -> PointHandle? {
    return pointHandles[point.shape.key]
  }
}

extension Canvas {
  private func registerUndo(_ handler: @escaping (Canvas) -> Void) {
    if #available(OSX 10.11, iOS 9.0, *) {
      undoManager.beginUndoGrouping()
      undoManager.registerUndo(withTarget: self, handler: handler)
      undoManager.endUndoGrouping()
    }
  }
  
  func add(_ item: Item, for key: ObjectIdentifier) {
    guard undoManager.isUndoRegistrationEnabled else { return }
    
    items.unsafelyAppend(key: key, value: item)
    item.update()
    
    registerUndo { canvas in
      _ = canvas.remove(only: key)
    }
  }
  
  func add(_ item: Item, for key: ObjectIdentifier, at index: Int) {
    guard undoManager.isUndoRegistrationEnabled else { return }
    
    items.unsafelyInsert(key: key, value: item, at: index)
    item.update()
    
    registerUndo { canvas in
      _ = canvas.remove(only: key)
    }
  }
  
  func add(_ handle: PointHandle, for key: ObjectIdentifier? = nil) {
    guard undoManager.isUndoRegistrationEnabled else { return }
    
    let key = key ?? handle.point.shape.key
    pointHandles[key] = handle
    
    registerUndo { canvas in
      _ = canvas.remove(handleFor: key)
    }
  }
  
  func remove(only key: ObjectIdentifier, silently: Bool = false) -> Item? {
    guard silently || undoManager.isUndoRegistrationEnabled else { return nil }
    
    guard let item = items[key] else { return nil }
    let index = items.unsafelyRemove(key: key)
    
    guard !silently else { return item }
    
    registerUndo { canvas in
      canvas.add(item, for: key, at: index)
    }
    
    return item
  }
  
  func remove(handleFor key: ObjectIdentifier) -> PointHandle? {
    guard undoManager.isUndoRegistrationEnabled else { return nil }
    
    guard let handle = pointHandles[key] else { return nil }
    pointHandles[key] = nil
    
    registerUndo { canvas in
      canvas.add(handle, for: key)
    }
    
    return handle
  }
  
  func remove(from key: ObjectIdentifier) -> [Item] {
    guard undoManager.isUndoRegistrationEnabled else { return [] }
    
    let keysToDelete = gatherKeys(from: key)
    undoManager.beginUndoGrouping()
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
    undoManager.endUndoGrouping()
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
    _ = remove(handleFor: handle.point.shape.key)
  }
  
  func remove<F: FigureProtocol>(_ figure: F) {
    _ = remove(from: figure.shape.key)
  }
}

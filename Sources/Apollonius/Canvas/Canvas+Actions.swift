extension Canvas {
  func add<Figure: FigureProtocol>(_ figure: Figure) {
    figure.shape.update()
    let key = figure.shape.key
    let item = Item(figure)!
    undoContext.perform(
      execute: { [unowned self] in
        self.items.unsafelyAppend(key: key, value: item)
      },
      revert: { [unowned self] in
        self.items[key] = nil
      }
    )
  }
  
  func add(_ handle: PointHandle) {
    let key = handle.point.shape.key
    undoContext.perform(
      execute: { [unowned self] in
        self.pointHandles[key] = handle
      },
      revert: { [unowned self] in
      self.pointHandles[key] = nil
      }
    )
  }
  
  func remove(_ key: ShapeKey) -> [Item] {
    let keysToDelete = gatherKeys(from: key, includeUpstreamIntersections: true)
    undoContext.begingGrouping()
    var deletedItems: [Item] = []
    for key in keysToDelete {
      let item = items[key]!
      let handle = pointHandles[key]
      deletedItems.append(item)
      var index = -1
      undoContext.perform(
        execute: { [unowned self] in
          index = self.items.unsafelyRemove(key: key)
          self.pointHandles[key] = nil
        },
        revert: { [unowned self] in
          self.items.unsafelyInsert(key: key, value: item, at: index)
          self.pointHandles[key] = handle
        }
      )
    }
    undoContext.endGrouping()
    return deletedItems
  }
}

public extension Canvas {
  func remove(_ handle: PointHandle) {
    _ = remove(handle.point.shape.key)
  }
  
  func remove<F: FigureProtocol>(_ figure: F) {
    _ = remove(figure.shape.key)
  }
}

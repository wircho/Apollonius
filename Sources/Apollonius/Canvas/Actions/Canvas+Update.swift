extension Canvas {
  func update() {
    for key in items.keys {
      items[key]?.update()
    }
  }
  
  func update(keys: Set<ObjectIdentifier>) {
    for key in items.keys {
      guard keys.contains(key) else { continue }
      items[key]?.update()
    }
  }
  
  func update(from key: ObjectIdentifier) {
    update(keys: gatherKeys(from: key))
  }
}

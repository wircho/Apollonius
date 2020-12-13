# Apollonius - A Swift Euclidean Geometry Package

Apollonius is a simple Euclidean geometry library for Swift that allows you to define figures on a 2D plane and computes for you things like circle radii and intersection point coordinates.

## Usage

With Apollonius you **can** initialize a `Canvas` object, representing a 2D coordinate system, and create figures such as points, lines, and circles that live on this `Canvas` instance. Each new geometric figure may depend on previous figures. For example:

```swift
let canvas = Canvas()
let firstPoint = canvas.point(at: 0, 0)
let secondPoint = canvas.point(at: 3, 4)
let circle = canvas.circle(centeredAt: firstPoint, through: secondPoint)
let line = canvas.line(firstPoint, secondPoint)
print(circle.radius!) // 5.0
print(line.slopeAngle!) // 0.9272952180016122
```

### What Can You **Not** Do With This Package?

With Apollonius alone you **cannot** draw or visually with interact the figures you create. A package that will allow you to do this, ApolloniusUI, is on its way. Feel free to create your own package as well.

## Advanced Functionality

### Moving Points (Point Handles)

You can use `canvas.freePoint(at: x, y)` to create a `Canvas.PointHandle` instance which you can then move using `handle.move(to: x, y)`. Similarly, you can create moving points constrained to circles or lines, using `canvas.pointHandle(on: otherFigure, near: x, y)`


When a free or constrained point moves, the figures that depend on it move as well. For eample:

```swift
let canvas = Canvas()
let center = canvas.point(at: 0, 0)
let handle = canvas.pointHandle(at: 3, 4)
let circle = canvas.circle(centeredAt: center, through: handle.point)
print(circle.radius!) // 5.0
handle.move(to: 5, 12)
print(circle.radius!) // 13.0
```

### Undo/Redo

Each `Canvas` instance has a built in `UndoManager`. the following properties and methods of `Canvas` are forwarded to and from it:

```swift
func undo()
func redo()
var canUndo: Bool { get }
var canRedo: Bool { get }
var groupsUndosByEvent: Bool { get set }
var levelsOfUndo: Int { get set }
```

### Moving Points Smoothly

When a free or constrained point needs to move many times in a short period of time, for example if you are using values from a `Canvas` instance to regularly draw and animate complex constructions, you may benefit from making sure your successive calls to `handle.move(to: x, y)` are preceded and succeeded respectively by calles to `handle.beginSmoothMove()` and `handle.endSmoothMove()`. For example:

```swift
// Free point moving SMOOTHLY to (5, 12) in 8000 steps
let canvas = Canvas()
let center = canvas.point(at: 0, 0)
let handle = canvas.pointHandle(at: 3, 4)
let circle = canvas.circle(centeredAt: center, through: handle.point)
print("circle.radius = \(circle.radius!)")
handle.beginSmoothMove()
let startTime = CFAbsoluteTimeGetCurrent()
for i in 1 ... 1000 {
  handle.move(to: 3 + Double(i) / 500, 4 + Double(i) / 125)
}
let endTime = CFAbsoluteTimeGetCurrent()
handle.endSmoothMove()
print("circle.radius became \(circle.radius!) in \(endTime - startTime) seconds")
// circle.radius = 5.0
// circle.radius became 13.0 in 0.009337067604064941 seconds
```

This approach precomputes some parameters that would otherwise be computed on every call to `handle.move(to: x, y)`, such as the set of all dependent figures to be updated on each call.

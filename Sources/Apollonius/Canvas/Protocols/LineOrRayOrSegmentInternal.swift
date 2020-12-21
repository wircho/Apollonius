protocol LineOrRayOrSegmentInternal: LineOrRayOrSegment, FigureProtocolInternal where S == Geometry.Straight<T> {
  static var kind: Geometry.StraightKind { get }
}

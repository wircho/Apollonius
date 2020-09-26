public typealias RayPointToPoint<T, P0: Point, P1: Point>
    = StraightPointToPoint<T, RayPhantom, P0, P1> where P0.T == T, P1.T == T

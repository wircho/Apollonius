extension StraightPointToPoint: FigureWithRelationships {
    public func applyRelationships() {
        // Parenting
        point0.asWeakFigure.append(child: .init(self))
        point1.asWeakFigure.append(child: .init(self))
        // Known points/curves
        self.knownPoints.append(contentsOf: [point0, point1])
        point0.append(knownCurve: .init(self))
        point1.append(knownCurve: .init(self))
    }
}

extension StraightAndCircularIntersection: FigureWithRelationships {
    public func applyRelationships() {
        // Parenting
        straight.object?.children.append(.init(self))
        circular.object?.children.append(.init(self))
        // Known points/curves
        self.knownCurves.append(contentsOf: [.init(straight), .init(circular)])
        straight.object?.knownPoints.append(.init(self))
        circular.object?.knownPoints.append(.init(self))
    }
}

extension CircleCenterAndArm: FigureWithRelationships {
    public func applyRelationships() {
        // Parenting
        center.asWeakFigure.append(child: .init(self))
        arm.asWeakFigure.append(child: .init(self))
        // Known points/curves
        self.knownPoints.append(arm)
        arm.append(knownCurve: .init(self))
    }
}

extension DirectedLine: FigureWithRelationships {
    public func applyRelationships() {
        // Parenting
        point.object?.children.append(.init(self))
        straight.object?.children.append(.init(self))
        // Known points/curves
        self.knownPoints.append(.init(point))
        point.object?.knownCurves.append(.init(self))
    }
}

extension FreePoint: FigureWithRelationships {
    public func applyRelationships() {}
}

extension Midpoint: FigureWithRelationships {
    public func applyRelationships() {
        // Parenting
        point0.asWeakFigure.append(child: .init(self))
        point1.asWeakFigure.append(child: .init(self))
    }
}

extension PerpendicularBisector: FigureWithRelationships {
    public func applyRelationships() {
        // Parenting
        point0.object?.children.append(.init(self))
        point1.object?.children.append(.init(self))
    }
}

extension StraightsIntersection: FigureWithRelationships {
    public func applyRelationships() {
        // Parenting
        straight0.object?.children.append(.init(self))
        straight1.object?.children.append(.init(self))
        // Known points/curves
        self.knownCurves.append(contentsOf: [.init(straight0), .init(straight1)])
        straight0.object?.knownPoints.append(.init(self))
        straight1.object?.knownPoints.append(.init(self))
    }
}

extension PointOnCircular: FigureWithRelationships {
    public func applyRelationships() {
        // Parenting
        circular.object?.children.append(.init(self))
        // Known points/curves
        self.knownCurves.append(.init(circular))
        circular.object?.knownPoints.append(.init(self))
    }
}

extension PointOnSegment: FigureWithRelationships {
    public func applyRelationships() {
        // Parenting
        segment.object?.children.append(.init(self))
        // Known points/curves
        self.knownCurves.append(.init(segment))
        segment.object?.knownPoints.append(.init(self))
    }
}

extension PointOnRay: FigureWithRelationships {
    public func applyRelationships() {
        // Parenting
        ray.object?.children.append(.init(self))
        // Known points/curves
        self.knownCurves.append(.init(ray))
        ray.object?.knownPoints.append(.init(self))
    }
}

extension PointOnLine: FigureWithRelationships {
    public func applyRelationships() {
        // Parenting
        line.object?.children.append(.init(self))
        // Known points/curves
        self.knownCurves.append(.init(line))
        line.object?.knownPoints.append(.init(self))
    }
}

extension SegmentLength: FigureWithRelationships {
    public func applyRelationships() {
        // Parenting
        segment.asWeakFigure.append(child: .init(self))
    }
}

extension TwoPointsDistance: FigureWithRelationships {
    public func applyRelationships() {
        // Parenting
        point0.object?.children.append(.init(self))
        point1.object?.children.append(.init(self))
    }
}

extension CircleCenterAndRadius: FigureWithRelationships {
    public func applyRelationships() {
        // Parenting
        center.object?.children.append(.init(self))
        radius.object?.children.append(.init(self))
    }
}

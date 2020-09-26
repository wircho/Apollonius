public protocol Line: Straight where Phantom == LinePhantom {}

public enum LinePhantom: StraightPhantom {}

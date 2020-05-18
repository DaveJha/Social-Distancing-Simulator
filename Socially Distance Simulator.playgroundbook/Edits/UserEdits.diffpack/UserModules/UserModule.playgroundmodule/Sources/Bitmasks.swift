// Used to detect collisions
public struct Bitmasks {
    static let player: UInt32 = 1 << 1 
    static let infected: UInt32 = 1 << 2
    static let uninfectedPerson: UInt32 = 1 << 3
    static let cannotInteract: UInt32 = 1 << 4
}

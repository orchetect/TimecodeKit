/// ----------------------------------------------
/// ----------------------------------------------
/// OTCore/Protocols/Protocols.swift
///
/// Borrowed from OTCore 1.4.2 under MIT license.
/// https://github.com/orchetect/OTCore
/// Methods herein are unit tested at their source
/// so no unit tests are necessary.
/// ----------------------------------------------
/// ----------------------------------------------

// MARK: - FloatingPointPowerComputable

/// Protocol allowing implementation of convenience method `.power(_ exponent:)`
/// - warning: (Internal use. Do not use this protocol.)
protocol FloatingPointPowerComputable {
    func power(_ exponent: Self) -> Self
}

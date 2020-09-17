//
//  File.swift
//  SwiftTimecode
//
//  Created by Steffan Andrews on 2020-09-17.
//

import Foundation

extension CharacterSet {
	
	/// CUSTOM SHARED:
	/// Returns true if the CharacterSet contains the given Character.
	internal func contains(_ character: Character) -> Bool {
		
		return character
			.unicodeScalars
			.allSatisfy(contains(_:))
		
	}
	
}

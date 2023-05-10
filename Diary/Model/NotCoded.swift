//
//  NotCoded.swift
//  Diary
//
//  Created by Rowan, Harry on 2023/05/10.
//

import Foundation

@propertyWrapper
struct NotCodedID {
  private var value: UUID
    
  init(wrappedValue: UUID) {
    self.value = wrappedValue
  }
    
  var wrappedValue: UUID {
    get { value }
    set { self.value = newValue }
  }
}

extension NotCodedID: Decodable {
    init(from decoder: Decoder) throws {
    // The wrapped value is simply initialised to nil when decoded.
    self.value = UUID()
  }
}

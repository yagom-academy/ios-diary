//
//  NetworkError.swift
//  Diary
//
//  Created by Minseong, Lingo on 2022/07/01.
//

enum NetworkError: Error {
  case invalidateEndpoint
  case invalidateRequest
  case invalidateResponse
  case internalServerError
}

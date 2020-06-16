//
//  JSONLoader.swift
//  Caroling Companion
//
//  Created by Chase McElroy on 6/15/20.
//  Copyright © 2020 Chase McElroy. All rights reserved.
//

import Foundation

// Created Error Enumn to capture errors encountered while fetching JSON
//enum JSONError: Error {
//    case locateFailed, loadFailed, decodeFailed
//}
//
//func fetchMockJSON(fromFile fileName: String, completion: @escaping (Result<[Event], JSONError>) -> ()) {
//    guard let url = Bundle.main.url(forResource: fileName, withExtension: nil) else {
//        completion(.failure(.locateFailed))
//        return
//    }
//
//    guard let data = try? Data(contentsOf: url) else {
//        completion(.failure(.loadFailed))
//        return
//    }
//    let decoder = JSONDecoder()
//
//    guard let loaded = try? decoder.decode([Event].self, from: data) else {
//        completion(.failure(.decodeFailed))
//        return
//    }
//    completion(.success(loaded))
//}

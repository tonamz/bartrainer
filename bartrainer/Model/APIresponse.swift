//
//  APIresponse.swift
//  bartrainer
//
//  Created by Methira Denthongchai on 18/2/2562 BE.
//  Copyright © 2562 Methira Denthongchai. All rights reserved.
//
import Foundation

public struct APIresponse: Codable {
    
    public var code: Int?
    public var type: String?
    public var message: String?
    public var error: String?
    
    public init(code: Int?, type: String?, message: String?,error: String?) {
        self.code = code
        self.type = type
        self.message = message
        self.error = error
        
    }
    
    
}

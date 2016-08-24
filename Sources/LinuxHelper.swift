//
//  LinuxHelper.swift
//  Thrift
//
//  Created by Christopher Simpson on 8/22/16.
//
//

import Foundation
import CoreFoundation

#if os(Linux)
/// Extensions for Linux for incomplete Foundation API's.
/// swift-corelibs-foundation is not yet 1:1 with OSX/iOS Foundation

public typealias OutputStream = NSOutputStream
public typealias HTTPURLResponse = NSHTTPURLResponse

extension URLSession {
  public static let shared = URLSession.sharedSession()

  @discardableResult
  open func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
    return dataTaskWithRequest(request, completionHandler: completionHandler)
  }
}
extension URLSessionConfiguration {  
  public var httpShouldUsePipelining: Bool {
    get {
      return self.HTTPShouldUsePipelining
    }
    set {
      self.HTTPShouldUsePipelining = newValue
    }
  }
  
  public var httpShouldSetCookies: Bool {
    get {
      return self.HTTPShouldSetCookies
    }
    set {
      self.HTTPShouldSetCookies = newValue
    }
  }
  
  public var httpAdditionalHeaders: [AnyHashable: Any]? {
    get {
      return self.HTTPAdditionalHeaders
    }
    set {
      var new: [NSObject: AnyObject] = [:]
      newValue?.forEach {
        new[NSString(string: $0 as! String)] = NSString(string: $1 as! String)
      }
      if new.keys.count > 0 {
        self.HTTPAdditionalHeaders = new
      }
    }
  }
}


extension CFSocketError {
  public static let success = kCFSocketSuccess
}
  
extension UInt {
  public func &(lhs: UInt, rhs: Int) -> UInt {
    let cast = unsafeBitCast(rhs, to: UInt.self)
    return lhs & rhs
  }
}

#else
extension CFStreamPropertyKey {
  static let shouldCloseNativeSocket  = CFStreamPropertyKey(kCFStreamPropertyShouldCloseNativeSocket)
  // Exists as Stream.PropertyKey.socketSecuritylevelKey but doesn't work with CFReadStreamSetProperty
  static let socketSecurityLevel      = CFStreamPropertyKey(kCFStreamPropertySocketSecurityLevel)
  static let SSLSettings              = CFStreamPropertyKey(kCFStreamPropertySSLSettings)
}
#endif


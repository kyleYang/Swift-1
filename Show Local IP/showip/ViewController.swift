//
//  ViewController.swift
//  showip
//
//  Created by @dustLane on 01/01/2018.
//  Copyright © 2018 @dustLane. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

  @IBOutlet weak var showIPLabel: UILabel?
  
    override func viewDidLoad() {
        super.viewDidLoad()
        showIPLabel?.text = getIFAddresses()[0]
        print(getIFAddresses())
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func getIFAddresses() -> [String] {
        var addresses = [String]()
        
        // Get list of all interfaces on the local machine:
        var ifaddr : UnsafeMutablePointer<ifaddrs>? = nil
        if getifaddrs(&ifaddr) == 0 {
          
          var ptr = ifaddr
          while ptr != nil {
            let flags = Int32((ptr?.pointee.ifa_flags)!)
            var addr = ptr?.pointee.ifa_addr.pointee
            
            // Check for running IPv4, IPv6 interfaces. Skip the loopback interface.
            if (flags & (IFF_UP|IFF_RUNNING|IFF_LOOPBACK)) == (IFF_UP|IFF_RUNNING) {
              if addr?.sa_family == UInt8(AF_INET) || addr?.sa_family == UInt8(AF_INET6) {
                
                // Convert interface address to a human readable string:
                var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                if (getnameinfo(&addr!, socklen_t((addr?.sa_len)!), &hostname, socklen_t(hostname.count),
                                nil, socklen_t(0), NI_NUMERICHOST) == 0) {
                  if let address = String(validatingUTF8: hostname) {
                    addresses.append(address)
                  }
                }
              }
            }
            ptr = ptr?.pointee.ifa_next
          }

            freeifaddrs(ifaddr)
        }
        print("Local IP \(addresses)")
        return addresses
    }

}

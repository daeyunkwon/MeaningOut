//
//  NetworkManager.swift
//  MeaningOut
//
//  Created by 권대윤 on 6/16/24.
//

import Foundation
import Network

final class NetworkCheckManager {
    static let shared = NetworkCheckManager()
    private let queue = DispatchQueue.global()
    private let monitor: NWPathMonitor
    private(set) var isConnected: Bool = false
    private(set) var connectionType: ConnectionType = .unknown
    
    //연결 타입
    enum ConnectionType{
        case wifi
        case cellular
        case ethernet
        case unknown
    }
    
    private init(){
        monitor = NWPathMonitor()
    }
    
    // Network Monitoring 시작
    func startMonitoring() {
        monitor.start(queue: queue)
        monitor.pathUpdateHandler = {[weak self] path in
            self?.isConnected = path.status == .satisfied
            //self?.getConnectionType(path)
            
            if self?.isConnected == true {
                //print("네트워크연결됨")
            } else {
                //print("네트워크 연결 오류")
            }
        }
    }
    
    // Network Monitoring 종료
    func stopMonitoring() {
        monitor.cancel()
    }
    
    // Network 연결 타입가져오기.
    private func getConnectionType(_ path: NWPath){
        if path.usesInterfaceType(.wifi){
            connectionType = .wifi
        } else if path.usesInterfaceType(.cellular){
            connectionType = .cellular
        } else if path.usesInterfaceType(.wiredEthernet){
            connectionType = .ethernet
        } else {
            connectionType = .unknown
        }
    }
}

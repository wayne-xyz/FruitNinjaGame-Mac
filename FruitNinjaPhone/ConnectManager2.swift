//
//  ConnectManager2.swift
//  FruitNinjaPhone
//
//  Created by RongWei Ji on 11/4/23.
//

//this is the version for the python sever connection
// use Socket

import Foundation
protocol ConnectManager2Delegate: AnyObject {
    func websocketDidConnect()
    func websocketDidDisconnect(error: Error?)
    func websocketDidReceiveMessage(text: String)
}


class ConnectManager2 {
    static let shared = ConnectManager2()

    private var webSocketTask: URLSessionWebSocketTask?
    weak var delegate: ConnectManager2Delegate?

    private init() {
        // Private initializer to enforce singleton pattern
    }

    func configure(with url: URL) {
        webSocketTask = URLSession.shared.webSocketTask(with: url)
    }

    func connect() {
        webSocketTask?.resume()
        receive()
        delegate?.websocketDidConnect()
    }

    func disconnect() {
        webSocketTask?.cancel(with: .goingAway, reason: nil)
    }

    func send(message: String) {
        let textMessage = URLSessionWebSocketTask.Message.string(message)
        webSocketTask?.send(textMessage) { error in
            if let error = error {
                print("Failed to send message: \(error)")
            }
        }
    }

    private func receive() {
        webSocketTask?.receive { [weak self] result in
            switch result {
            case .success(let message):
                switch message {
                case .string(let text):
                    self?.delegate?.websocketDidReceiveMessage(text: text)
                default:
                    break
                }
                self?.receive()
            case .failure(let error):
                self?.delegate?.websocketDidDisconnect(error: error)
            }
        }
    }
}

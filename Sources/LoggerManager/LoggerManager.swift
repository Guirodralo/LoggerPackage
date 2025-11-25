//
//  LoggerManager.swift
//
//  Created by Guillermo Rodriguez Alonso on 14/5/25.
//

/// Manager para poder categorizar por categoria y por subsistema un log de la consola.
/// Al final hay ubicados dos enumerados: LoggerCategory y LoggerSubsystem.
/// En principio, LoggerSubsystem sería para saber en que paquete o que
/// funcionalidad estamos (por eso los dos inicializadores de la funcion sendLog)
/// A su vez, LoggerCategory sería para el tipo de log que es, ya sea a nivel UI,
/// de tipo response o de tipo request (sed libres de crear más cases)
///
///
///     LoggerManager.shared.sendLog(
///                 category: .ui,
///                 subsystem: .UIComponents,
///                 message: "Botón de aceptado pulsado"
///                 )
///     Esto crea un log en la consola donde luego podemos filtrar por la categoria y el subsistema
///     que hemos puesto. No nos va a aparecer la categoria o el subsistema hasta que se envie un log
///     de ese tipo.

import Foundation
import os
import Environment
import CommonUtils

public final class LoggerManager {
    public static let shared = LoggerManager()

    private var loggers: [String: Logger] = [:]
    private let loggerQueue = DispatchQueue(label: "LoggerManager.queue")

    public func sendLog(
        category: LoggerCategory = .byDefault,
        subsystem: LoggerSubsystem? = nil,
        _ message: String
    ) {
        getLogger(category: category.rawValue, subsystem: subsystem).debug("\(message)")
    }

    public func sendLog(
        category: String,
        subsystem: LoggerSubsystem? = nil,
        _ message: String
    ) {
        getLogger(category: category, subsystem: subsystem).debug("\(message)")
    }

    private func getLogger(
        category: String,
        subsystem: LoggerSubsystem? = nil
    ) -> Logger {
        return loggerQueue.sync {
            let subsystemName = subsystem?.rawValue ?? LoggerCategory.byDefault.rawValue
            let key = subsystemName + String.hyphen + category

            if let existing = loggers[key] {
                return existing
            }

            let logger = Logger(subsystem: subsystemName, category: category)
            loggers[key] = logger
            return logger
        }
    }
}

public enum LoggerCategory: String {
    case byDefault = "Default"
    case request = "Request"
    case database = "database"
    case uiInteraction = "UI"
    case response = "Response"
    case responseError = "ResponseError"
}

public enum LoggerSubsystem: String {
    case environment = "Environment"
    case commonUtils = "CommonUtils"
    case uiComponents = "UIComponents"
    case persistence = "Persistence"
    case network = "Network"
    case appDelegate = "AppDelegate"
    case funcionalities = "Funcionalities"
}

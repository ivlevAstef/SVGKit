//
//  Renderer.Types.swift
//  SwiftDraw
//
//  Created by Simon Whitty on 14/6/17.
//  Copyright 2020 Simon Whitty
//

extension LayerTree {
    
    // Optimize a sequence of commands removing redundant entries
    
    final class CommandOptimizer<T: RendererTypes> {
        
        private var options: OptimizerOptions
        private var state: Stack<State>
        
        init(options: OptimizerOptions = .skipRedundantState) {
            self.options = options
            self.state = Stack(root: State())
        }
        
        func filterStateCommand(for command: RendererCommand<T>) -> RendererCommand<T>? {
            switch command {
            case .setAlpha(let f):
                if state.top.opacity != f {
                    state.top.opacity = f
                } else {
                    return nil
                }
            case .setFill(let color):
                if state.top.fill != color {
                    state.top.fill = color
                } else {
                    return nil
                }
            case .setStroke(let color):
                if state.top.stroke != color {
                    state.top.stroke = color
                } else {
                    return nil
                }
            case .setLineCap(let cap):
                if state.top.lineCap != cap {
                    state.top.lineCap = cap
                } else {
                    return nil
                }
            case .setLineJoin(let join):
                if state.top.lineJoin != join {
                    state.top.lineJoin = join
                } else {
                    return nil
                }
            case .setLine(width: let width):
                if state.top.lineWidth != width {
                    state.top.lineWidth = width
                } else {
                    return nil
                }
            case .setLineMiter(limit: let limit):
                if state.top.lineMiter != limit {
                    state.top.lineMiter = limit
                } else {
                    return nil
                }
            case .setBlend(mode: let mode):
                if state.top.blendMode != mode {
                    state.top.blendMode = mode
                } else {
                    return nil
                }
            case .pushState:
                state.push(state.top)
            case .popState:
                state.pop()
            default:
                break
            }
            
            return command
        }
        
        func optimizeCommands(_ commands: [RendererCommand<T>]) -> [RendererCommand<T>] {
            state = Stack<State>(root: State())
            
            var commands = commands
            
            if options.contains(.skipInitialSaveState),
               let pushIdx = commands.firstIndex(where: \.isPushState),
               let popIdx = commands.firstIndex(where: \.isPopState),
               pushIdx == commands.indices.first,
               popIdx == commands.indices.last {
                commands.remove(at: popIdx)
                commands.remove(at: pushIdx)
            }
            
            if options.contains(.skipRedundantState) {
                state = Stack(root: State())
                commands = commands.compactMap { filterStateCommand(for: $0) }
            }
            
            return commands
        }
        
        struct State {
            var opacity: T.Float?
            var fill: T.Color?
            var stroke: T.Color?
            var lineCap: T.LineCap?
            var lineJoin: T.LineJoin?
            var lineWidth: T.Float?
            var lineMiter: T.Float?
            var blendMode: T.BlendMode?
        }
    }
}

struct OptimizerOptions: OptionSet {

    static let skipRedundantState = OptimizerOptions(rawValue: 1)
    static let skipInitialSaveState = OptimizerOptions(rawValue: 2)
    
    let rawValue: Int
}

extension RendererCommand {
    
    var isPushState: Bool {
        switch self {
        case .pushState:
            return true
        default:
            return false
        }
    }
    
    var isPopState: Bool {
        switch self {
        case .popState:
            return true
        default:
            return false
        }
    }
}

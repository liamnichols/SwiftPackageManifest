import Foundation
import SwiftSyntax

class PrettyPrinter: SyntaxRewriter {
    var indentationLevel: Int = 0

    override func visit(_ node: TupleExprElementSyntax) -> Syntax {
        super.visit(node)
    }

    // This logic is pretty much there, but there is probably a better way to improve the format.
    // Might come back to this later..
    func shouldIndentNode(_ node: Syntax) -> Bool {
        if let node = node.as(FunctionCallExprSyntax.self) {
            return node.argumentList.count > 3
        }

        if let node = node.as(ArrayExprSyntax.self) {
            return node.elements.count > 1
        }

        return false
    }

    override func visitPre(_ node: Syntax) {
        if shouldIndentNode(node) {
            indentationLevel += 1
        }
    }

    override func visitPost(_ node: Syntax) {
        if shouldIndentNode(node) {
            indentationLevel -= 1
        }
    }

    override func visit(_ node: FunctionCallExprSyntax) -> ExprSyntax {
        guard shouldIndentNode(node._syntaxNode) else {
            return super.visit(node)
        }

        // Mutate the node
        var node = node

        // Update the arguments to split onto new lines
        node.argumentList = SyntaxFactory.makeTupleExprElementList(node.argumentList.map { argument in
            var newArgument = argument

            newArgument.leadingTrivia = [.newlines(1), .indentation(indentationLevel)]
            newArgument.trailingTrivia = .zero

            return newArgument
        })

        // Bring the trailing ) onto a new line
        if var rightParen = node.rightParen {
            rightParen.leadingTrivia = rightParen.leadingTrivia
                .appending(.newlines(1))
                .appending(.indentation(indentationLevel - 1))

            node.rightParen = rightParen
        }

        return super.visit(node)
    }

    override func visit(_ node: ArrayExprSyntax) -> ExprSyntax {
        guard shouldIndentNode(node._syntaxNode) else {
            return super.visit(node)
        }

        // Mutate the node
        var node = node

        // Update the elements to break across new lines
        node.elements = SyntaxFactory.makeArrayElementList(node.elements.map { child in
            var newChild = child

            newChild.leadingTrivia = [.newlines(1), .indentation(indentationLevel)]
            newChild.trailingTrivia = .zero

            return newChild
        })

        // Bring the trailing ] onto a new line
        node.rightSquare.leadingTrivia = node.rightSquare.leadingTrivia
            .appending(.newlines(1))
            .appending(.indentation(indentationLevel - 1))

        return super.visit(node)
    }
}

extension Trivia {
    static func indentation(_ level: Int) -> Trivia {
        .spaces(level * 4)
    }
}

extension TriviaPiece {
    static func indentation(_ level: Int) -> TriviaPiece {
        .spaces(level * 4)
    }
}

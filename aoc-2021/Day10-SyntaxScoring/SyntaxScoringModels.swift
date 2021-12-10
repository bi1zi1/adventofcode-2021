import Foundation

let openBrackets = "([{<"
let closedBrackets = ")]}>"

let openToClosedBracketPair = [
    Character("("): Character(")"),
    Character("["): Character("]"),
    Character("{"): Character("}"),
    Character("<"): Character(">"),
]

let closedToOpenBracketPair = [
    Character(")"): Character("("),
    Character("]"): Character("["),
    Character("}"): Character("{"),
    Character(">"): Character("<"),
]

let closedTBracketErrorValue = [
    Character(")"): 3,
    Character("]"): 57,
    Character("}"): 1197,
    Character(">"): 25137,
]

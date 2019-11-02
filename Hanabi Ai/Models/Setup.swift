//
//  Setup.swift
//  Hanabi Ai
//
//  Created by Geoff Hom on 10/9/19.
//  Copyright © 2019 Geoff Hom. All rights reserved.
//

import Foundation

/// A Hanabi game's setup at the start of a turn.
///
/// This includes everything needed for a player/computer to choose their action. For example, past clues.
struct Setup {
    /// All players' hands.
    let hands: [Hand]
    
    /// The index of `hands` for the current player.
    let currentHandIndex: Int
    
    /// The cards remaining in the deck.
    let deck: Deck
    
    /// The number of clues.
    let clues: Int
    
    /// The max number of clues you can have at any time.
    static let MaxClues = 8
    
    /// The number of strikes.
    let strikes: Int
    
    /// The face-up piles for scoring each suit, in suit order.
    let scorePiles: [ScorePile]
    
    /// The number of turns left, if the deck is empty.
    let turnsLeft: Int
    
    /// An array of all score piles, in suit order, with each score set to 0.
    static let InitialScorePiles = Suit.allCases.sorted().map { ScorePile(suit: $0, score: 0) }
    
    // MARK: Creating a Setup
    
    /// Creates a setup with the specified parameters.
    init(hands: [Hand], currentHandIndex: Int, deck: Deck, clues: Int, strikes: Int, scorePiles: [ScorePile], turnsLeft: Int) {
        self.hands = hands
        self.currentHandIndex = currentHandIndex
        self.deck = deck
        self.clues = clues
        self.strikes = strikes
        self.scorePiles = scorePiles
        self.turnsLeft = turnsLeft
    }
    
    // MARK: Actions??
    
    
    /// Returns the number of cards that are still scorable in the game.
    func numberOfScorablesLeft() -> Int {
        /// The number of scorables left.
        var count = 0
        
        for scorePile in scorePiles {
            /// The next card to score.
            var nextCard = Card(suit: scorePile.suit, number: scorePile.score + 1)
            
            while nextCard.number <= 5 {
                guard hands.contain(nextCard) || deck.contains(nextCard) else {
                    break
                }
                count += 1
                nextCard = Card(suit: nextCard.suit, number: nextCard.number + 1)
            }
        }
        return count
    }
    
    // MARK: Finding cards
    
    /// Returns the first playable card in the specified hand; if none, `nil`.
    func firstPlayableCard(in hand: Hand) -> Card? {
        hand.first{scorePiles.nextIs($0)}
    }
    
    /// Returns the first unscorable card in the specified hand; if none, `nil`.
    ///
    /// The card may have already scored, or all of a lower card may have been discarded.
    func firstUnscorableCard(in hand: Hand) -> Card? {
        hand.first { card in
            if scorePiles.alreadyHave(card) {return true}
            
            /// The matching score pile.
            let scorePile = scorePiles.first{$0.suit == card.suit}!
            
            /// The card that has to score prior.
            var beforeCard = Card(suit: card.suit, number: card.number - 1)
            
            while beforeCard.number > scorePile.number {
                if !hands.contain(beforeCard) && !deck.contains(beforeCard) {return true}
                beforeCard = Card(suit: card.suit, number: beforeCard.number - 1)
            }
            return false
        }
    }
    
    /// Returns the first scored card in the specified hand; if none, `nil`.
    func firstScoredCard(in hand: Hand) -> Card? {
        hand.first{scorePiles.alreadyHave($0)}
    }
    
    /// Returns the first card in the specified hand that appears again in any hand (including itself); if none, `nil`.
    func firstHandDuplicateCard(in hand: Hand) -> Card? {
        hand.first{hands.count(for: $0) > 1}
    }
    
    /// Returns the first card in the specified hand that is a future hand duplicate; if none, `nil`.
    func firstFutureHandDuplicate(in hand: Hand) -> Card? {
        hand.first{hasFutureHandDuplicate($0)}
    }
    
    /// Returns the cards in the specified hand that have deck duplicates.
    func cardsWithDeckDuplicates(in hand: Hand) -> [Card] {
        hand.filter{deck.contains($0)}
    }
    
    /// Returns the indices of deck duplicates for the specified hand.
    func deckDuplicateIndices(for hand: Hand) -> [Int] {
        hand.compactMap{deck.firstIndex(of: $0)}
    }
    
    /// Returns the cards in the specified hand that are now unique.
    ///
    /// I.e., if discarded, a perfect score is impossible.
    func singletons(in hand: Hand) -> [Card] {
        // Return cards that are only found once in all hands, and are not in the deck.
        hand.filter{hands.count(for: $0) == 1}
            .filter{!deck.contains($0)}
    }
    
    /// Returns an array of arrays, each containing the indices of a non-trivial deck pair.
    func nonTrivialDeckPairIndices2D() -> [[Int]] {
        /// The indices to return.
        var indices2D: [[Int]] = []
        
        for (index, card) in deck.enumerated() {
            // If the index wasn't already counted, then add it.
            if !indices2D.contains{index == $0[1]} {
                /// The pair indices for this card.
                let pairIndices = nonTrivialDeckPairIndices(for: card)
                
                if !pairIndices.isEmpty {indices2D += [pairIndices]}
            }
            // todo: I guess this could be a lot faster (and related stuff) if we separated the deck by suit. we do that once, and then we have 5x faster times thru each "deck"
            
        }
        return indices2D
    }
    
    /// Returns an array containing the indices of a non-trivial deck pair for the specified card.
    ///
    /// A non-trivial pair can have its predecessor score in between when the pair is seen. Thus which of the pair to keep is non-trivial.
    func nonTrivialDeckPairIndices(for card: Card) -> [Int] {
        guard card.number != 1 && card.number != 5 else {return []}
        guard deck.filter({$0 == card}).count == 2 else {return []}
        
        /// The indices of the pair.
        guard let firstIndex = deck.firstIndex(of: card), let secondIndex = deck.lastIndex(of: card) else {return []}
        
        /// The range between the pair.
        let inBetween = firstIndex + 1..<secondIndex
        
        /// The matching score pile.
        let scorePile = scorePiles.first{$0.suit == card.suit}!
        
        /// The card that has to score prior.
        var priorCard = Card(suit: card.suit, number: card.number - 1)
        
        // Check each prior's first occurrence: It can't be after the pair. One prior's must be between the pair.
        
        /// A Boolean value that indicates whether a prior's first occurrence is between the pair.
        var aPriorIsFirstInBetween = false
        
        while priorCard.number > scorePile.number {
            /// The first occurrence of the prior card.
            if !hands.contain(priorCard), let index = deck.firstIndex(of: priorCard) {
                if index > secondIndex {
                    return []
                } else if inBetween.contains(index) {
                    aPriorIsFirstInBetween = true
                }
            }
            priorCard = Card(suit: card.suit, number: priorCard.number - 1)
        }
        if aPriorIsFirstInBetween {
            return [firstIndex, secondIndex]
        } else {
            return []
        }
    }
    
    /// Returns the non-trivial pairs in the deck.
    func nonTrivialDeckPairs() -> [(Card, Card)] {
        /// The non-trivial pairs.
        var ntPairs: [(Card, Card)] = []
        
        /// The deck cards grouped by suit.
        let deckBySuit: [[Card]] = deck.bySuit
        
        deckBySuit.forEach { suitCards in
            /// The pairs in the suit.
            var pairs: [(Card, Card)] = []
            
            /// Find all pairs.
            for card in suitCards {
                guard card.number != 1 && card.number != 5 else {continue}

                // 2s/3s/4s: If a copy exists further down, then it's a pair we haven't counted.
                if let last = suitCards.last(where: {$0 == card}), last !== card {
                    pairs += [(card, last)]
                }
            }
            
            /// The matching score pile.
            let scorePile = scorePiles.first{$0.suit == suitCards.first!.suit}!
            
            // Check if each pair is non-trivial.
            for pair in pairs {
                /// The pair indices.
                let firstIndex = suitCards.firstIndex(of: pair.0)!
                let secondIndex = suitCards.lastIndex(of: pair.0)!
                                
                /// The range between the pair.
                let inBetween = firstIndex + 1..<secondIndex
                
                /// The card that has to score prior.
                var priorCard = Card(suit: pair.0.suit, number: pair.0.number - 1)
                
                // If a prior's first occurrence is between the pair, and no priors are after the pair, then it's NT.
                
                /// A Boolean value that indicates whether a prior's first occurrence is between the pair.
                var aPriorIsFirstInBetween = false
                
                /// A Boolean value that indicates whether the pair is trivial.
                var isTrivial = false
                
                while priorCard.number > scorePile.number {
                    /// The first occurrence of the prior card.
                    if !hands.contain(priorCard), let index = suitCards.firstIndex(of: priorCard) {
                        if index > secondIndex {
                            isTrivial = true
                            break
                        } else if inBetween.contains(index) {
                            aPriorIsFirstInBetween = true
                        }
                    }
                    priorCard = Card(suit: priorCard.suit, number: priorCard.number - 1)
                }
                if aPriorIsFirstInBetween, !isTrivial {
                    ntPairs += [pair]
                }
            }
        }
        return ntPairs
    }
    
    /// Returns the pairs containing a specified hand card and its deck duplicate, if any.
    func deckDuplicatePairs(for hand: [Card]) -> [(Card, Card)] {
        /// The pairs containing a specified hand card and its deck duplicate.
        var pairs: [(Card, Card)] = []
        
        for card in hand {
            if let deckDuplicate = deck.first(where: {$0 == card}) {
                pairs += [(card, deckDuplicate)]
            }
        }
        return pairs
    }
    
    /// Returns the exact cards to definitely try to score, given the specified non-trivial pairs.
    ///
    /// Returns cards that are the only option, or clearly the best option. However, scoring them is not guaranteed.
    ///
    /// The non-trivial pairs are for simplicity.
    func trivialCardsToScore(nonTrivialPairs: [(Card, Card)]) -> [Card] {
        /// The exact cards to definitely try to score
        var cardsToScore: [Card] = []
        
        for hand in hands {
            for card in hand {
                switch card.number {
                case 5:
                    cardsToScore += [card]
                case 1:
                    // The first 1 should score.
                    if scorePiles.nextIs(card) && !cardsToScore.contains(card) {cardsToScore += [card]}
                case 2, 3, 4:
                    // A singleton should score. Else, it's part of a non-trivial duplicate, or it has a trivial deck duplicate that should score instead.
                    if !deck.contains(card) {cardsToScore += [card]}
                default:
                    ()
                }
            }
        }
        
        for card in deck {
            switch card.number {
            case 5:
                cardsToScore += [card]
            case 1:
                // The first 1 should score.
                if scorePiles.nextIs(card) && !cardsToScore.contains(card) {cardsToScore += [card]}
            case 2, 3, 4:
                // A singleton, should score.
                if !deck.contains(card) {
                    cardsToScore += [card]
                } else {
                    // If non-trivial, skip.
                    guard !nonTrivialPairs.map({$0.0}).contains(card) else {continue}

                    // A trivial deck-duplicate should score.
                    if hands.contain(card) {
                        cardsToScore += [card]
                    } else {
                        // Trivial deck pair. If already counted, skip.
                        guard !cardsToScore.contains(card) else {continue}
                        
                        // If a required scoring card first appears after, then score the second of the pair. Else, score the first of the pair.
                        
                        /// The index of the first card in the pair. (Doesn't matter which one since this is a trivial pair.)
                        let index = deck.firstIndex(of: card)!
                        
                        /// The matching score pile.
                        let scorePile = scorePiles.first{$0.suit == card.suit}!
                        
                        /// The card that has to score prior.
                        var priorCard = Card(suit: card.suit, number: card.number - 1)
                        
                        /// A Boolean value that indicates whether a card was added for the pair.
                        var addedCard = false
                        
                        while priorCard.number > scorePile.number {
                            /// The first occurrence of the prior card.
                            if !hands.contain(priorCard), let priorIndex = deck.firstIndex(of: priorCard), priorIndex > index {
                                // The second of the pair should score.
                                cardsToScore += [deck.last{$0 == card}!]
                                addedCard = true
                                break
                            }
                            priorCard = Card(suit: card.suit, number: priorCard.number - 1)
                        }
                        if !addedCard {
                            // The first of the pair should score.
                            cardsToScore += [deck.first{$0 == card}!]
                        }
                    }
                }
            default:
                ()
            }
        }
        return cardsToScore
    }
    
    /// Returns a tuple that contains the max score and the exact cards to try to score, given the specified non-trivial pairs and chosen cards.
    ///
    /// The max score assumes the AI will try to score the returned cards, but if forced to discard, will discard the slowest least-valuable card.
    ///
    /// - Parameter pairs: An array of tuples, each containing a pair to test.
    /// - Parameter chosen: An array of cards to definitely try to score.
    func maxScore(for pairs: [(Card, Card)], using chosen: [Card]) -> (score: Int, cardsToScore: [Card]) {
        if pairs.isEmpty {
            /// The score for this branch.
            let branchScore = score(for: chosen)
            print("score: \(branchScore); cards: \(chosen.count): \(chosen.description)")
            
            return (score: branchScore, cardsToScore: chosen)
        } else {
            /// A mutable copy.
            var mutablePairs = pairs
            
            /// The pair to test.
            let pair = mutablePairs.removeFirst()
            
            /// The max score for the first of the pair.
            let maxScore1 = maxScore(for: mutablePairs, using: chosen + [pair.0])
            
            /// The max score for the second of the pair.
            let maxScore2 = maxScore(for: mutablePairs, using: chosen + [pair.1])
            
            // TODO: we could calc not just a score but other parameters, like how much play space (# turns) remained, because at the very end that can be tricky. Then choose the safest option with the same score.
            return maxScore1.score >= maxScore2.score ? maxScore1 : maxScore2
        }
    }
    
    /// Returns the score that results from trying to score the specified cards.
    ///
    /// Assumes the AI will play the specified cards optimally, but if forced to discard, will discard the slowest least-valuable card.
    ///
    /// Also, there may not be enough turns at the end to play everything. However, infinite clues to pass the turn are assumed.
    func score(for cardsToScore: [Card]) -> Int {
        /// The score piles for this simulation.
        var tempScorePiles = scorePiles
        
        /// The cards to score among all hands.
        var handCardsToScore = hands.joined().filter{handCard in cardsToScore.contains{$0 === handCard}}
        
        // The cards still to score.
        var cardsStillToScore = cardsToScore

        for card in deck {
            // Before drawing the deck card, we either 1) score a card, 2) discard something we didn't want to keep (so ignore it), or 3) are forced to discard a card we want to score. In the last case, we'll discard the slowest least-valuable card.
            
            /// If there's a scorable card, score it.
            if let scorableCard = handCardsToScore.first(where: {scorePiles.nextIs($0)}) {
                handCardsToScore.remove(scorableCard)
                tempScorePiles.score(scorableCard)
                cardsStillToScore.remove(scorableCard)
            } else if handCardsToScore.count == hands.count * hands[0].count {
                
                /// The least-valuable card that will take the longest to score.
                let slowestLeastValuableCard = self.slowestLeastValuableCard(of: handCardsToScore, whileHaving: cardsStillToScore)
                handCardsToScore.remove(slowestLeastValuableCard)
                cardsStillToScore.remove(slowestLeastValuableCard)
            }

            // Draw the card. If it's a card we still want to score, track it.
            if cardsStillToScore.contains(where: {$0 === card}) {
                handCardsToScore += [card]
            }
        }
        
        /// The theoretical score.
        let score = tempScorePiles.score()
        
        // After the last card is drawn, each player gets a turn.
        return score + hands.count
    }
    
    /// Returns the slowest least-valuable card of the specified hand, assuming only the exact specified cards will be available.
    ///
    /// "Least-valuable" takes precedence.
    func slowestLeastValuableCard(of hand: [Card], whileHaving availableCards: [Card]) -> Card {
        
        /// Returns the worth of the specified card.
        ///
        /// Worth is how many points that card is worth if it scores along with all available cards above it.
        func worth(_ card: Card) -> Int {
            availableCards.filter{$0.suit == card.suit && $0.number > card.number}.count + 1
        }
        
        /// A tuple of the lowest value and the corresponding cards.
        let leastValuable: (worth: Int, cards: [Card]) = hand.reduce(
            (worth: 6, cards: []), { leastValuable, card in
            
            /// The card's worth.
            let value = worth(card)
            
            if value < leastValuable.worth {
                return (worth: value, cards: [card])
            } else if value == leastValuable.worth {
                return (worth: value, cards: leastValuable.cards + [card])
            } else {
                return leastValuable
            }
        })
        
        /// The least-valuable cards.
        let leastValuableCards = leastValuable.cards
        
        // TODO: If this is rate-limiting, we could pass in the indices of availableCards with the cards, like as tuples. actually we can simplify the whole outer function. just get the last card still to score by index, then go up the suit to the last available card. Oh wait, it might not be in the hand.
        /// Returns the number of turns needed to score the specified card.
        func turnsToScore(_ card: Card) -> Int {
            /// The cards that have to score first.
            let priorCards = availableCards.filter{$0.suit == card.suit && $0.number < card.number}
            
            /// The largest index of the cards that have to score first. If all cards in hand, `-1`.
            let maxIndex = priorCards.reduce(-1, { maxIndex, prior in
                /// The deck index of the prior, if any.
                if let index = deck.firstIndex(where: {$0 === prior}), index > maxIndex {return index} else {return maxIndex}
            })
            
            // Turns to play: itself (1) + priors (n) + turns to draw (index + 1)
            return 1 + priorCards.count + maxIndex + 1
        }
        
        /// The slowest, least valuable card.
        let slowest = leastValuableCards.reduce(
            (card: leastValuableCards.first!, turns: 1), { slowest, card in
                /// The number of turns to score the card.
                let turns = turnsToScore(card)
                
                return (turns > slowest.turns) ? (card: card, turns: turns) : slowest
        })
        
        return slowest.card
    }
    
    // todo: rename; scorable could mean it can be scored now, vs potential
    /// Returns an array of indices of deck cards that will score.
    ///
    /// This doesn't account for hand-size limits or running out of turns. Non-trivial deck pairs are not included.
//    func scorableDeckIndices(for card: Card) -> [Int] {
//        /// The indices of deck cards that will score.
//        var scorableDeckIndices: [Int] = []
//
//        for (index, card) in deck.enumerated() {
//            // 5s will score.
//            if card.number == 5 {scorableDeckIndices += [index]}
//
//            // The first new 1 will score.
//            if card.number == 1,
//                let scorePile = scorePiles.first(where: {$0.suit == card.suit}),
//                scorePile.score == 0 {
//
//                guard !scorableDeckIndices.contains(where: {deck[$0] == card}) else {continue}
//                scorableDeckIndices += [index]
//            }
//
//            // 2s/3s/4s: If non-trivial
//            // hmm, the top doc comment isn't good enough. It's not scorables only, as we also include non-trivial deck duplicates; well actually, we want those separately
//        }
//        return scorableDeckIndices
//    }
    
    /// Returns all duplicates where it's unclear whether to keep the first one or wait for the second.
    ///
    /// This includes duplicates where both are currently in the deck.
    ///
    /// 1s are trivial because we play the first one. Duplicates in hand are moot. Future hand duplicates are trivial.
//    func nonTrivialDuplicates() -> Array<Card> {
//        /// The non-trivial duplicates.
//        var nonTrivialDuplicates: [Card] = []
//
//        /// All players' cards.
//        let handsCards = Array(hands.joined())
//
//        for card in handsCards {
//            guard card.number != 1 && card.number != 5 else {continue}
//            guard deck.contains(card) else {continue}
//            guard !hasFutureHandDuplicate(card) else {continue}
//            nonTrivialDuplicates += [card]
//        }
//        nonTrivialDuplicates += deck.filter{hasNonTrivialPair(of: $0)}
//        return nonTrivialDuplicates
//    }
    
    /// Returns a Boolean value that indicates whether the specified card has a non-trivial pair in the deck.
    ///
    /// A non-trivial pair can have its predecessor score in between when the pair is seen. Thus which of the pair to keep is non-trivial.
//    func hasNonTrivialDeckPair(for card: Card) -> Bool {
//        guard card.number != 1 && card.number != 5 else {return false}
//        guard deck.filter({$0 == card}).count == 2 else {return false}
//
//        /// The indices of the pair.
//        guard let firstIndex = deck.firstIndex(of: card), let secondIndex = deck.lastIndex(of: card) else {return false}
//
//        /// The range between the pair.
//        let inBetween = firstIndex + 1..<secondIndex
//
//        /// The matching score pile.
//        let scorePile = scorePiles.first{$0.suit == card.suit}!
//
//        /// The card that has to score prior.
//        var priorCard = Card(suit: card.suit, number: card.number - 1)
//
//        // Check each prior's first occurrence: It can't be after the pair. One prior's must be between the pair.
//
//        /// A Boolean value that indicates whether a prior's first occurrence is between the pair.
//        var aPriorIsFirstInBetween = false
//
//        while priorCard.number > scorePile.number {
//            /// The first occurrence of the prior card.
//            if !hands.contain(priorCard), let index = deck.firstIndex(of: priorCard) {
//                if index > secondIndex {
//                    return false
//                } else if inBetween.contains(index) {
//                    aPriorIsFirstInBetween = true
//                }
//            }
//            priorCard = Card(suit: card.suit, number: priorCard.number - 1)
//        }
//        return aPriorIsFirstInBetween
//    }
    
    /// Returns a Boolean value that indicates whether the specified card is a future hand duplicate.
    ///
    /// A future hand duplicate will see its duplicate in the deck before it can score itself. Thus it can be freely discarded.
    func hasFutureHandDuplicate(_ card: Card) -> Bool {
        switch card.number {
        case 1, 5:
            return false
        default:
            /// The deck index of the card's duplicate.
            guard let duplicateIndex = deck.firstIndex(of: card) else {return false}
            
            /// The matching score pile.
            let scorePile = scorePiles.first{$0.suit == card.suit}!
            
            /// The card that has to score prior.
            var beforeCard = Card(suit: card.suit, number: card.number - 1)
            
            while beforeCard.number > scorePile.number {
                // The "before" card has to not be in a hand, and be in the deck.
                if !hands.contain(beforeCard), let index = deck.firstIndex(of: beforeCard) {
                    
                    if index > duplicateIndex {return true}
                }
                beforeCard = Card(suit: card.suit, number: beforeCard.number - 1)
            }
            return false
        }
    }
    
    /// Returns a Boolean value that indicates whether any card in the specified hand has a duplicate.
    ///
    /// A duplicate can be in the deck, in another hand, or in even the same hand.
    func hasDuplicates(for hand: Hand) -> Bool {
        hasDeckDuplicates(for: hand) || hasHandDuplicates(in: hand)
    }
    
    /// Returns a Boolean value that indicates whether any card in the specified hand has a deck duplicate.
    func hasDeckDuplicates(for hand: Hand) -> Bool {
        hand.contains{deck.contains($0)}
    }
    
    /// Returns a Boolean value that indicates whether any card in the specified hand is a hand duplicate.
    ///
    /// A hand duplicate can be in any hand, including itself.
    func hasHandDuplicates(in hand: Hand) -> Bool {
        hand.contains{hands.count(for: $0) > 1}
    }
    
    /// Returns a Boolean value that indicates whether the other players have only singletons.
//    func othersHaveOnlySingletons() -> Bool {
//        for (index, hand) in hands.enumerated() {
//            guard index != currentHandIndex else {
//                continue
//            }
//            if hasDuplicates(in: hand) {
//                return false
//            }
//        }
//        return true
//    }
    
    /// Returns the card that will take the most turns to play.
    ///
    /// Looks at the deck and assumes optimal play. If none playable, returns `nil`.
    ///
    /// To estimate how slow a card is, we look at the cards that have to score first, and which of those is deepest in the deck.
    // TODO: Right now there are some approximations made. We don't count explicitly who has which cards or the order they're drawn. It's mostly a function of how deeply cards are buried in the deck.
    func slowestPlayableCard(cards: [Card]) -> Card? {
        /// The slowest playable card.
        var slowestCard: Card?
        
        /// The number of turns to play the slowest card.
        var turnsToPlaySlowestCard = 0
        
        for card in cards {
            /// The matching score pile.
            let scorePile = scorePiles.first{$0.suit == card.suit}!
            
            // If unplayable, skip.
            guard card.number > scorePile.number else {
                continue
            }
            
            /// The number of turns to play this card.
            var turnsToPlay = 0
            
            /// The number of cards to draw to be able to play this card.
            var turnsToDraw = 0
            
            /// The card that has to score before this card.
            var beforeCard = Card(suit: card.suit, number: card.number - 1)
            
            while beforeCard.number > scorePile.number {
                // 1 turn to play the "before" card.
                turnsToPlay += 1
                
                // We'll worry only about cards not in a hand.
                if !hands.contain(beforeCard), let index = deck.firstIndex(of: beforeCard) {
                    
                    // One "before" card will be deepest. Once we have that, we'll have the others.
                    turnsToDraw = max(turnsToDraw, index + 1)
                }
                beforeCard = Card(suit: card.suit, number: beforeCard.number - 1)
            }
            turnsToPlay += turnsToDraw
            
            if turnsToPlay > turnsToPlaySlowestCard {
                slowestCard = card
                turnsToPlaySlowestCard = turnsToPlay
            }
        }
    
        return slowestCard
    }

    /// Chooses and returns an action for this setup.
    /// todo: Under construction. The chosen action will depend on the setup and the AIs.
//    func chooseAction() -> Action {
//        //testing
//        let action: Action
//        
//
//        // temp; play first card in hand, for testing
//        action = Action(type: .play, card: hands[currentHandIndex].first!, number: nil, suit: nil)
//        
//        return action
//    }
    
    // MARK: Game end
    
    /// Returns a Boolean value that indicates whether this setup has reached the end of the game.
    ///
    /// There are three ways for Hanabi to end: A 3rd strike, a perfect score of 25, or turns run out.
    func isAtGameOver() -> Bool {
        strikes == 3 || hasPerfectScore() || isOutOfTurns()
    }
    
    /// Returns a Boolean value that indicates whether the score is maxed out in all score piles.
    func hasPerfectScore() -> Bool {
        for scorePile in scorePiles {
            if scorePile.score < ScorePile.MaxNumber {
                return false
            }
        }
        return true
    }
    
    /// Returns a Booelan value that indicates whether there are no more turns left.
    ///
    /// When the last card has been drawn, each player gets one more turn, then the game ends.
    func isOutOfTurns() -> Bool {
        deck.isEmpty && (turnsLeft == 0)
    }
}

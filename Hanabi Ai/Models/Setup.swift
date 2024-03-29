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
    
    /// Returns the cards in the specified hand that are now unique.
    ///
    /// I.e., if discarded, a perfect score is impossible.
    func singletons(in hand: Hand) -> [Card] {
        // Return cards that are only found once in all hands, and are not in the deck.
        hand.filter{hands.count(for: $0) == 1}
            .filter{!deck.contains($0)}
    }
    
    /// Returns the non-trivial pairs in the deck.
    func nonTrivialDeckPairs() -> [(Card, Card)] {
        /// The non-trivial pairs.
        var ntPairs: [(Card, Card)] = []
        
        /// The deck cards grouped by suit.
        let deckBySuit: [[Card]] = deck.bySuit
        
        for suitCards in deckBySuit {
            guard !suitCards.isEmpty else {continue}
            
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
            
            // The matching score pile.
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
    /// Scored cards are excluded.
    ///
    /// The non-trivial pairs are passed in for simplicity.
    func trivialCardsToScore(nonTrivialPairs: [(Card, Card)]) -> [Card] {
        /// The exact cards to definitely try to score.
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
                    // An unscored singleton should score. Else, it's part of a non-trivial duplicate, or it has a trivial deck duplicate that should score instead.
                    if !deck.contains(card), !scorePiles.alreadyHave(card) {
                        cardsToScore += [card]
                    }
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
                // An unscored singleton should score.
                if !hands.contain(card), deck.filter({$0 == card}).count == 1 {
                    if !scorePiles.alreadyHave(card) {
                        cardsToScore += [card]
                    }
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
                        // TODO: I look at prior cards in multiple functions. Abstract it out?
                        
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
    
    /// Returns a tuple that contains the max score and the exact cards to play, given the specified non-trivial pairs and cards to try to score.
    ///
    /// Also returns the number of consecutive plays needed through the last possible turn. (Lower/zero is better.)
    ///
    /// - Parameter pairs: The pairs to test.
    /// - Parameter cardsToTryToScore: The cards to definitely try to score. No duplicates. Contains one of each card needed to get a perfect score (based on the current score), except for cards in `pairs`.
    func maxScore(for pairs: [(Card, Card)], using cardsToTryToScore: [Card]) -> (score: Int, cardsToPlay: [Card], endPlays: Int) {
        if pairs.isEmpty {
            /// The cards to try to score, minus those that can't score in time.
            let cardsAllowedToScore = removingUnscorableCards(from: cardsToTryToScore)
                        
            /// The score for this branch.
            let branchScore = score(for: cardsAllowedToScore)
//            print("score: \(branchScore.score); endplays: \(branchScore.endPlays)")
            
            return branchScore
        } else {
            /// A mutable copy.
            var mutablePairs = pairs
            
            /// The pair to test.
            let pair = mutablePairs.removeFirst()
            
            /// The max score for the first of the pair.
            let maxScore1 = maxScore(for: mutablePairs, using: cardsToTryToScore + [pair.0])
            
            /// The max score for the second of the pair.
            let maxScore2 = maxScore(for: mutablePairs, using: cardsToTryToScore + [pair.1])
            
            // TODO: we could calc not just a score but other parameters, like how much play space (# turns) remained, because at the very end that can be tricky. Then choose the safest option with the same score.
            /// The score to return.
            var maxScore = maxScore1
            
            if maxScore2.score > maxScore1.score || (maxScore2.score == maxScore1.score && maxScore2.endPlays < maxScore1.endPlays) {
                maxScore = maxScore2
            }
                // todo: maxScore2.
                // hmm, we could look at the last deck turn and after, only.
                // or the number of consecutive turns at the end. yeah, let's try that
               
            return maxScore
//            return maxScore1.score >= maxScore2.score ? maxScore1 : maxScore2
        }
    }
    
    /// Returns the specified cards minus those that can't score in time.
    ///
    /// If the last deck card is meant to score, then cards above that can't score. Similarly, if the 2nd-to-last deck card is a 2 in a 2-player game, then the 5 can't score.
    ///
    /// - Parameter cardsAllowedToScore: The only cards allowed to score. No duplicates. Any 1s are not in the last two deck cards.
    func removingUnscorableCards(from cardsAllowedToScore: [Card]) -> [Card] {
        /// The cards allowed to score minus those that can't score in time.
        var refinedCardsAllowedToScore = cardsAllowedToScore
        
        // If the last deck card is meant to score, then remove cards above it.
        if let last = deck.last, cardsAllowedToScore.containsExact(last), last.number != ScorePile.MaxNumber {
            let unscorableCards = cardsAllowedToScore.filter{$0.suit == last.suit && $0.number > last.number}
            unscorableCards.forEach{refinedCardsAllowedToScore.remove($0)}
        }
        
        // If a 2-player game, the penultimate deck card is meant to score, and it's a 2, then remove the 5.
        let penultimate = deck[deck.count - 2]
        if hands.count == 2, cardsAllowedToScore.containsExact(penultimate), penultimate.number == 2, let matching5 = cardsAllowedToScore.first(where: {$0.suit == penultimate.suit && $0.number == 5}) {
            refinedCardsAllowedToScore.remove(matching5)
        }
        
        return refinedCardsAllowedToScore
    }
    
    /// Returns the score that results from trying to score the specified cards, and returns the exact cards to play.
    ///
    /// Also returns the number of consecutive plays needed through the last possible turn. (Lower/zero is better.)
    ///
    /// Assumes AI plays the specified cards optimally, but if forced to discard, will discard the slowest least-valuable card.
    ///
    /// Also, there may not be enough turns at the end to play everything. However, infinite clues to pass the turn are assumed.
    ///
    /// - Parameter cardsAllowedToScore: The only cards allowed to score. No duplicates, no gaps. Assumes any card can score (i.e., already ran `removingUnscorableCards(from:)`).
    func score(for cardsAllowedToScore: [Card]) -> (score: Int, cardsToPlay: [Card], endPlays: Int) {
        /// The score piles for this simulation.
        var tempScorePiles = scorePiles
        
        /// The cards still allowed to score.
        var mutableCardsAllowedToScore = cardsAllowedToScore
        
        /// The exact cards to play.
        var cardsToPlay = mutableCardsAllowedToScore
        
        /// The hand cards allowed to score. (Any hand.)
        var handCardsAllowedToScore = hands.joined().filter{mutableCardsAllowedToScore.containsExact($0)}
        
        /// The number of consecutive plays thru the last possible turn.
        var endPlays = 0
        
        for card in deck {
            // Before drawing the deck card, we either 1) score a card, 2) are forced to discard a desirable card because of the hand limit, or 3) discard something we didn't want to keep (so ignore it). In the 2nd case, we'll discard the slowest least-valuable card.
            
            /// If there's a scorable card, score it.
            if let scorableCard = handCardsAllowedToScore.first(where: {tempScorePiles.nextIs($0)}) {
                handCardsAllowedToScore.remove(scorableCard)
                tempScorePiles.score(scorableCard)
                mutableCardsAllowedToScore.remove(scorableCard)
                endPlays += 1
            } else if handCardsAllowedToScore.count == hands.count * hands[0].count {
                
                /// The least-valuable card that will take the longest to score.
                let worstCard = slowestLeastValuableCard(of: handCardsAllowedToScore, whileAllowing: mutableCardsAllowedToScore)
                handCardsAllowedToScore.remove(worstCard)
                mutableCardsAllowedToScore.remove(worstCard)
                cardsToPlay.remove(worstCard)
                endPlays = 0
            } else {
                endPlays = 0
            }

            // Draw the card. If it's a card we still want to score, track it.
            if mutableCardsAllowedToScore.containsExact(card) {
                handCardsAllowedToScore += [card]
            }
        }
    
                // The score doesn't include the cards scored after deck empty.
        //        print("tempScorePiles: \(tempScorePiles.description). handCardsAllowedToScore: \(handCardsAllowedToScore.description)")
                
        /// The theoretical score. After the last card is drawn, each player gets a turn.
        let score = tempScorePiles.score() + min(hands.count, handCardsAllowedToScore.count)
        
        /// If the hands have cards left to score, assume they're at the last possible turn. Shouldn't matter?
        if handCardsAllowedToScore.count == hands.count {
            endPlays += handCardsAllowedToScore.count
        } else {
            endPlays = handCardsAllowedToScore.count
        }

        return (score: score, cardsToPlay: cardsToPlay, endPlays: endPlays)
    }
    
    /// Returns the slowest least-valuable card of the specified hand, assuming only the exact specified cards are allowed to score.
    ///
    /// "Least-valuable" takes precedence.
    ///
    /// - Parameter handCardsAllowedToScore: The hand cards allowed to score. Must be a subset of `cardsAllowedToScore`.
    /// - Parameter cardsAllowedToScore: The only cards allowed to score. No duplicates, no gaps. Assumes any card can score (i.e., already ran `removingUnscorableCards(from:)`).
    func slowestLeastValuableCard(of handCardsAllowedToScore: [Card], whileAllowing cardsAllowedToScore: [Card]) -> Card {
                
        /// Returns the worth of the specified card.
        ///
        /// Worth is the card plus all allowed cards above it, as each card is a point.
        func worth(_ card: Card) -> Int {
            cardsAllowedToScore.filter{$0.suit == card.suit && $0.number > card.number}.count + 1
        }
        
        /// A tuple of the lowest value and the corresponding cards.
        let leastValuable: (worth: Int, cards: [Card]) = handCardsAllowedToScore.reduce(
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
        
        /// Returns the number of turns needed to score the specified card.
        func turnsToScore(_ card: Card) -> Int {
            /// The cards that have to score first.
            let priorCards = cardsAllowedToScore.filter{$0.suit == card.suit && $0.number < card.number}
            
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

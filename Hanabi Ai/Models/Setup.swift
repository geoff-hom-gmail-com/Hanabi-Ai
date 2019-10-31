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
    
    // TODO: implement recursive; then check how others do recursive (e.g., https://www.weheartswift.com/recursion/
    /// Returns a tuple that contains the highest score and the indices to enable that, for the specified non-trivial pair indices with the specified chosen indices.
    ///
    /// param pairIndices2D: An array of arrays, each containing the deck indices of a pair to test. If an array has only one index, then the other card must be in a hand.
    /// chosenIndices: An array of indices that have been chosen to test
    func highestScore(for pairIndices2D: [[Int]], with chosenIndices: [Int]) -> (score: Int, indices: [Int]) {
        if pairIndices2D.isEmpty {
            print("chosen: \(chosenIndices)")
            /// The score for the chosen indices.
            let score = self.score(for: chosenIndices)
            
            return (score: score, indices: chosenIndices)
        } else {
            /// The tuple to return.
            var highestScoreTuple: (score: Int, indices: [Int]) = (score: -1, indices: [])

            /// A mutable copy.
            var mutablePairIndices2D = pairIndices2D
            
            /// The pair of indices to test.
            let pairIndices = mutablePairIndices2D.removeFirst()
            
            // TODO: I think we can simplify this. We are always doing two branches, so just compare them and return the highest one. (ternary op)
            // if one elt, then we test the index we have and... we need a way to signal the chosenIndex was in-hand
            // that will get passed down to the scoring function; it needs to know the card at least; so we could pass in the card
            // it could also get it by inference, but that's extra computation we already did: if a deck dup index isn't there, then we must mean the card in hand
            // we could have setup have a cardsWithDeckDuplicates lazy property, so turns which need it would have it
            
            // If only one index, then we also have to test the card in hand.
            if pairIndices.count == 1 {
                /// The highest score tuple for the card in hand.
                let highestScoreTupleForHandCard = highestScore(for: mutablePairIndices2D, with: chosenIndices)

                // TODO: we could calc not just a score but other parameters, like how much play space (# turns) remained, because at the very end that can be tricky.
                if highestScoreTupleForHandCard.score > highestScoreTuple.score {
                    highestScoreTuple = highestScoreTupleForHandCard
                }
            }
            for index in pairIndices {
                /// The highest score tuple for this index.
                let highestScoreTupleForIndex = highestScore(for: mutablePairIndices2D, with: chosenIndices + [index])
                
                if highestScoreTupleForIndex.score > highestScoreTuple.score {
                    highestScoreTuple = highestScoreTupleForIndex
                }
            }
            return highestScoreTuple
        }
    }
    
    /// Returns the score that results from keeping the specified cards.
    ///
    /// Each index should be for a non-trivial duplicate (well, later we may just pass in the whole array of keepers, as we would've calculated that once).
    func score(for chosenIndices: [Int]) -> Int {
        // so, we'll go thru the deck, and keep some or discard others
        // well, let's not rush this. What's the most straightforward way to do this?
        // tagged cards? we can get these now from the above: non-trivial dups not mentioned are in hand
        // or, we could get them earlier; just pass in whether we use the one in hand or not (like also pass in hand cards with dups kept)
        // so yeah, if a 2/3/4 is not a non-trivial dup, then we keep it if we can play it asap, else we discard
        // so we don't really need to calc tags beforehand; just each card, check for 1/5, then for non-trivial... well how do we check for play asap? if we have the priors in hand, then ok
        // ok, calculating tags beforehand means we don't have to do it for each of say 32 branches. But calculating tags here is maybe faster; we don't have to see for a given 2/3/4 where all its priors are; just if they're in hand; yeah, you have to search thru the deck for each prior, so for a 4 that's maybe 3 cards. So maybe 2x slower.
        // let's not worry about premature optimization. can fix later if it's an issue
        // actually, once we get the best route, the rest of the game should be trivial: play if can; discard cards not on the route; if need be, discard good card that will score last (that can even be passed back from this function)
        // what's simplest? do it here
        // for card in deck: if tagged, then cards to keep: +1; turns left: -1; if can play a card, then cards to keep: -1, that score pile: +1
        // if cards to keep = 10 and can't play, then cards to keep: -1; discard the card that will take longest to score (should be able to calculate that for the whole route by going backwards, once, as all the keepers are known; or just go from backward, and find the first keeper, and it's the highest held card in that suit)
        // if cards to keep > turns left, that's fine. when we get to turns left = 0, see how many cards to keep we have (rename: potential scorers? cards to score?) well it's irrelevant; we have our score now; but we can also return # cards to score leftover, and the # of discarded cards to score. that will be handy for comparing same scores.
        for card in deck {
            // let's pretend a 5
            // so keepArray: add it
            // do we assume all the cards in hand we want to keep? no, as some branches will discard. but we can assume it's all singletons (5s) and non-trivial dups
            // so, we need to go thru all hands and look at the 2/3/4s. If there's a chosen index which is the same card, then discard the hand card.
            // ah, there could be others, like if it was a hand dup and it tossed one. well, that's the same
        }
        return 0
    }
    
    // todo: rename; scorable could mean it can be scored now, vs potential
    /// Returns an array of indices of deck cards that will score.
    ///
    /// This doesn't account for hand-size limits or running out of turns. Non-trivial deck pairs are not included.
    func scorableDeckIndices(for card: Card) -> [Int] {
        /// The indices of deck cards that will score.
        var scorableDeckIndices: [Int] = []
        
        for (index, card) in deck.enumerated() {
            // 5s will score.
            if card.number == 5 {scorableDeckIndices += [index]}
            
            // The first new 1 will score.
            if card.number == 1,
                let scorePile = scorePiles.first(where: {$0.suit == card.suit}),
                scorePile.score == 0 {

                guard !scorableDeckIndices.contains(where: {deck[$0] == card}) else {continue}
                scorableDeckIndices += [index]
            }
            
            // 2s/3s/4s: If non-trivial
            // hmm, the top doc comment isn't good enough. It's not scorables only, as we also include non-trivial deck duplicates; well actually, we want those separately
        }
        return scorableDeckIndices
    }
    
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

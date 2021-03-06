//
//  EventsBrowserStateSpec.swift
//  Octowire
//
//  Created by Mart Roosmaa on 26/02/2017.
//  Copyright © 2017 Mart Roosmaa. All rights reserved.
//

import Foundation
import ReSwift
import Quick
import Nimble
@testable import Octowire

class EventsBrowserStateSpec: QuickSpec {
    override func spec() {
        describe("actions") {
            let store = Store<EventsBrowserState>(
                reducer: EventsBrowserReducer(unfilteredEventsCapacity: 2),
                state: nil)
            
            it("begins initial preloading") {
                store.dispatch(EventsBrowserActionBeginPreloading())
                expect(store.state.isPreloadingEvents).to(equal(true))
            }
            
            it("ends initial preloading") {
                store.dispatch(EventsBrowserActionEndPreloading(preloadedEvents: [
                    (PullRequestEventModel(), eta: 8),
                    (CreateEventModel(), eta: 7),
                    (ForkEventModel(), eta: 5),
                    (WatchEventModel(), eta: 4)]))
                expect(store.state.isPreloadingEvents).to(equal(false))
                expect(store.state.preloadedEvents.map({ $0.eta })).to(equal([5, 4, 2, 1]))
            }
            
            it("reveals first preloaded event") {
                store.dispatch(EventsBrowserActionRevealPreloaded())
                expect(store.state.filteredEvents).to(haveCount(1))
                expect(store.state.filteredEvents[0]).to(beAnInstanceOf(WatchEventModel.self))
            }
            
            it("reveals next preloaded above others") {
                store.dispatch(EventsBrowserActionRevealPreloaded())
                expect(store.state.filteredEvents).to(haveCount(2))
                expect(store.state.filteredEvents[0]).to(beAnInstanceOf(ForkEventModel.self))
                expect(store.state.filteredEvents[1]).to(beAnInstanceOf(WatchEventModel.self))
            }
            
            it("reveals nothing due preload queue having a gap") {
                store.dispatch(EventsBrowserActionRevealPreloaded())
                expect(store.state.filteredEvents).to(haveCount(2))
                expect(store.state.filteredEvents[0]).to(beAnInstanceOf(ForkEventModel.self))
                expect(store.state.filteredEvents[1]).to(beAnInstanceOf(WatchEventModel.self))
            }
            
            it("reveals next hitting event capacity") {
                store.dispatch(EventsBrowserActionRevealPreloaded())
                expect(store.state.filteredEvents).to(haveCount(2))
                expect(store.state.filteredEvents[0]).to(beAnInstanceOf(CreateEventModel.self))
                expect(store.state.filteredEvents[1]).to(beAnInstanceOf(ForkEventModel.self))
            }
            
            it("updates scroll top distance") {
                store.dispatch(EventsBrowserActionUpdateScrollTopDistance(to: 100))
                expect(store.state.scrollTopDistance).to(equal(100))
                
                store.dispatch(EventsBrowserActionUpdateScrollTopDistance(to: -1))
                expect(store.state.scrollTopDistance).to(equal(0))
            }
            
            it("updates is visible") {
                store.dispatch(EventsBrowserActionUpdateIsVisible(to: true))
                expect(store.state.isVisible).to(equal(true))
                
                store.dispatch(EventsBrowserActionUpdateIsVisible(to: false))
                expect(store.state.isVisible).to(equal(false))
            }
            
            it("filters results") {
                store.dispatch(EventsBrowserActionUpdateActiveFilters(to: [.forkEvents]))
                expect(store.state.filteredEvents).to(haveCount(1))
                expect(store.state.unfilteredEvents).to(haveCount(2))
            }
            
            it("doesn't reveal filtered") {
                store.dispatch(EventsBrowserActionRevealPreloaded())
                expect(store.state.filteredEvents).to(haveCount(0))
                expect(store.state.unfilteredEvents).to(haveCount(2))
            }
            
            it("begins another preloading") {
                store.dispatch(EventsBrowserActionBeginPreloading())
                expect(store.state.isPreloadingEvents).to(equal(true))
            }
            
            it("ends another preloading") {
                store.dispatch(EventsBrowserActionEndPreloading(preloadedEvents: [
                    (ForkEventModel(), eta: 5),
                    (WatchEventModel(), eta: 4)]))
                expect(store.state.isPreloadingEvents).to(equal(false))
                expect(store.state.preloadedEvents.map({ $0.eta })).to(equal([6, 5]))
            }
            
        }
        
        xdescribe("action creaters") {
            let store = Store<AppState>(
                reducer: AppReducer(),
                state: nil)
            
            it("doesn't load events when hidden") {
                store.dispatch(EventsBrowserActionUpdateIsVisible(to: false))
                store.dispatch(EventsBrowserActionUpdateScrollTopDistance(to: 0))
                store.dispatch(loadNextEvent())
                
                expect(store.state.eventsBrowserState.isPreloadingEvents).to(equal(false))
            }
            
            it("doesn't load events when scrolled") {
                store.dispatch(EventsBrowserActionUpdateIsVisible(to: true))
                store.dispatch(EventsBrowserActionUpdateScrollTopDistance(to: 100))
                store.dispatch(loadNextEvent())
                
                expect(store.state.eventsBrowserState.isPreloadingEvents).to(equal(false))
            }
            
            it("loads events") {
                store.dispatch(EventsBrowserActionUpdateIsVisible(to: true))
                store.dispatch(EventsBrowserActionUpdateScrollTopDistance(to: 0))
                store.dispatch(loadNextEvent())
                
                expect(store.state.eventsBrowserState.isPreloadingEvents).to(equal(true))
                expect(store.state.eventsBrowserState.isPreloadingEvents).toEventually(equal(false), timeout: 5)
            }
        }
    }
}

//
//  DizzyFlowTests.swift
//  DizzyFlowTests
//
//  Created by SangHyouk Jin on 3/31/26.
//

import Testing
@testable import DizzyFlow

struct DizzyFlowTests {
    @MainActor
    @Test func selectingDocumentSetsReadyPhase() {
        let store = WorkflowStore()

        #expect(store.currentPhase == .idle)
        #expect(store.selectedDocument == nil)

        store.selectDocument(store.documents.first)

        #expect(store.selectedDocument == store.documents.first)
        #expect(store.currentPhase == .ready)
        #expect(store.lastUpdated != nil)
        #expect(store.documents.first?.workflowPhase == .ready)
    }

    @MainActor
    @Test func clearingSelectionReturnsToIdle() {
        let store = WorkflowStore()

        store.selectDocument(store.documents.first)
        store.selectDocument(nil)

        #expect(store.selectedDocument == nil)
        #expect(store.currentPhase == .idle)
        #expect(store.lastUpdated == nil)
    }

    @MainActor
    @Test func selectingAnotherDocumentPreservesExistingDocumentState() {
        let store = WorkflowStore()

        let firstDocument = store.documents[0]
        let secondDocument = store.documents[1]

        store.selectDocument(firstDocument)
        store.selectDocument(secondDocument)

        #expect(store.selectedDocument?.id == secondDocument.id)
        #expect(store.documents[0].workflowPhase == .ready)
        #expect(store.documents[1].workflowPhase == .ready)
    }

    @MainActor
    @Test func mockWorkflowCompletes() async throws {
        let store = WorkflowStore(
            mockStepDurationNanoseconds: 1_000_000
        )

        store.selectDocument(store.documents.first)
        store.startMockWorkflow()

        try await Task.sleep(nanoseconds: 20_000_000)

        #expect(store.currentPhase == .completed)
        #expect(store.lastUpdated != nil)
        #expect(store.documents.first?.workflowPhase == .completed)
    }

    @MainActor
    @Test func workflowPhaseIsTrackedPerDocument() async throws {
        let store = WorkflowStore(
            mockStepDurationNanoseconds: 1_000_000
        )

        let firstDocument = store.documents[0]
        let secondDocument = store.documents[1]

        store.selectDocument(firstDocument)
        store.startMockWorkflow()

        try await Task.sleep(nanoseconds: 20_000_000)

        store.selectDocument(secondDocument)

        #expect(store.documents[0].workflowPhase == .completed)
        #expect(store.documents[1].workflowPhase == .ready)
        #expect(store.selectedDocument?.id == secondDocument.id)
    }
}

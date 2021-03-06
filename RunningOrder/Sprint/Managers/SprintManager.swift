//
//  SprintManager.swift
//  RunningOrder
//
//  Created by Clément Nonn on 06/08/2020.
//  Copyright © 2020 Worldline. All rights reserved.
//

import SwiftUI
import Combine
import CloudKit

///The class responsible of managing the Sprint data, this is the only source of truth
final class SprintManager: ObservableObject {
    @Published var sprints: [Sprint] = []

    var cancellables: Set<AnyCancellable> = []

    private let service: SprintService

    init(service: SprintService, dataPublisher: AnyPublisher<ChangeInformation, Never>) {
        self.service = service

        dataPublisher.sink(receiveValue: { [weak self] informations in
            self?.updateData(with: informations.toUpdate)
            self?.deleteData(recordIds: informations.toDelete)
        }).store(in: &cancellables)
    }

    func add(sprint: Sprint) -> AnyPublisher<Sprint, Error> {
        let saveSprintPublisher = service.save(sprint: sprint)
            .share()
            .receive(on: DispatchQueue.main)

        saveSprintPublisher
            .catchAndExit { _ in }
            .append(to: \.sprints, onStrong: self)
            .store(in: &cancellables)

        return saveSprintPublisher.eraseToAnyPublisher()
    }

    func updateData(with updatedRecords: [CKRecord]) {
        for updatedRecord in updatedRecords {
            do {
                let sprint = try Sprint(from: updatedRecord)
                if let index = sprints.firstIndex(where: { $0.id == sprint.id }) {
                    DispatchQueue.main.async {
                        self.sprints[index] = sprint
                    }
                } else {
                    Logger.verbose.log("sprint with id \(sprint.id) not found, so appending it to existing sprint list")
                    DispatchQueue.main.async {
                        self.sprints.append(sprint)
                    }
                }
            } catch {
                Logger.error.log(error)
            }
        }
    }

    func deleteData(recordIds: [CKRecord.ID]) {
        for recordId in recordIds {
            guard let index = sprints.firstIndex(where: { $0.id == recordId.recordName }) else {
                Logger.warning.log("sprint not found when deleting \(recordId.recordName)")
                return
            }
            DispatchQueue.main.async {
                self.sprints.remove(at: index)
            }
        }
    }
}

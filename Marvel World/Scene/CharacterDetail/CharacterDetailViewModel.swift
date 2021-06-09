//
//  CharacterDetailViewModel.swift
//  Marvel World
//
//  Created by Mohammad Javad Bashtani on 3/19/1400 AP.
//

import Combine
import Foundation

class CharacterDetailViewModel {
    let character: Character
    let characterLoader = NetworkCharacterLoader()
    var availableAppearnces: [AppearanceType] = []
    var cancelables =  Set<AnyCancellable>()
    
    var appearancesFetched = PassthroughSubject<[Appearance], Error>()
    @Published var isLoading = false
    
    init(character: Character ) {
        self.character = character
        availableAppearnces = setUpAvailableAppearnces(character: character)
    }
    
    private func setUpAvailableAppearnces(character: Character) -> [AppearanceType]  {
        let array =   AppearanceType.allCases.filter { type  in
              switch type {
              case .comics:
                return !(character.comics?.items.isEmpty ?? true)
              case .series:
                  return !(character.series?.items.isEmpty ?? true)
              case .events:
                  return !(character.events?.items.isEmpty ?? true)
              case .stories:
                  return !(character.stories?.items.isEmpty ?? true)
              }
          }
          return array
    }
    
    func fetchAppearances(type: AppearanceType) {
        isLoading = true
        characterLoader
            .loadCharacterAppearances(type: type, characterId: character.id.description)
            .sinkToResult { [weak self] result in
                self?.isLoading = false
                switch result {
                case .success(let data):
                    self?.appearancesFetched.send(data.results)
                case .failure(let error):
                    self?.appearancesFetched.send(completion: .failure(error))
                }
            }.store(in: &cancelables)
    }
    
}
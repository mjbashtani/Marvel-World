//
//  CharacterListDiffableDatasource.swift
//  Marvel World
//
//  Created by Mohammad Javad Bashtani on 3/16/1400 AP.
//

import Foundation
import UIKit


class CharacterListDiffableDataSource {
    // MARK: - Private Properites
    private var dataSource: UITableViewDiffableDataSource<Section, CellWrapper>?
    
    // MARK: - Initilize
    init(tableView: UITableView) {
        self.dataSource = makeDataSource(tableView: tableView)
    }
    // MARK: - DataSoure Update
    func update(with list: [Character],storageController: FavouriteStorageController, isMoreDataAvailable: Bool = true) {
        var snapshot =  createSnapShot(with: list, stroageController: storageController)
        if isMoreDataAvailable {
            snapshot.appendItems([CellWrapper.loadingCell], toSection: .loading)
        } else {
            if list.isEmpty {
                snapshot.appendItems([CellWrapper.noDataAvailable], toSection: .noDataAvailable)
            }
        }
        dataSource?.apply(snapshot, animatingDifferences: false)
        
    }
    
    func setError(characters: [Character],storageController: FavouriteStorageController, error: Error, retryAction: UIAction) {
        var snapshot =  createSnapShot(with: characters, stroageController: storageController)
        snapshot.appendItems([CellWrapper.retryCell(action: retryAction)], toSection: .Retry)
        dataSource?.apply(snapshot, animatingDifferences: false)
    }
    
    private func createSnapShot(with list: [Character], stroageController: FavouriteStorageController) -> NSDiffableDataSourceSnapshot<Section, CellWrapper> {
        var snapshot = NSDiffableDataSourceSnapshot<Section, CellWrapper>()
        snapshot.appendSections(Section.allCases)
        let characters = list.uniqued().map { character in
            CellWrapper.characterCell(viewModel: .init(character: character, favouriteStroageController: stroageController))
        }
        snapshot.appendItems(characters, toSection: .character)
        return snapshot
    }
    
    
}

//  // MARK: - Create DataSource
extension CharacterListDiffableDataSource {
    fileprivate func makeDataSource(tableView: UITableView) -> UITableViewDiffableDataSource<Section, CellWrapper> {
        
        let dataSource =  UITableViewDiffableDataSource<Section, CellWrapper>(
            tableView: tableView,
            cellProvider: {  tableView, indexPath, wrapper in
                
                switch wrapper {
                case .characterCell(let character):
                    let cell = tableView.dequeueReusableCell(cell: CharacterTableViewCell.self, at: indexPath)
                    cell.bind(data: character)
                    return cell
                case .loadingCell:
                    let cell = tableView.dequeueReusableCell(cell: LoadingTableViewCell.self, at: indexPath)
                    return cell
                case .retryCell(let action):
                    let cell =  tableView.dequeueReusableCell(cell: RetryTableViewCell.self, at: indexPath)
                    cell.bind(data: action)
                    return cell
                case .noDataAvailable:
                   return tableView.dequeueReusableCell(cell: NoDataAvailableTableViewCell.self, at: indexPath)
                }
                
            }
        )
        return dataSource
    }
}

extension CharacterListDiffableDataSource {
    enum Section: CaseIterable {
        case character
        case loading
        case Retry
        case noDataAvailable
    }
    
    enum CellWrapper: Hashable {
        case characterCell(viewModel: CharacterViewModel)
        case loadingCell
        case noDataAvailable
        case retryCell(action: UIAction)
        
    }
}




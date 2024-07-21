

import UIKit

final class CocktailsLIstVC: UIViewController {
    
    enum Section {
        case main
    }
    
    let stack = UIStackView()
    let btnOne = UIButton()
    let btnTwo = UIButton()
    let btnThree = UIButton()
    var filterButtonIsActive = false
    
    let searchController = UISearchController()
    var dataSourse: UICollectionViewDiffableDataSource<Section, Cocktail>!
    var collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    var cocktails: [Cocktail] = []
    var cocktailsToPresent: [Cocktail] = []
    var filteredCocktails: [Cocktail] = []
    var isSearching = false
    
    let filterVC = FilterVC()
    var minProof = 0
    var maxProof = 50
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureCollectionView()
        configureSearchController()
        getCocktails()
        configureDataSourse()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard searchController.searchBar.text == "" else { return }
        configureRightViewOfSearchBar()
    }
    
    
    private func getCocktails() {
        Task {
            do {
                cocktails = try await JSONManager.shared.parseJSON()
                cocktails.shuffle()
                cocktailsToPresent = cocktails
                self.updateData(on: self.cocktailsToPresent)
            } catch {
                // TODO: Вместо вывода ошибки сделать уведомляющее окно
                print(error)
            }
        }
    }
    
    private func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UIHelper.createOneRectangleColumnLayout(in: view))
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.backgroundColor = .systemBackground
        collectionView.register(CocktailCell.self, forCellWithReuseIdentifier: CocktailCell.reuseID)
    }
    
    
    private func configureSearchController() {
        searchController.searchBar.placeholder = "Поиск коктейлей"
        searchController.searchBar.tintColor = UIColor(hex: "#FF7F50")
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
        
        configureFilterButtons()
        configureStackView()
    }
    
    
    private func configureFilterButtons() {
        btnOne.setImage(UIImage(systemName: "slider.horizontal.3"), for: .normal)
        btnTwo.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        btnThree.setImage(UIImage(systemName: "slider.horizontal.3"), for: .normal)
        
        btnOne.tintColor = .gray
        btnTwo.tintColor = .gray
        btnThree.tintColor = .gray
        
        btnOne.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        btnTwo.addTarget(self, action: #selector(clearButtonTapped), for: .touchUpInside)
        btnThree.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    
    private func configureStackView() {
        stack.axis = .horizontal
        stack.addArrangedSubview(btnOne)
        stack.addArrangedSubview(btnTwo)
        btnOne.contentHorizontalAlignment = .left
        btnOne.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            btnOne.widthAnchor.constraint(equalToConstant: 40),
        ])
    }
    
    
    private func configureDataSourse() {
        dataSourse = UICollectionViewDiffableDataSource<Section, Cocktail>(collectionView: collectionView, cellProvider: { collectionView, indexPath, cocktail in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CocktailCell.reuseID, for: indexPath) as! CocktailCell
            cell.layer.cornerRadius = 8
            cell.set(cocktatil: cocktail)
            return cell
        })
    }
    
    func updateData(on cocktails: [Cocktail]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Cocktail>()
        snapshot.appendSections([.main])
        snapshot.appendItems(cocktails)
        DispatchQueue.main.async {
            self.dataSourse.apply(snapshot, animatingDifferences: true)
        }
    }

    private func configureRightViewOfSearchBar() {
        searchController.searchBar.searchTextField.rightView = btnThree
        searchController.searchBar.searchTextField.rightViewMode = .always
    }
    
    
    @objc func buttonTapped() {
        searchController.searchBar.searchTextField.resignFirstResponder()
        filterVC.delegate = self
        filterVC.title = "Фильтры"
        let navigatinController = UINavigationController(rootViewController: filterVC)
        navigatinController.modalPresentationStyle = .pageSheet
        
        if let sheet = navigatinController.sheetPresentationController {
            sheet.detents = [.custom { _ in 480 }]
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
            sheet.prefersEdgeAttachedInCompactHeight = true
            sheet.widthFollowsPreferredContentSizeWhenEdgeAttached = true
        }
        filterVC.rangeSlider.maximumValue = maxProof
        filterVC.rangeSlider.minimumValue = minProof
        filterVC.configureStateOfTheSubmitButton()
        present(navigatinController, animated: true, completion: nil)
    }
    
    
    @objc func clearButtonTapped() {
        searchController.searchBar.text = ""
        searchController.searchBar.searchTextField.rightView = btnThree
    }
}

extension CocktailsLIstVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let activeArray = isSearching ? filteredCocktails : cocktailsToPresent
        let cocktail = activeArray[indexPath.item]
        let destVC = CocktailInfoVC(cocktail: cocktail)
        destVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(destVC, animated: true)
    }
}

extension CocktailsLIstVC: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let filter = searchController.searchBar.text, !filter.isEmpty else {
            filteredCocktails.removeAll()
            isSearching = false
            updateData(on: cocktailsToPresent)
            setNeedsUpdateContentUnavailableConfiguration()
            searchController.searchBar.searchTextField.rightView = btnThree
            return
        }
        
        isSearching = true
        filteredCocktails = cocktailsToPresent.filter { $0.name.lowercased().contains(filter.lowercased())}
        updateData(on: filteredCocktails)
        setNeedsUpdateContentUnavailableConfiguration()
        searchController.searchBar.searchTextField.rightView = stack
    }
}

extension CocktailsLIstVC: FilterDelegate {
    func didPressedButton() {
        minProof = filterVC.minProof
        maxProof = filterVC.maxProof
        
        if minProof != 0 || maxProof != 50 {
            filterButtonIsActive = true
        } else {
            filterButtonIsActive = false
        }
        btnOne.tintColor = filterButtonIsActive ? UIColor(hex: "#FF7F50") : .gray
        btnThree.tintColor = filterButtonIsActive ? UIColor(hex: "#FF7F50") : .gray
        
        cocktailsToPresent = cocktails.filter { $0.proof >= minProof && $0.proof <= maxProof }
        let searchBarText = searchController.searchBar.text ?? ""
        filteredCocktails = cocktailsToPresent.filter { $0.name.lowercased().contains(searchBarText.lowercased()) }
        updateData(on: isSearching ? filteredCocktails : cocktailsToPresent)
        setNeedsUpdateContentUnavailableConfiguration()
    }
}

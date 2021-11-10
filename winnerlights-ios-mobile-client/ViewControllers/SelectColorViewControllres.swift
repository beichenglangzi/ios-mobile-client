//
//  SelectColorViewControllres.swift
//  winnerlights-ios-mobile-client
//
//  Created by human on 2021/11/07.
//

import UIKit

protocol SelectColorViewControllerDelegate{
    func modalDidFinished(array: [Phase], count: Int)
}

class SelectColorViewController: UIViewController {
    let numberOfColumns: CGFloat = 2
    let marginWidth: CGFloat = 20
    let colors: [UIColor] = [.systemRed, .systemBlue, .systemGreen]
    let colorNames: [String] = ["Red", "Blue", "Green"]
    var buttonTag = 0
    var phaseArray: [Phase] = []
    var phaseCount: Int = 0
    
    var delegate: SelectColorViewControllerDelegate! = nil
    
    fileprivate lazy var SelectColorView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(SelectColorViewControllerCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.view.addSubview(SelectColorView)
        setupConstraint()
    }
    
    func setupConstraint() {
        SelectColorView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        SelectColorView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        SelectColorView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        SelectColorView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
}

class SelectColorViewControllerCell: UICollectionViewCell {
    let topMarginWidth: CGFloat = 10
    let bottomMarginWidth: CGFloat = 10
    let cornerRadius: CGFloat = 20
    let shadowOpacity: Float = 0.2
    let marginWidth: CGFloat = 16
    let shadowOffset: CGSize = CGSize(width: 4, height: 4)
    
    fileprivate let previewView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    fileprivate lazy var colorContainerView: UIView = {
        let circle = UIView()
        circle.frame = CGRect(x: self.frame.width / 4, y: self.frame.height / 4, width: self.frame.width / 2, height: self.frame.height / 2)
        circle.backgroundColor = .clear
        circle.layer.cornerRadius = self.frame.width / 4
        circle.layer.borderColor = UIColor.black.cgColor
        circle.layer.borderWidth = 1
        return circle
    }()
    
    fileprivate lazy var colorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        label.textColor = .black
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        previewView.addSubview(colorContainerView)
        contentView.addSubview(previewView)
        contentView.addSubview(colorLabel)
        setupConstraints()
        setupStyles()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupConstraints() {
        colorContainerView.topAnchor.constraint(equalTo: previewView.topAnchor, constant: topMarginWidth).isActive = true
        colorContainerView.leadingAnchor.constraint(equalTo: previewView.leadingAnchor, constant: topMarginWidth).isActive = true
        colorContainerView.trailingAnchor.constraint(equalTo: previewView.trailingAnchor, constant: -topMarginWidth).isActive = true
        colorContainerView.bottomAnchor.constraint(equalTo: previewView.bottomAnchor, constant: -topMarginWidth).isActive = true
        previewView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        previewView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        previewView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        previewView.bottomAnchor.constraint(equalTo: colorLabel.topAnchor).isActive = true
        colorLabel.topAnchor.constraint(equalTo: previewView.bottomAnchor).isActive = true
        colorLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        colorLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        colorLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -bottomMarginWidth).isActive = true
    }
    
    func setupStyles() {
        contentView.layer.cornerRadius = 12
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 30
        contentView.layer.shadowOpacity = 0.2
        contentView.layer.shadowRadius = 12
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOffset = CGSize(width: 4, height: 4)
    }

}

extension SelectColorViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! SelectColorViewControllerCell
        cell.colorContainerView.backgroundColor = colors[indexPath.row]
        cell.colorLabel.text = colorNames[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width-marginWidth)/numberOfColumns
        let height = (collectionView.frame.width-marginWidth)/numberOfColumns
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let sectionInsets = UIEdgeInsets(top: 2.0, left: 5.0, bottom: 2.0, right: 5.0)
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch colors[indexPath.row] {
        case .systemRed:
            phaseArray[phaseCount-1].players[buttonTag].color = .pink
        case .systemBlue:
            phaseArray[phaseCount-1].players[buttonTag].color = .blue
        default:
            break
        }
        self.delegate.modalDidFinished(array: phaseArray, count: phaseCount)
    }
    
}

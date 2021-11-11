//
//  ExerciseCreationViewController.swift
//  winnerlights-ios-mobile-client
//
//  Created by human on 2021/10/04.
//

import UIKit

class ExerciseCreationViewController: UIViewController, UINavigationControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    let numberOfColumns: CGFloat = 2
    let marginWidth: CGFloat = 16
    let cornerRadius: CGFloat = 20
    let shadowOpacity: Float = 0.2
    let shadowOffset: CGSize = CGSize(width: 4, height: 4)
    let topMarginWidth: CGFloat = 10
    let bottomMarginWidth: CGFloat = 10
    let buttonHeight: CGFloat = 60
    var backButtonTappedAt: Float = 0
    
    let dataSourceSecond:[Int] = ([Int])(0...59)
    let dataSourceMinute:[Int] = ([Int])(0...10)
    var dataSourceTotalPhaseCount:[Int] = ([Int])(1...10)
    var dataSourceCurrentPhaseCount:[Int] = ([Int])(1...10)
    let dataSourseColor:[String] = ([String])(arrayLiteral: "Red","Blue")
    let dataSourseExerciseType:[String] = ([String])(arrayLiteral: "Team","Personal")
    var currentPhaseIndex: Int = 0
    
    let vc = SelectColorViewController()
    var exercises_box: [Exercise]!
    
    var totalPhaseCount: Int = 1
    var currentPhaseCount: Int = 1
    var phaseDefalut = Phase(
                duration: 5,
                goals: [
                    Goal(position: .upperLeft, color: .pink),
                    Goal(position: .lowerLeft, color: .pink),
                    Goal(position: .upperRight, color: .blue),
                    Goal(position: .lowerRight, color: .blue),
                ],
                players: [
                    Player(number: .player1, color: .pink),
                    Player(number: .player2, color: .pink),
                    Player(number: .player3, color: .pink),
                    Player(number: .player4, color: .pink),
                    Player(number: .player5, color: .blue),
                    Player(number: .player6, color: .blue),
                    Player(number: .player7, color: .blue),
                    Player(number: .player8, color: .blue),
                ]
            )
    lazy var phaseArray = Array(repeating: phaseDefalut, count: totalPhaseCount)
    var newPhaseArray: [Phase] = [Phase(
                            duration: 5,
                            goals: [
                                Goal(position: .upperLeft, color: .pink),
                                Goal(position: .lowerLeft, color: .pink),
                                Goal(position: .upperRight, color: .blue),
                                Goal(position: .lowerRight, color: .blue),
                            ],
                            players: [
                                Player(number: .player1, color: .pink),
                                Player(number: .player2, color: .pink),
                                Player(number: .player3, color: .pink),
                                Player(number: .player4, color: .pink),
                                Player(number: .player5, color: .blue),
                                Player(number: .player6, color: .blue),
                                Player(number: .player7, color: .blue),
                                Player(number: .player8, color: .blue),
                            ]
                        )
                    ]
    
    var personalPhaseDefalut = Phase(
                duration: 5,
                goals: [
                    Goal(position: .upperLeft, color: .pink),
                    Goal(position: .lowerLeft, color: .pink),
                    Goal(position: .upperRight, color: .blue),
                    Goal(position: .lowerRight, color: .blue),
                ],
                players: [
                    Player(number: .player1, color: .pink),
                    Player(number: .player2, color: .pink),
                    Player(number: .player3, color: .pink),
                    Player(number: .player4, color: .pink),
                    Player(number: .player5, color: .blue),
                ]
            )
    lazy var personalPhaseArray = Array(repeating: personalPhaseDefalut, count: totalPhaseCount)
    
    fileprivate lazy var exerciseTitleTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.frame = .init(x: 0, y: 0, width: 100, height: 16)
        textField.center = view.center
        textField.placeholder = "exercise title"
        textField.keyboardType = .default
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.gray.cgColor
        textField.layer.cornerRadius = 5
        textField.leftView = UIView(frame: .init(x: 0, y: 0, width: 5, height: 0))
        textField.leftViewMode = .always
        return textField
    }()
    
    fileprivate lazy var exerciseDescriptionTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.frame = .init(x: 0, y: 0, width: 100, height: 16)
        textField.center = view.center
        textField.placeholder = "exercise description"
        textField.keyboardType = .default
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.gray.cgColor
        textField.layer.cornerRadius = 5
        textField.leftView = UIView(frame: .init(x: 0, y: 0, width: 5, height: 0))
        textField.leftViewMode = .always
        return textField
    }()
    
    fileprivate lazy var exerciseTypeLabel: UILabel = {
        let label = UILabel()
        label.text = "Exercise Type"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.textAlignment = .center
        label.textColor = .black
        return label
    }()
    
    fileprivate lazy var exerciseTypeRoll: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        pickerView.backgroundColor = .clear
        pickerView.tag = 17
        pickerView.isHidden = true
        pickerView.delegate   = self
        pickerView.dataSource = self
        return pickerView
    }()
    
    fileprivate lazy var exerciseTypeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .white
        button.layer.cornerRadius = cornerRadius
        button.layer.shadowOpacity = shadowOpacity
        button.layer.shadowRadius = cornerRadius
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = shadowOffset
        button.setTitle("Team", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 25)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(pickerViewDisplayexerciseType), for: .touchUpInside)
        return button
    }()
    
    @objc func pickerViewDisplayexerciseType() {
        exerciseTypeButton.isHidden = true
        exerciseTypeRoll.isHidden = false
    }
    
    lazy var pitch: PitchView = {
        let view = PitchView(phase: phaseDefalut)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 6
        view.layer.shadowOpacity = shadowOpacity
        view.layer.shadowRadius = 6
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.borderWidth = 1
        view.layer.shadowOffset = shadowOffset
        return view
    }()
    
    fileprivate lazy var phaseCountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Phase" + " " + "\(String(currentPhaseIndex+1))/\(String(newPhaseArray.count))"
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.textAlignment = .center
        return label
    }()
    
    fileprivate lazy var descriptionContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = cornerRadius
        view.layer.shadowOpacity = shadowOpacity
        view.layer.shadowRadius = cornerRadius
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = shadowOffset
        return view
    }()
    
    fileprivate lazy var descriptionView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = cornerRadius
        view.layer.shadowOpacity = shadowOpacity
        view.layer.shadowRadius = cornerRadius
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = shadowOffset
        return view
    }()
    
    fileprivate lazy var previewContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = cornerRadius
        view.layer.shadowOpacity = shadowOpacity
        view.layer.shadowRadius = cornerRadius
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = shadowOffset
        return view
    }()
    
    fileprivate lazy var previewView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 6
        view.layer.shadowOpacity = shadowOpacity
        view.layer.shadowRadius = 6
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.borderWidth = 1
        view.layer.shadowOffset = shadowOffset
        return view
    }()
    
    fileprivate lazy var progressView: UIProgressView = {
        let view = UIProgressView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 6
        view.layer.shadowOpacity = shadowOpacity
        view.layer.shadowRadius = 6
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = shadowOffset
        view.setProgress(exercises_box[currentPhaseIndex].phases[currentPhaseIndex].duration, animated: true)
        return view
    }()
    
    fileprivate lazy var partitionBarGroupView: PartitionBarGroupView = {
        let view = PartitionBarGroupView(phases: newPhaseArray)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    fileprivate lazy var addButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .white
        button.layer.cornerRadius = cornerRadius
        button.layer.shadowOpacity = shadowOpacity
        button.layer.shadowRadius = cornerRadius
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = shadowOffset
        button.setTitle("Create", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.addTarget(self, action: #selector(createExercise), for: .touchUpInside)
        return button
    }()
    
    @objc func createExercise() {
        let exerciseTitle = exerciseTitleTextField.text!
        let exerciseDecription = exerciseDescriptionTextField.text!
        let newExercise = Exercise(
            title: "\(exerciseTitle)",
            description: "\(exerciseDecription)",
            phases: newPhaseArray
        )
        exercises_box.append(newExercise)
        print("exercises_box", exercises_box.count)
    }
    
    fileprivate lazy var totalDurationTimeLabel: UILabel = {
        let label = UILabel()
        let totalDuration: Float = newPhaseArray.reduce(0.0, {$0 + $1.duration})
        label.text = String(format:"%.0f", (totalDuration/60.0).rounded(.towardZero))+":"+String(format:"%02.0f", floor(totalDuration.truncatingRemainder(dividingBy: 60.0)))
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.textAlignment = .center
        label.textColor = .black
        return label
    }()
    
    fileprivate lazy var phaseTimeRollSecond: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        pickerView.backgroundColor = .clear
        pickerView.tag = 1
        pickerView.isHidden = true
        pickerView.delegate   = self
        pickerView.dataSource = self
        return pickerView
    }()
    
    fileprivate lazy var phaseTimeRollMinute: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        pickerView.backgroundColor = .clear
        pickerView.tag = 2
        pickerView.isHidden = true
        pickerView.delegate   = self
        pickerView.dataSource = self
        return pickerView
    }()
    
    fileprivate lazy var totalPhaseCountRoll: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        pickerView.backgroundColor = .clear
        pickerView.tag = 3
        pickerView.isHidden = true
        pickerView.delegate   = self
        pickerView.dataSource = self
        return pickerView
    }()
    
    fileprivate lazy var currentPhaseCountRoll: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        pickerView.backgroundColor = .clear
        pickerView.tag = 4
        pickerView.isHidden = true
        pickerView.delegate   = self
        pickerView.dataSource = self
        return pickerView
    }()
    
    fileprivate lazy var upperLeftGoalRoll: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        pickerView.backgroundColor = .clear
        pickerView.tag = 5
        pickerView.isHidden = true
        pickerView.delegate   = self
        pickerView.dataSource = self
        return pickerView
    }()
    
    fileprivate lazy var lowerLeftGoalRoll: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        pickerView.backgroundColor = .clear
        pickerView.tag = 6
        pickerView.isHidden = true
        pickerView.delegate   = self
        pickerView.dataSource = self
        return pickerView
    }()
    
    fileprivate lazy var upperRightGoalRoll: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        pickerView.backgroundColor = .clear
        pickerView.tag = 7
        pickerView.isHidden = true
        pickerView.delegate   = self
        pickerView.dataSource = self
        return pickerView
    }()
    
    fileprivate lazy var lowerRightGoalRoll: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        pickerView.backgroundColor = .clear
        pickerView.tag = 8
        pickerView.isHidden = true
        pickerView.delegate   = self
        pickerView.dataSource = self
        return pickerView
    }()
    
    fileprivate lazy var player1Roll: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        pickerView.backgroundColor = .clear
        pickerView.tag = 9
        pickerView.isHidden = true
        pickerView.delegate   = self
        pickerView.dataSource = self
        return pickerView
    }()
    
    fileprivate lazy var player2Roll: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        pickerView.backgroundColor = .clear
        pickerView.tag = 10
        pickerView.isHidden = true
        pickerView.delegate   = self
        pickerView.dataSource = self
        return pickerView
    }()
    
    fileprivate lazy var player3Roll: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        pickerView.backgroundColor = .clear
        pickerView.tag = 11
        pickerView.isHidden = true
        pickerView.delegate   = self
        pickerView.dataSource = self
        return pickerView
    }()
    
    fileprivate lazy var player4Roll: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        pickerView.backgroundColor = .clear
        pickerView.tag = 12
        pickerView.isHidden = true
        pickerView.delegate   = self
        pickerView.dataSource = self
        return pickerView
    }()
    
    fileprivate lazy var player5Roll: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        pickerView.backgroundColor = .clear
        pickerView.tag = 13
        pickerView.isHidden = true
        pickerView.delegate   = self
        pickerView.dataSource = self
        return pickerView
    }()
    
    fileprivate lazy var player6Roll: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        pickerView.backgroundColor = .clear
        pickerView.tag = 14
        pickerView.isHidden = true
        pickerView.delegate   = self
        pickerView.dataSource = self
        return pickerView
    }()
    
    fileprivate lazy var player7Roll: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        pickerView.backgroundColor = .clear
        pickerView.tag = 15
        pickerView.isHidden = true
        pickerView.delegate   = self
        pickerView.dataSource = self
        return pickerView
    }()
    
    fileprivate lazy var player8Roll: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        pickerView.backgroundColor = .clear
        pickerView.tag = 16
        pickerView.isHidden = true
        pickerView.delegate   = self
        pickerView.dataSource = self
        return pickerView
    }()
        
    fileprivate lazy var phaseTimeButtonSecond: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .white
        button.layer.cornerRadius = cornerRadius
        button.layer.shadowOpacity = shadowOpacity
        button.layer.shadowRadius = cornerRadius
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = shadowOffset
        button.setTitle("0", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 25)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(pickerViewDisplaySecond), for: .touchUpInside)
        return button
    }()
        
    @objc func pickerViewDisplaySecond() {
        phaseTimeButtonSecond.isHidden = true
        phaseTimeRollSecond.isHidden = false
    }
    
    fileprivate lazy var phaseTimeButtonMinute: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .white
        button.layer.cornerRadius = cornerRadius
        button.layer.shadowOpacity = shadowOpacity
        button.layer.shadowRadius = cornerRadius
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = shadowOffset
        button.setTitle("1", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 25)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(pickerViewDisplayMinute), for: .touchUpInside)
        return button
    }()
    
    @objc func pickerViewDisplayMinute() {
        phaseTimeButtonMinute.isHidden = true
        phaseTimeRollMinute.isHidden = false
    }
    
    fileprivate lazy var totalPhaseCountButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .white
        button.layer.cornerRadius = cornerRadius
        button.layer.shadowOpacity = shadowOpacity
        button.layer.shadowRadius = cornerRadius
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = shadowOffset
        button.setTitle("1", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 25)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(pickerViewDisplaytotalPhaseCount), for: .touchUpInside)
        return button
    }()
    
    @objc func pickerViewDisplaytotalPhaseCount() {
        totalPhaseCountButton.isHidden = true
        totalPhaseCountRoll.isHidden = false
    }
    
    fileprivate lazy var currentPhaseCountButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .white
        button.layer.cornerRadius = cornerRadius
        button.layer.shadowOpacity = shadowOpacity
        button.layer.shadowRadius = cornerRadius
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = shadowOffset
        button.setTitle("1", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 25)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(pickerViewDisplaycurrentPhaseCount), for: .touchUpInside)
        return button
    }()
    
    @objc func pickerViewDisplaycurrentPhaseCount() {
        currentPhaseCountButton.isHidden = true
        currentPhaseCountRoll.isHidden = false
    }
    
    fileprivate lazy var upperLeftGoalButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
        button.layer.cornerRadius = cornerRadius
        button.layer.shadowOpacity = shadowOpacity
        button.layer.shadowRadius = cornerRadius
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = shadowOffset
        button.addTarget(self, action: #selector(pickerViewDisplayUpperLeftGoalButton), for: .touchUpInside)
        return button
    }()
    
    @objc func pickerViewDisplayUpperLeftGoalButton() {
        upperLeftGoalButton.isHidden = true
        upperLeftGoalRoll.isHidden = false
    }
    
    fileprivate lazy var lowerLeftGoalButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
        button.layer.cornerRadius = cornerRadius
        button.layer.shadowOpacity = shadowOpacity
        button.layer.shadowRadius = cornerRadius
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = shadowOffset
        button.addTarget(self, action: #selector(pickerViewDisplayLowerLeftGoalButton), for: .touchUpInside)
        return button
    }()
    
    @objc func pickerViewDisplayLowerLeftGoalButton() {
        lowerLeftGoalButton.isHidden = true
        lowerLeftGoalRoll.isHidden = false
    }
    
    fileprivate lazy var upperRightGoalButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
        button.layer.cornerRadius = cornerRadius
        button.layer.shadowOpacity = shadowOpacity
        button.layer.shadowRadius = cornerRadius
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = shadowOffset
        button.addTarget(self, action: #selector(pickerViewDisplayUpperRightGoalButton), for: .touchUpInside)
        return button
    }()
    
    @objc func pickerViewDisplayUpperRightGoalButton() {
        upperRightGoalButton.isHidden = true
        upperRightGoalRoll.isHidden = false
    }
    
    fileprivate lazy var lowerRightGoalButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
        button.layer.cornerRadius = cornerRadius
        button.layer.shadowOpacity = shadowOpacity
        button.layer.shadowRadius = cornerRadius
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = shadowOffset
        button.addTarget(self, action: #selector(pickerViewDisplayLowerRightGoalButton), for: .touchUpInside)
        return button
    }()
    
    @objc func pickerViewDisplayLowerRightGoalButton() {
        lowerRightGoalButton.isHidden = true
        lowerRightGoalRoll.isHidden = false
    }
    
    fileprivate lazy var player1Button: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
        button.layer.cornerRadius = cornerRadius
        button.layer.shadowOpacity = shadowOpacity
        button.layer.shadowRadius = cornerRadius
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = shadowOffset
        button.addTarget(self, action: #selector(pickerViewDisplayplayer1), for: .touchUpInside)
        return button
    }()
    
    @objc func pickerViewDisplayplayer1() {
        player1Button.isHidden = true
        player1Roll.isHidden = false
    }
    
    fileprivate lazy var player2Button: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
        button.layer.cornerRadius = cornerRadius
        button.layer.shadowOpacity = shadowOpacity
        button.layer.shadowRadius = cornerRadius
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = shadowOffset
        button.addTarget(self, action: #selector(pickerViewDisplayplayer2), for: .touchUpInside)
        return button
    }()
    
    @objc func pickerViewDisplayplayer2() {
        player2Button.isHidden = true
        player2Roll.isHidden = false
    }
    
    fileprivate lazy var player3Button: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
        button.layer.cornerRadius = cornerRadius
        button.layer.shadowOpacity = shadowOpacity
        button.layer.shadowRadius = cornerRadius
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = shadowOffset
        button.addTarget(self, action: #selector(pickerViewDisplayplayer3), for: .touchUpInside)
        return button
    }()
    
    @objc func pickerViewDisplayplayer3() {
        player3Button.isHidden = true
        player3Roll.isHidden = false
    }
    
    fileprivate lazy var player4Button: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
        button.layer.cornerRadius = cornerRadius
        button.layer.shadowOpacity = shadowOpacity
        button.layer.shadowRadius = cornerRadius
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = shadowOffset
        button.addTarget(self, action: #selector(pickerViewDisplayplayer4), for: .touchUpInside)
        return button
    }()
    
    @objc func pickerViewDisplayplayer4() {
        player4Button.isHidden = true
        player4Roll.isHidden = false
    }
    
    fileprivate lazy var player5Button: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
        button.layer.cornerRadius = cornerRadius
        button.layer.shadowOpacity = shadowOpacity
        button.layer.shadowRadius = cornerRadius
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = shadowOffset
        button.addTarget(self, action: #selector(pickerViewDisplayplayer5), for: .touchUpInside)
        return button
    }()
    
    @objc func pickerViewDisplayplayer5() {
        player5Button.isHidden = true
        player5Roll.isHidden = false
    }
    
    fileprivate lazy var player6Button: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
        button.layer.cornerRadius = cornerRadius
        button.layer.shadowOpacity = shadowOpacity
        button.layer.shadowRadius = cornerRadius
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = shadowOffset
        button.addTarget(self, action: #selector(pickerViewDisplayplayer6), for: .touchUpInside)
        return button
    }()
    
    @objc func pickerViewDisplayplayer6() {
        player6Button.isHidden = true
        player6Roll.isHidden = false
    }
    
    fileprivate lazy var player7Button: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
        button.layer.cornerRadius = cornerRadius
        button.layer.shadowOpacity = shadowOpacity
        button.layer.shadowRadius = cornerRadius
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = shadowOffset
        button.addTarget(self, action: #selector(pickerViewDisplayplayer7), for: .touchUpInside)
        return button
    }()
    
    @objc func pickerViewDisplayplayer7() {
        player7Button.isHidden = true
        player7Roll.isHidden = false
    }
    
    fileprivate lazy var player8Button: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
        button.layer.cornerRadius = cornerRadius
        button.layer.shadowOpacity = shadowOpacity
        button.layer.shadowRadius = cornerRadius
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = shadowOffset
        button.addTarget(self, action: #selector(pickerViewDisplayplayer8), for: .touchUpInside)
        return button
    }()
    
    @objc func pickerViewDisplayplayer8() {
        player8Button.isHidden = true
        player8Roll.isHidden = false
    }
        
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?  {
        switch pickerView.tag {
        case 1:
            return String(dataSourceSecond[row])
        case 3:
            return String(dataSourceTotalPhaseCount[row])
        case 4:
            return String(dataSourceCurrentPhaseCount[row])
        case 5,6,7,8,9,10,11,12:
            return dataSourseColor[row]
        case 17:
            return dataSourseExerciseType[row]
        default:
            return String(dataSourceMinute[row])
        }
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
        
    func rowSize(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView.tag {
        case 1:
            return dataSourceSecond.count
        case 3:
            return dataSourceTotalPhaseCount.count
        case 4:
            return dataSourceCurrentPhaseCount.count
        case 5,6,7,8,9,10,11,12,13,14,15,16:
            return dataSourseColor.count
        case 17:
            return dataSourseExerciseType.count
        default:
            return dataSourceMinute.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView.tag {
        case 1,2:
            if pickerView.tag == 1{
                let selectedValue:Float = Float(dataSourceSecond[row])
                let currentPhaseDuration: Float = newPhaseArray[currentPhaseCount-1].duration
                let newPhaseDuration:Float =  60.0 * floor(currentPhaseDuration/60.0) + selectedValue
                newPhaseArray[currentPhaseCount-1].duration = newPhaseDuration
                phaseTimeButtonSecond.setTitle(String(dataSourceSecond[row]), for: .normal)
                phaseTimeRollSecond.isHidden = true
                phaseTimeButtonSecond.isHidden = false
            }else{
                let selectedValue:Float = Float(dataSourceMinute[row])
                let currentPhaseDuration: Float = newPhaseArray[currentPhaseCount-1].duration
                let remainder = currentPhaseDuration.truncatingRemainder(dividingBy: 60.0)
                let newPhaseDuration:Float = selectedValue * 60.0 + remainder
                newPhaseArray[currentPhaseCount-1].duration = newPhaseDuration
                phaseTimeButtonMinute.setTitle(String(dataSourceMinute[row]), for: .normal)
                phaseTimeRollMinute.isHidden = true
                phaseTimeButtonMinute.isHidden = false
            }
            let totalDuration: Float = newPhaseArray.reduce(0.0, {$0 + $1.duration})
            totalDurationTimeLabel.text = String(format:"%.0f", (totalDuration/60.0).rounded(.towardZero))+":"+String(format:"%02.0f", floor(totalDuration.truncatingRemainder(dividingBy: 60.0)))
            partitionBarGroupView.phases = newPhaseArray
            partitionBarGroupView.setNeedsDisplay()
        case 3:
            totalPhaseCount = dataSourceTotalPhaseCount[row]
            if exerciseTypeButton.currentTitle == "Team" {
                phaseArray = Array(repeating: phaseDefalut, count: totalPhaseCount)
                newPhaseArray = phaseArray
            }
            if exerciseTypeButton.currentTitle == "Personal" {
                personalPhaseArray = Array(repeating: personalPhaseDefalut, count: totalPhaseCount)
                newPhaseArray = personalPhaseArray
            }
            let totalDuration: Float = newPhaseArray.reduce(0.0, {$0 + $1.duration})
            phaseCountLabel.text = "Phase" + " " + "\(String(currentPhaseCount))/\(String(totalPhaseCount))"
            totalDurationTimeLabel.text = String(format:"%.0f", (totalDuration/60.0).rounded(.towardZero))+":"+String(format:"%02.0f", floor(totalDuration.truncatingRemainder(dividingBy: 60.0)))
            partitionBarGroupView.phases = newPhaseArray
            partitionBarGroupView.setNeedsDisplay()
            dataSourceCurrentPhaseCount = ([Int])(1...totalPhaseCount)
            currentPhaseCountRoll.reloadAllComponents()
            totalPhaseCountButton.setTitle(String(dataSourceTotalPhaseCount[row]), for: .normal)
            totalPhaseCountRoll.isHidden = true
            totalPhaseCountButton.isHidden = false
        case 4:
            currentPhaseCount = dataSourceCurrentPhaseCount[row]
            phaseCountLabel.text = "Phase" + " " + "\(String(currentPhaseCount))/\(String(totalPhaseCount))"
            pitch.phase = newPhaseArray[currentPhaseCount-1]
            pitch.setNeedsDisplay()
            currentPhaseCountButton.setTitle(String(dataSourceCurrentPhaseCount[row]), for: .normal)
            currentPhaseCountRoll.isHidden = true
            currentPhaseCountButton.isHidden = false
        case 5:
            switch dataSourseColor[row] {
            case "Red":
                newPhaseArray[currentPhaseCount-1].goals[0].color = .pink
            case "Blue":
                newPhaseArray[currentPhaseCount-1].goals[0].color = .blue
            default:
                break
            }
            pitch.phase = newPhaseArray[currentPhaseCount-1]
            pitch.setNeedsDisplay()
            upperLeftGoalRoll.isHidden = true
            upperLeftGoalButton.isHidden = false
        case 6:
            switch dataSourseColor[row] {
            case "Red":
                newPhaseArray[currentPhaseCount-1].goals[1].color = .pink
            case "Blue":
                newPhaseArray[currentPhaseCount-1].goals[1].color = .blue
            default:
                break
            }
            pitch.phase = newPhaseArray[currentPhaseCount-1]
            pitch.setNeedsDisplay()
            lowerLeftGoalRoll.isHidden = true
            lowerLeftGoalButton.isHidden = false
        case 7:
            switch dataSourseColor[row] {
            case "Red":
                newPhaseArray[currentPhaseCount-1].goals[2].color = .pink
            case "Blue":
                newPhaseArray[currentPhaseCount-1].goals[2].color = .blue
            default:
                break
            }
            pitch.phase = newPhaseArray[currentPhaseCount-1]
            pitch.setNeedsDisplay()
            upperRightGoalRoll.isHidden = true
            upperRightGoalButton.isHidden = false
        case 8:
            switch dataSourseColor[row] {
            case "Red":
                newPhaseArray[currentPhaseCount-1].goals[3].color = .pink
            case "Blue":
                newPhaseArray[currentPhaseCount-1].goals[3].color = .blue
            default:
                break
            }
            pitch.phase = newPhaseArray[currentPhaseCount-1]
            pitch.setNeedsDisplay()
            lowerRightGoalRoll.isHidden = true
            lowerRightGoalButton.isHidden = false
        case 9:
            switch dataSourseColor[row] {
            case "Red":
                newPhaseArray[currentPhaseCount-1].players[0].color = .pink
            case "Blue":
                newPhaseArray[currentPhaseCount-1].players[0].color = .blue
            default:
                break
            }
            pitch.phase = newPhaseArray[currentPhaseCount-1]
            pitch.setNeedsDisplay()
            player1Roll.isHidden = true
            player1Button.isHidden = false
        case 10:
            switch dataSourseColor[row] {
            case "Red":
                newPhaseArray[currentPhaseCount-1].players[1].color = .pink
            case "Blue":
                newPhaseArray[currentPhaseCount-1].players[1].color = .blue
            default:
                break
            }
            pitch.phase = newPhaseArray[currentPhaseCount-1]
            pitch.setNeedsDisplay()
            player2Roll.isHidden = true
            player2Button.isHidden = false
        case 11:
            switch dataSourseColor[row] {
            case "Red":
                newPhaseArray[currentPhaseCount-1].players[2].color = .pink
            case "Blue":
                newPhaseArray[currentPhaseCount-1].players[2].color = .blue
            default:
                break
            }
            pitch.phase = newPhaseArray[currentPhaseCount-1]
            pitch.setNeedsDisplay()
            player3Roll.isHidden = true
            player3Button.isHidden = false
        case 12:
            switch dataSourseColor[row] {
            case "Red":
                newPhaseArray[currentPhaseCount-1].players[3].color = .pink
            case "Blue":
                newPhaseArray[currentPhaseCount-1].players[3].color = .blue
            default:
                break
            }
            pitch.phase = newPhaseArray[currentPhaseCount-1]
            pitch.setNeedsDisplay()
            player4Roll.isHidden = true
            player4Button.isHidden = false
        case 13:
            switch dataSourseColor[row] {
            case "Red":
                newPhaseArray[currentPhaseCount-1].players[4].color = .pink
            case "Blue":
                newPhaseArray[currentPhaseCount-1].players[4].color = .blue
            default:
                break
            }
            pitch.phase = newPhaseArray[currentPhaseCount-1]
            pitch.setNeedsDisplay()
            player5Roll.isHidden = true
            player5Button.isHidden = false
        case 14:
            switch dataSourseColor[row] {
            case "Red":
                newPhaseArray[currentPhaseCount-1].players[5].color = .pink
            case "Blue":
                newPhaseArray[currentPhaseCount-1].players[5].color = .blue
            default:
                break
            }
            pitch.phase = newPhaseArray[currentPhaseCount-1]
            pitch.setNeedsDisplay()
            player6Roll.isHidden = true
            player6Button.isHidden = false
        case 15:
            switch dataSourseColor[row] {
            case "Red":
                newPhaseArray[currentPhaseCount-1].players[6].color = .pink
            case "Blue":
                newPhaseArray[currentPhaseCount-1].players[6].color = .blue
            default:
                break
            }
            pitch.phase = newPhaseArray[currentPhaseCount-1]
            pitch.setNeedsDisplay()
            player7Roll.isHidden = true
            player7Button.isHidden = false
        case 16:
            switch dataSourseColor[row] {
            case "Red":
                newPhaseArray[currentPhaseCount-1].players[7].color = .pink
            case "Blue":
                newPhaseArray[currentPhaseCount-1].players[7].color = .blue
            default:
                break
            }
            pitch.phase = newPhaseArray[currentPhaseCount-1]
            pitch.setNeedsDisplay()
            player8Roll.isHidden = true
            player8Button.isHidden = false
        case 17:
            switch dataSourseExerciseType[row] {
            case "Team":
                phaseArray = Array(repeating: phaseDefalut, count: totalPhaseCount)
                newPhaseArray = phaseArray
            case "Personal":
                personalPhaseArray = Array(repeating: personalPhaseDefalut, count: totalPhaseCount)
                newPhaseArray = personalPhaseArray
            default:
                break
            }
            print("Ω",newPhaseArray[currentPhaseCount-1].players.count)
            pitch.phase = newPhaseArray[currentPhaseCount-1]
            pitch.setNeedsDisplay()
            exerciseTypeButton.setTitle(String(dataSourseExerciseType[row]), for: .normal)
            exerciseTypeRoll.isHidden = true
            exerciseTypeButton.isHidden = false
        default:
            break
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let cellLabel = UILabel()
        cellLabel.frame = CGRect(x: 0, y: 0, width: pickerView.rowSize(forComponent: 0).width, height: pickerView.rowSize(forComponent: 0).height)
        cellLabel.textAlignment = .center
        cellLabel.font = UIFont.boldSystemFont(ofSize: 25)
        cellLabel.backgroundColor = .clear
        cellLabel.textColor = .black
        switch pickerView.tag {
        case 1:
            cellLabel.text = String(dataSourceSecond[row])
            return cellLabel
        case 3:
            cellLabel.text = String(dataSourceTotalPhaseCount[row])
            return cellLabel
        case 4:
            cellLabel.text = String(dataSourceCurrentPhaseCount[row])
            return cellLabel
        case 5,6,7,8,9,10,11,12,13,14,15,16:
            cellLabel.text = dataSourseColor[row]
            return cellLabel
        case 17:
            cellLabel.text = dataSourseExerciseType[row]
            return cellLabel
        default:
            cellLabel.text = String(dataSourceMinute[row])
            return cellLabel
        }
    }
    
    fileprivate lazy var phaseTimeLabel: UILabel = {
        let label = UILabel()
        label.text = "Phase Duration"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.textAlignment = .center
        label.textColor = .black
        return label
    }()
    
    fileprivate lazy var totalPhaseCountLabel: UILabel = {
        let label = UILabel()
        label.text = "Total Phase Count"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.textAlignment = .center
        label.sizeToFit()
        label.textColor = .black
        return label
    }()
    
    fileprivate lazy var currentPhaseCountLabel: UILabel = {
        let label = UILabel()
        label.text = "Current Phase Count"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.textAlignment = .center
        label.sizeToFit()
        label.textColor = .black
        return label
    }()
    
    fileprivate lazy var colonLabel: UILabel = {
        let label = UILabel()
        label.text = ":"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 25, weight: .medium)
        label.textAlignment = .center
        label.textColor = .black
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Create Exercise"
        self.navigationController?.navigationBar.isTranslucent = false
        self.tabBarController?.tabBar.isTranslucent = false
        view.backgroundColor = .white
        descriptionContainerView.addSubview(exerciseTitleTextField)
        descriptionContainerView.addSubview(exerciseDescriptionTextField)
        descriptionContainerView.addSubview(exerciseTypeLabel)
        descriptionContainerView.addSubview(exerciseTypeButton)
        descriptionContainerView.addSubview(exerciseTypeRoll)
        view.addSubview(descriptionContainerView)
        previewContainerView.addSubview(pitch)
        previewContainerView.addSubview(upperLeftGoalButton)
        previewContainerView.addSubview(upperLeftGoalRoll)
        previewContainerView.addSubview(lowerLeftGoalButton)
        previewContainerView.addSubview(lowerLeftGoalRoll)
        previewContainerView.addSubview(upperRightGoalButton)
        previewContainerView.addSubview(upperRightGoalRoll)
        previewContainerView.addSubview(lowerRightGoalButton)
        previewContainerView.addSubview(lowerRightGoalRoll)
        previewContainerView.addSubview(player1Button)
        previewContainerView.addSubview(player1Roll)
        previewContainerView.addSubview(player2Button)
        previewContainerView.addSubview(player2Roll)
        previewContainerView.addSubview(player3Button)
        previewContainerView.addSubview(player3Roll)
        previewContainerView.addSubview(player4Button)
        previewContainerView.addSubview(player4Roll)
        previewContainerView.addSubview(player5Button)
        previewContainerView.addSubview(player5Roll)
        previewContainerView.addSubview(player6Button)
        previewContainerView.addSubview(player6Roll)
        previewContainerView.addSubview(player7Button)
        previewContainerView.addSubview(player7Roll)
        previewContainerView.addSubview(player8Button)
        previewContainerView.addSubview(player8Roll)
        previewContainerView.addSubview(phaseCountLabel)
        previewContainerView.addSubview(progressView)
        previewContainerView.addSubview(partitionBarGroupView)
        previewContainerView.addSubview(totalDurationTimeLabel)
        previewContainerView.addSubview(phaseTimeLabel)
        previewContainerView.addSubview(totalPhaseCountLabel)
        previewContainerView.addSubview(totalPhaseCountButton)
        previewContainerView.addSubview(totalPhaseCountRoll)
        previewContainerView.addSubview(currentPhaseCountLabel)
        previewContainerView.addSubview(currentPhaseCountButton)
        previewContainerView.addSubview(currentPhaseCountRoll)
        previewContainerView.addSubview(phaseTimeButtonSecond)
        previewContainerView.addSubview(phaseTimeRollSecond)
        previewContainerView.addSubview(colonLabel)
        previewContainerView.addSubview(phaseTimeButtonMinute)
        previewContainerView.addSubview(phaseTimeRollMinute)
        view.addSubview(previewContainerView)
        view.addSubview(addButton)
        let phaseDuration: Float = newPhaseArray[0].duration
        let minute: Int = Int(floor(phaseDuration/60.0))
        let second: Int = Int(phaseDuration.truncatingRemainder(dividingBy: 60.0))
        let minuteIndex: Int = dataSourceMinute.firstIndex(of: minute) ?? 0
        let secondIndex:Int = dataSourceSecond.firstIndex(of: second) ?? 0
        phaseTimeRollMinute.selectRow(minuteIndex, inComponent: 0, animated: false)
        phaseTimeButtonMinute.setTitle(String(dataSourceMinute[minuteIndex]), for: .normal)
        phaseTimeRollSecond.selectRow(secondIndex, inComponent: 0, animated: false)
        phaseTimeButtonSecond.setTitle(String(dataSourceSecond[secondIndex]), for: .normal)
        setupConstraints()

        navigationController?.delegate = self
        self.vc.delegate = self
        vc.modalPresentationStyle = .fullScreen
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        pitch.setNeedsDisplay()
    }
    
    func setupConstraints() {
        exerciseTitleTextField.topAnchor.constraint(equalTo: descriptionContainerView.topAnchor, constant: marginWidth*0.5).isActive = true
        exerciseTitleTextField.leadingAnchor.constraint(equalTo: descriptionContainerView.leadingAnchor, constant: marginWidth*5).isActive = true
        exerciseTitleTextField.trailingAnchor.constraint(equalTo: descriptionContainerView.trailingAnchor, constant: -marginWidth*5).isActive = true
        
        exerciseDescriptionTextField.topAnchor.constraint(equalTo: exerciseTitleTextField.bottomAnchor, constant: marginWidth).isActive = true
        exerciseDescriptionTextField.leadingAnchor.constraint(equalTo: descriptionContainerView.leadingAnchor, constant: marginWidth*3).isActive = true
        exerciseDescriptionTextField.trailingAnchor.constraint(equalTo: descriptionContainerView.trailingAnchor, constant: -marginWidth*3).isActive = true
        
        exerciseTypeLabel.topAnchor.constraint(equalTo: exerciseDescriptionTextField.bottomAnchor, constant: marginWidth*2).isActive = true
        exerciseTypeLabel.leadingAnchor.constraint(equalTo: descriptionContainerView.leadingAnchor, constant: marginWidth*3).isActive = true
        
        exerciseTypeButton.leadingAnchor.constraint(equalTo: descriptionContainerView.centerXAnchor, constant: marginWidth*2).isActive = true
        exerciseTypeButton.trailingAnchor.constraint(equalTo: descriptionContainerView.trailingAnchor, constant: -marginWidth*2).isActive = true
        exerciseTypeButton.centerYAnchor.constraint(equalTo: exerciseTypeLabel.centerYAnchor).isActive = true

        exerciseTypeRoll.leadingAnchor.constraint(equalTo: descriptionContainerView.centerXAnchor, constant: marginWidth*2).isActive = true
        exerciseTypeRoll.trailingAnchor.constraint(equalTo: descriptionContainerView.trailingAnchor, constant: -marginWidth*2).isActive = true
        exerciseTypeRoll.centerXAnchor.constraint(equalTo: exerciseTypeButton.centerXAnchor).isActive = true
        exerciseTypeRoll.centerYAnchor.constraint(equalTo: exerciseTypeButton.centerYAnchor).isActive = true
        
        pitch.topAnchor.constraint(equalTo: previewContainerView.topAnchor, constant: marginWidth).isActive = true
        pitch.leadingAnchor.constraint(equalTo: previewContainerView.leadingAnchor, constant: marginWidth).isActive = true
        pitch.trailingAnchor.constraint(equalTo: previewContainerView.trailingAnchor, constant: -marginWidth).isActive = true
        pitch.bottomAnchor.constraint(equalTo: previewContainerView.centerYAnchor).isActive = true
        
        upperLeftGoalButton.centerYAnchor.constraint(equalTo: pitch.centerYAnchor, constant: -marginWidth*3.5).isActive = true
        upperLeftGoalButton.centerXAnchor.constraint(equalTo: pitch.leadingAnchor).isActive = true
        
        upperLeftGoalRoll.leadingAnchor.constraint(equalTo: pitch.leadingAnchor).isActive = true
        upperLeftGoalRoll.trailingAnchor.constraint(equalTo: pitch.centerXAnchor, constant: -marginWidth*5).isActive = true
        upperLeftGoalRoll.centerXAnchor.constraint(equalTo: upperLeftGoalButton.centerXAnchor).isActive = true
        upperLeftGoalRoll.centerYAnchor.constraint(equalTo: upperLeftGoalButton.centerYAnchor, constant: -marginWidth).isActive = true
        
        lowerLeftGoalButton.centerYAnchor.constraint(equalTo: pitch.centerYAnchor, constant: marginWidth*3.5).isActive = true
        lowerLeftGoalButton.centerXAnchor.constraint(equalTo: pitch.leadingAnchor).isActive = true
        
        lowerLeftGoalRoll.leadingAnchor.constraint(equalTo: pitch.leadingAnchor).isActive = true
        lowerLeftGoalRoll.trailingAnchor.constraint(equalTo: pitch.centerXAnchor, constant: -marginWidth*5).isActive = true
        lowerLeftGoalRoll.centerXAnchor.constraint(equalTo: lowerLeftGoalButton.centerXAnchor).isActive = true
        lowerLeftGoalRoll.centerYAnchor.constraint(equalTo: lowerLeftGoalButton.centerYAnchor, constant: marginWidth*1.5).isActive = true
        
        upperRightGoalButton.centerYAnchor.constraint(equalTo: pitch.centerYAnchor, constant: -marginWidth*3.5).isActive = true
        upperRightGoalButton.centerXAnchor.constraint(equalTo: pitch.trailingAnchor).isActive = true
        
        upperRightGoalRoll.leadingAnchor.constraint(equalTo: pitch.centerXAnchor, constant: marginWidth*5).isActive = true
        upperRightGoalRoll.trailingAnchor.constraint(equalTo: pitch.trailingAnchor).isActive = true
        upperRightGoalRoll.centerXAnchor.constraint(equalTo: upperRightGoalButton.centerXAnchor).isActive = true
        upperRightGoalRoll.centerYAnchor.constraint(equalTo: upperRightGoalButton.centerYAnchor, constant: -marginWidth).isActive = true
        
        lowerRightGoalButton.centerYAnchor.constraint(equalTo: pitch.centerYAnchor, constant: marginWidth*3.5).isActive = true
        lowerRightGoalButton.centerXAnchor.constraint(equalTo: pitch.trailingAnchor).isActive = true
        
        lowerRightGoalRoll.leadingAnchor.constraint(equalTo: pitch.centerXAnchor, constant: marginWidth*5).isActive = true
        lowerRightGoalRoll.trailingAnchor.constraint(equalTo: pitch.trailingAnchor).isActive = true
        lowerRightGoalRoll.centerXAnchor.constraint(equalTo: lowerRightGoalButton.centerXAnchor).isActive = true
        lowerRightGoalRoll.centerYAnchor.constraint(equalTo: lowerRightGoalButton.centerYAnchor, constant: marginWidth*1.5).isActive = true
        
        player1Button.centerYAnchor.constraint(equalTo: pitch.centerYAnchor, constant: -marginWidth*1.5).isActive = true
        player1Button.centerXAnchor.constraint(equalTo: pitch.centerXAnchor, constant: -marginWidth*8).isActive = true
        
        player1Roll.leadingAnchor.constraint(equalTo: pitch.leadingAnchor, constant: marginWidth*0.3).isActive = true
        player1Roll.trailingAnchor.constraint(equalTo: pitch.centerXAnchor, constant: -marginWidth*5).isActive = true
        player1Roll.centerXAnchor.constraint(equalTo: player1Button.centerXAnchor).isActive = true
        player1Roll.centerYAnchor.constraint(equalTo: player1Button.centerYAnchor).isActive = true
        
        player2Button.centerYAnchor.constraint(equalTo: pitch.centerYAnchor, constant: -marginWidth*1.5).isActive = true
        player2Button.centerXAnchor.constraint(equalTo: pitch.centerXAnchor, constant: -marginWidth*3.5).isActive = true
        
        player2Roll.leadingAnchor.constraint(equalTo: pitch.leadingAnchor, constant: marginWidth*4.5).isActive = true
        player2Roll.trailingAnchor.constraint(equalTo: pitch.centerXAnchor, constant: -marginWidth*0.5).isActive = true
        player2Roll.centerXAnchor.constraint(equalTo: player2Button.centerXAnchor).isActive = true
        player2Roll.centerYAnchor.constraint(equalTo: player2Button.centerYAnchor).isActive = true
        
        player3Button.centerYAnchor.constraint(equalTo: pitch.centerYAnchor, constant: marginWidth*3).isActive = true
        player3Button.centerXAnchor.constraint(equalTo: pitch.centerXAnchor, constant: -marginWidth*8).isActive = true
        
        player3Roll.leadingAnchor.constraint(equalTo: pitch.leadingAnchor, constant: marginWidth*0.3).isActive = true
        player3Roll.trailingAnchor.constraint(equalTo: pitch.centerXAnchor, constant: -marginWidth*5).isActive = true
        player3Roll.centerXAnchor.constraint(equalTo: player3Button.centerXAnchor).isActive = true
        player3Roll.centerYAnchor.constraint(equalTo: player3Button.centerYAnchor).isActive = true
        
        player4Button.centerYAnchor.constraint(equalTo: pitch.centerYAnchor, constant: marginWidth*3).isActive = true
        player4Button.centerXAnchor.constraint(equalTo: pitch.centerXAnchor, constant: -marginWidth*3.5).isActive = true
        
        player4Roll.leadingAnchor.constraint(equalTo: pitch.leadingAnchor, constant: marginWidth*4.5).isActive = true
        player4Roll.trailingAnchor.constraint(equalTo: pitch.centerXAnchor, constant: -marginWidth*0.5).isActive = true
        player4Roll.centerXAnchor.constraint(equalTo: player4Button.centerXAnchor).isActive = true
        player4Roll.centerYAnchor.constraint(equalTo: player4Button.centerYAnchor).isActive = true
        
        player5Button.centerYAnchor.constraint(equalTo: pitch.centerYAnchor, constant: -marginWidth*1.5).isActive = true
        player5Button.centerXAnchor.constraint(equalTo: pitch.trailingAnchor, constant: -marginWidth*7.5).isActive = true
        
        player5Roll.leadingAnchor.constraint(equalTo: pitch.centerXAnchor, constant: marginWidth*0.5).isActive = true
        player5Roll.trailingAnchor.constraint(equalTo: pitch.centerXAnchor, constant: marginWidth*6.5).isActive = true
        player5Roll.centerXAnchor.constraint(equalTo: player5Button.centerXAnchor).isActive = true
        player5Roll.centerYAnchor.constraint(equalTo: player5Button.centerYAnchor).isActive = true
        
        player6Button.centerYAnchor.constraint(equalTo: pitch.centerYAnchor, constant: -marginWidth*1.5).isActive = true
        player6Button.centerXAnchor.constraint(equalTo: pitch.trailingAnchor, constant: -marginWidth*3).isActive = true
        
        player6Roll.leadingAnchor.constraint(equalTo: pitch.centerXAnchor, constant: marginWidth*5).isActive = true
        player6Roll.trailingAnchor.constraint(equalTo: pitch.trailingAnchor, constant: -marginWidth*0.3).isActive = true
        player6Roll.centerXAnchor.constraint(equalTo: player6Button.centerXAnchor).isActive = true
        player6Roll.centerYAnchor.constraint(equalTo: player6Button.centerYAnchor).isActive = true
        
        player7Button.centerYAnchor.constraint(equalTo: pitch.centerYAnchor, constant: marginWidth*3).isActive = true
        player7Button.centerXAnchor.constraint(equalTo: pitch.trailingAnchor, constant: -marginWidth*7.5).isActive = true
        
        player7Roll.leadingAnchor.constraint(equalTo: pitch.centerXAnchor, constant: marginWidth*0.5).isActive = true
        player7Roll.trailingAnchor.constraint(equalTo: pitch.centerXAnchor, constant: marginWidth*6.5).isActive = true
        player7Roll.centerXAnchor.constraint(equalTo: player7Button.centerXAnchor).isActive = true
        player7Roll.centerYAnchor.constraint(equalTo: player7Button.centerYAnchor).isActive = true
        
        player8Button.centerYAnchor.constraint(equalTo: pitch.centerYAnchor, constant: marginWidth*3).isActive = true
        player8Button.centerXAnchor.constraint(equalTo: pitch.trailingAnchor, constant: -marginWidth*3).isActive = true
        
        player8Roll.leadingAnchor.constraint(equalTo: pitch.centerXAnchor, constant: marginWidth*5).isActive = true
        player8Roll.trailingAnchor.constraint(equalTo: pitch.trailingAnchor, constant: -marginWidth*0.3).isActive = true
        player8Roll.centerXAnchor.constraint(equalTo: player8Button.centerXAnchor).isActive = true
        player8Roll.centerYAnchor.constraint(equalTo: player8Button.centerYAnchor).isActive = true
        
        totalPhaseCountLabel.topAnchor.constraint(equalTo: pitch.bottomAnchor, constant: marginWidth*1.5).isActive = true
        totalPhaseCountLabel.trailingAnchor.constraint(equalTo: previewContainerView.centerXAnchor, constant: marginWidth*0.5).isActive = true
        totalPhaseCountLabel.heightAnchor.constraint(equalToConstant: 15).isActive = true

        totalPhaseCountButton.leadingAnchor.constraint(equalTo: previewContainerView.centerXAnchor, constant: marginWidth*2).isActive = true
        totalPhaseCountButton.trailingAnchor.constraint(equalTo: previewContainerView.trailingAnchor, constant: -marginWidth*2).isActive = true
        totalPhaseCountButton.centerYAnchor.constraint(equalTo: totalPhaseCountLabel.centerYAnchor).isActive = true

        totalPhaseCountRoll.leadingAnchor.constraint(equalTo: previewContainerView.centerXAnchor, constant: marginWidth*2).isActive = true
        totalPhaseCountRoll.trailingAnchor.constraint(equalTo: previewContainerView.trailingAnchor, constant: -marginWidth*2).isActive = true
        totalPhaseCountRoll.centerXAnchor.constraint(equalTo: totalPhaseCountButton.centerXAnchor).isActive = true
        totalPhaseCountRoll.centerYAnchor.constraint(equalTo: totalPhaseCountButton.centerYAnchor).isActive = true
        
        currentPhaseCountLabel.topAnchor.constraint(equalTo: totalPhaseCountLabel.bottomAnchor, constant: marginWidth*2).isActive = true
        currentPhaseCountLabel.trailingAnchor.constraint(equalTo: previewContainerView.centerXAnchor, constant: marginWidth*0.5).isActive = true
        currentPhaseCountLabel.heightAnchor.constraint(equalToConstant: 15).isActive = true

        currentPhaseCountButton.leadingAnchor.constraint(equalTo: previewContainerView.centerXAnchor, constant: marginWidth*2).isActive = true
        currentPhaseCountButton.trailingAnchor.constraint(equalTo: previewContainerView.trailingAnchor, constant: -marginWidth*2).isActive = true
        currentPhaseCountButton.centerYAnchor.constraint(equalTo: currentPhaseCountLabel.centerYAnchor).isActive = true

        currentPhaseCountRoll.leadingAnchor.constraint(equalTo: previewContainerView.centerXAnchor, constant: marginWidth*2).isActive = true
        currentPhaseCountRoll.trailingAnchor.constraint(equalTo: previewContainerView.trailingAnchor, constant: -marginWidth*2).isActive = true
        currentPhaseCountRoll.centerXAnchor.constraint(equalTo: currentPhaseCountButton.centerXAnchor).isActive = true
        currentPhaseCountRoll.centerYAnchor.constraint(equalTo: currentPhaseCountButton.centerYAnchor).isActive = true
        
        phaseCountLabel.topAnchor.constraint(equalTo: currentPhaseCountLabel.bottomAnchor, constant: marginWidth*2).isActive = true
        phaseCountLabel.centerXAnchor.constraint(equalTo: previewContainerView.centerXAnchor).isActive = true
        phaseCountLabel.heightAnchor.constraint(equalToConstant: marginWidth).isActive = true
                
        progressView.leadingAnchor.constraint(equalTo: previewContainerView.leadingAnchor, constant: marginWidth).isActive = true
        progressView.trailingAnchor.constraint(equalTo: previewContainerView.trailingAnchor, constant: -marginWidth).isActive = true
        progressView.topAnchor.constraint(equalTo: phaseCountLabel.bottomAnchor, constant: marginWidth*0.5).isActive = true
        progressView.heightAnchor.constraint(equalToConstant: 10).isActive = true
        
        partitionBarGroupView.centerXAnchor.constraint(equalTo: progressView.centerXAnchor).isActive = true
        partitionBarGroupView.centerYAnchor.constraint(equalTo: progressView.centerYAnchor).isActive = true
        partitionBarGroupView.widthAnchor.constraint(equalTo: progressView.widthAnchor).isActive = true
        partitionBarGroupView.heightAnchor.constraint(equalToConstant: 10).isActive = true
        
        descriptionContainerView.topAnchor.constraint(equalTo: view.topAnchor, constant: marginWidth).isActive = true
        descriptionContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: marginWidth).isActive = true
        descriptionContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -marginWidth).isActive = true
        descriptionContainerView.heightAnchor.constraint(equalToConstant: 140).isActive = true
        
        previewContainerView.topAnchor.constraint(equalTo: descriptionContainerView.bottomAnchor, constant: marginWidth).isActive = true
        previewContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: marginWidth).isActive = true
        previewContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -marginWidth).isActive = true
        
        totalDurationTimeLabel.topAnchor.constraint(equalTo: progressView.bottomAnchor, constant: marginWidth).isActive = true
        totalDurationTimeLabel.trailingAnchor.constraint(equalTo: previewContainerView.trailingAnchor, constant: -marginWidth).isActive = true
        totalDurationTimeLabel.heightAnchor.constraint(equalToConstant: marginWidth).isActive = true
        
        phaseTimeLabel.topAnchor.constraint(equalTo: totalDurationTimeLabel.bottomAnchor, constant: marginWidth).isActive = true
        phaseTimeLabel.trailingAnchor.constraint(equalTo: previewContainerView.centerXAnchor,constant: -marginWidth).isActive = true
        phaseTimeLabel.heightAnchor.constraint(equalToConstant: marginWidth).isActive = true
        
        phaseTimeButtonMinute.leadingAnchor.constraint(equalTo: previewContainerView.centerXAnchor, constant: view.frame.width*0.05).isActive = true
        phaseTimeButtonMinute.trailingAnchor.constraint(equalTo: colonLabel.leadingAnchor, constant: -view.frame.width*0.02).isActive = true
        phaseTimeButtonMinute.centerYAnchor.constraint(equalTo: phaseTimeLabel.centerYAnchor).isActive = true


        phaseTimeRollMinute.leadingAnchor.constraint(equalTo: previewContainerView.centerXAnchor, constant: view.frame.width*0.05).isActive = true
        phaseTimeRollMinute.trailingAnchor.constraint(equalTo: colonLabel.leadingAnchor, constant: -view.frame.width*0.02).isActive = true
        phaseTimeRollMinute.centerXAnchor.constraint(equalTo: phaseTimeButtonMinute.centerXAnchor).isActive = true
        phaseTimeRollMinute.centerYAnchor.constraint(equalTo: phaseTimeButtonMinute.centerYAnchor).isActive = true
        
        colonLabel.trailingAnchor.constraint(equalTo: previewContainerView.trailingAnchor, constant: -view.frame.width*0.22).isActive = true
        colonLabel.centerYAnchor.constraint(equalTo: phaseTimeLabel.centerYAnchor).isActive = true
        
        phaseTimeButtonSecond.leadingAnchor.constraint(equalTo: colonLabel.trailingAnchor, constant: view.frame.width*0.02).isActive = true
        phaseTimeButtonSecond.trailingAnchor.constraint(equalTo: previewContainerView.trailingAnchor, constant: -view.frame.width*0.05).isActive = true
        phaseTimeButtonSecond.centerYAnchor.constraint(equalTo: phaseTimeLabel.centerYAnchor).isActive = true

        phaseTimeRollSecond.leadingAnchor.constraint(equalTo: colonLabel.trailingAnchor, constant: view.frame.width*0.02).isActive = true
        phaseTimeRollSecond.trailingAnchor.constraint(equalTo: previewContainerView.trailingAnchor, constant: -view.frame.width*0.05).isActive = true
        phaseTimeRollSecond.centerXAnchor.constraint(equalTo: phaseTimeButtonSecond.centerXAnchor).isActive = true
        phaseTimeRollSecond.centerYAnchor.constraint(equalTo: phaseTimeButtonSecond.centerYAnchor).isActive = true
        
        addButton.topAnchor.constraint(equalTo: previewContainerView.bottomAnchor, constant: marginWidth*0.5).isActive = true
        addButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 100).isActive = true
        addButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -100).isActive = true
        addButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -marginWidth).isActive = true
        addButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
            if let controller = viewController as? AvairableExercisesViewController {
                controller.exercises = exercises_box
            }
        }
    
    deinit {
            print("Ω ExerciseCreationViewControllerがdeinitされました")
        }
}

extension ExerciseCreationViewController: SelectColorViewControllerDelegate {
        func modalDidFinished(array: [Phase], count: Int) {
            self.currentPhaseCount = count
            self.newPhaseArray = array
            pitch.phase = array[count-1]
            self.vc.dismiss(animated: true, completion: nil)
        }
}


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
    var currentPhaseIndex: Int = 0
    var newPhaseCount: Int = 0
    
    var exercises_box: [Exercise]!
    
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
    
    fileprivate lazy var pitch: PitchView = {
        let view = PitchView(phase: exercises_box[currentPhaseIndex].phases[currentPhaseIndex])
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
        label.text = "Phase" + " " + "\(String(currentPhaseIndex+1))/\(String(exercises_box[currentPhaseIndex].phases.count))"
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
        let view = PartitionBarGroupView(phases: exercises_box[currentPhaseIndex].phases)
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
        let exercise_title = exerciseTitleTextField.text!
        let exercise_decription = exerciseDescriptionTextField.text!
        let phase_count = newPhaseCount
        let phase_defalut = Phase(
                    duration: 5,
                    goals: [
                        Goal(position: .upperLeft, color: .blue),
                        Goal(position: .lowerLeft, color: .blue),
                        Goal(position: .upperRight, color: .pink),
                        Goal(position: .lowerRight, color: .pink),
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
        let phase_array = Array(repeating: phase_defalut, count: phase_count)
        let new_exercise = Exercise(
            title: "\(exercise_title)",
            description: "\(exercise_decription)",
            phases: phase_array
        )
        exercises_box.append(new_exercise)
        print("exercises_box", exercises_box.count)
    }
    
    fileprivate lazy var totalDurationTimeLabel: UILabel = {
        let label = UILabel()
        let totalDuration: Float = exercises_box[currentPhaseIndex].phases.reduce(0.0, {$0 + $1.duration})
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
    
    fileprivate lazy var phaseCountRoll: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        pickerView.backgroundColor = .clear
        pickerView.tag = 3
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
    
    fileprivate lazy var phaseCountButton: UIButton = {
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
        button.addTarget(self, action: #selector(pickerViewDisplayCount), for: .touchUpInside)
        return button
    }()
    
    @objc func pickerViewDisplayCount() {
        phaseCountButton.isHidden = true
        phaseCountRoll.isHidden = false
    }
        
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?  {
        if pickerView.tag ==  1{
            return String(dataSourceSecond[row])
        }else{
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
        if pickerView.tag ==  1{
            return dataSourceSecond.count
        }else{
            return dataSourceMinute.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 1{
            let selectedValue = dataSourceSecond[row]
            newPhaseCount = selectedValue
            phaseTimeButtonSecond.setTitle(String(dataSourceSecond[row]), for: .normal)
            phaseTimeRollSecond.isHidden = true
            phaseTimeButtonSecond.isHidden = false
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let cellLabel = UILabel()
        cellLabel.frame = CGRect(x: 0, y: 0, width: pickerView.rowSize(forComponent: 0).width, height: pickerView.rowSize(forComponent: 0).height)
        cellLabel.textAlignment = .center
        cellLabel.font = UIFont.boldSystemFont(ofSize: 25)
        cellLabel.backgroundColor = .clear
        cellLabel.textColor = .black
        if pickerView.tag == 1{
            cellLabel.text = String(dataSourceSecond[row])
            return cellLabel
        }else{
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
        label.text = "Phase Count"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.textAlignment = .center
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
//        descriptionContainerView.addSubview(exerciseTitle)
        descriptionContainerView.addSubview(exerciseTitleTextField)
        descriptionContainerView.addSubview(exerciseDescriptionTextField)
        view.addSubview(descriptionContainerView)
        previewContainerView.addSubview(pitch)
        previewContainerView.addSubview(phaseCountLabel)
        previewContainerView.addSubview(progressView)
        previewContainerView.addSubview(partitionBarGroupView)
        previewContainerView.addSubview(totalDurationTimeLabel)
        previewContainerView.addSubview(phaseTimeLabel)
//        previewContainerView.addSubview(totalPhaseCountLabel)
//        previewContainerView.addSubview(phaseCountButton)
//        previewContainerView.addSubview(phaseCountRoll)
        previewContainerView.addSubview(phaseTimeButtonSecond)
        previewContainerView.addSubview(phaseTimeRollSecond)
        previewContainerView.addSubview(colonLabel)
        previewContainerView.addSubview(phaseTimeButtonMinute)
        previewContainerView.addSubview(phaseTimeRollMinute)
        view.addSubview(previewContainerView)
        view.addSubview(addButton)
        let phaseDuration: Float = exercises_box[currentPhaseIndex].phases[0].duration
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
    }
    
    func setupConstraints() {
        exerciseTitleTextField.topAnchor.constraint(equalTo: descriptionContainerView.topAnchor, constant: marginWidth*0.5).isActive = true
        exerciseTitleTextField.leadingAnchor.constraint(equalTo: descriptionContainerView.leadingAnchor, constant: marginWidth*5).isActive = true
        exerciseTitleTextField.trailingAnchor.constraint(equalTo: descriptionContainerView.trailingAnchor, constant: -marginWidth*5).isActive = true
        
        exerciseDescriptionTextField.topAnchor.constraint(equalTo: exerciseTitleTextField.bottomAnchor, constant: marginWidth).isActive = true
        exerciseDescriptionTextField.leadingAnchor.constraint(equalTo: descriptionContainerView.leadingAnchor, constant: marginWidth*3).isActive = true
        exerciseDescriptionTextField.trailingAnchor.constraint(equalTo: descriptionContainerView.trailingAnchor, constant: -marginWidth*3).isActive = true
        
        pitch.topAnchor.constraint(equalTo: previewContainerView.topAnchor, constant: marginWidth).isActive = true
        pitch.leadingAnchor.constraint(equalTo: previewContainerView.leadingAnchor, constant: marginWidth).isActive = true
        pitch.trailingAnchor.constraint(equalTo: previewContainerView.trailingAnchor, constant: -marginWidth).isActive = true
        pitch.bottomAnchor.constraint(equalTo: previewContainerView.centerYAnchor).isActive = true
        
        phaseCountLabel.topAnchor.constraint(equalTo: previewContainerView.centerYAnchor, constant: marginWidth*0.5).isActive = true
        phaseCountLabel.centerXAnchor.constraint(equalTo: previewContainerView.centerXAnchor).isActive = true
                
        progressView.leadingAnchor.constraint(equalTo: previewContainerView.leadingAnchor, constant: marginWidth).isActive = true
        progressView.trailingAnchor.constraint(equalTo: previewContainerView.trailingAnchor, constant: -marginWidth).isActive = true
        progressView.topAnchor.constraint(equalTo: phaseCountLabel.bottomAnchor, constant: -marginWidth*0.5).isActive = true
        progressView.bottomAnchor.constraint(equalTo: totalDurationTimeLabel.topAnchor, constant: -marginWidth).isActive = true
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
        
        totalDurationTimeLabel.topAnchor.constraint(equalTo: progressView.bottomAnchor, constant: 8).isActive = true
        totalDurationTimeLabel.trailingAnchor.constraint(equalTo: previewContainerView.trailingAnchor, constant: -marginWidth).isActive = true
        
//        totalPhaseCountLabel.topAnchor.constraint(equalTo: previewContainerView.bottomAnchor, constant: marginWidth*2).isActive = true
//        totalPhaseCountLabel.trailingAnchor.constraint(equalTo: previewContainerView.centerXAnchor,constant: -marginWidth).isActive = true
//        totalPhaseCountLabel.bottomAnchor.constraint(equalTo: previewContainerView.bottomAnchor, constant: -marginWidth*2).isActive = true
        
        phaseTimeLabel.topAnchor.constraint(equalTo: totalDurationTimeLabel.bottomAnchor, constant: marginWidth*2).isActive = true
        phaseTimeLabel.trailingAnchor.constraint(equalTo: previewContainerView.centerXAnchor,constant: -marginWidth).isActive = true
        phaseTimeLabel.bottomAnchor.constraint(equalTo: previewContainerView.bottomAnchor, constant: -marginWidth*2).isActive = true
        
//        phaseCountButton.leadingAnchor.constraint(equalTo: totalPhaseCountLabel.trailingAnchor, constant: view.frame.width*0.05).isActive = true
//        phaseCountButton.trailingAnchor.constraint(equalTo: previewContainerView.centerXAnchor, constant: -view.frame.width*0.02).isActive = true
//        phaseCountButton.bottomAnchor.constraint(equalTo: totalPhaseCountLabel.centerYAnchor).isActive = true
//
//        phaseCountRoll.leadingAnchor.constraint(equalTo: previewContainerView.centerXAnchor, constant: view.frame.width*0.05).isActive = true
//        phaseCountRoll.trailingAnchor.constraint(equalTo: totalPhaseCountLabel.leadingAnchor, constant: -view.frame.width*0.02).isActive = true
//        phaseCountRoll.centerXAnchor.constraint(equalTo: phaseCountButton.centerXAnchor).isActive = true
//        phaseCountRoll.centerYAnchor.constraint(equalTo: phaseCountButton.centerYAnchor).isActive = true
        
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
        
        addButton.topAnchor.constraint(equalTo: previewContainerView.bottomAnchor, constant: marginWidth).isActive = true
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

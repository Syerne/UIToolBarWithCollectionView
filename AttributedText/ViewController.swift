
import UIKit

enum TextStyle: String {
    case normalText = "Body"
    case title = "Title"
    case subtitle = "Subtitle"
}

enum TextFormattingOption {
    case undoRedo
    case textStyle
    case fontStyle
    case list
    case justifyContent
    case spaceIndentation
}

enum UndoRedo {
    case undo
    case redo
}

enum FontStyle {
    case bold
    case italic
    case underline
    case strikethrough
}

enum List {
    case bulletList
    case numberList
    case insertLink
    case attachment
}

enum JustifyContent {
    case alignmentLeft
    case alignmentCenter
    case alignmentRight
    case justifyContent
}

enum SpaceIndentation {
    case decreaseIndent
    case increaseIndent
}

enum OptionType {
    case undo
    case redo
    case normalText
    case title
    case subtitle
    case color
    case bold
    case italic
    case underline
    case strikethrough
    case bulletList
    case numberList
    case insertLink
    case attachment
    case alignmentLeft
    case alignmentCenter
    case alignmentRight
    case justifyContent
    case decreaseIndent
    case increaseIndent
}

class ViewController: UIViewController {
    var sectionsArray: [SectionArray] = []
    private let cellHeight: CGFloat = 40
    private let cellWidth: CGFloat = 40
    private let spacing: CGFloat = 5
    var currentTextStyle: TextStyle = .normalText
    private var selectedTextColor: UIColor = .label
    
    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .roundedRect
        textField.placeholder = "Enter text here"
        return textField
    }()
    
//    private lazy var textView: UITextView = {
//        let textView = UITextView()
//        textView.translatesAutoresizingMaskIntoConstraints = false
//        return textView
//    }()
    
    private lazy var textView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.layer.borderWidth = 1.0
        textView.layer.borderColor = UIColor.systemGray.cgColor
        textView.font = UIFont.systemFont(ofSize: 16)
        return textView
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = spacing
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.contentInsetAdjustmentBehavior = .always
        collectionView.register(UINib(nibName: "CustomCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CustomCollectionViewCell")
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "default")
        collectionView.register(UINib(nibName: "TextStyleCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "TextStyleCollectionViewCell")
        return collectionView
    }()
    
    private var collectionViewBottomConstraint: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.isHidden = true
        var rowArray = [RowArray]()
        rowArray.append(RowArray(optionType: .undo, systemImageName: "arrow.uturn.backward"))
        rowArray.append(RowArray(optionType: .redo, systemImageName: "arrow.uturn.forward"))
        
        sectionsArray.append(SectionArray(sectionType: .undoRedo, rowArray: rowArray))
        rowArray.removeAll()
        
        rowArray.append(RowArray(optionType: .normalText, systemImageName: "person.fill"))
        rowArray.append(RowArray(optionType: .color, systemImageName: "a.square.fill"))
        sectionsArray.append(SectionArray(sectionType: .textStyle, rowArray: rowArray))
        rowArray.removeAll()
        
        rowArray.append(RowArray(optionType: .bold, systemImageName: "bold"))
        rowArray.append(RowArray(optionType: .italic, systemImageName: "italic"))
        rowArray.append(RowArray(optionType: .underline, systemImageName: "underline"))
        rowArray.append(RowArray(optionType: .strikethrough, systemImageName: "strikethrough"))
        sectionsArray.append(SectionArray(sectionType: .fontStyle, rowArray: rowArray))
        rowArray.removeAll()
        
        rowArray.append(RowArray(optionType: .numberList, systemImageName: "list.number"))
        rowArray.append(RowArray(optionType: .bulletList, systemImageName: "list.bullet"))
        rowArray.append(RowArray(optionType: .insertLink, systemImageName: "link"))
        rowArray.append(RowArray(optionType: .attachment, systemImageName: "photo"))
        sectionsArray.append(SectionArray(sectionType: .list, rowArray: rowArray))
        rowArray.removeAll()
        
        rowArray.append(RowArray(optionType: .alignmentLeft, systemImageName: "text.alignleft"))
        rowArray.append(RowArray(optionType: .alignmentCenter, systemImageName: "text.aligncenter"))
        rowArray.append(RowArray(optionType: .alignmentRight, systemImageName: "text.alignright"))
        rowArray.append(RowArray(optionType: .justifyContent, systemImageName: "text.justify"))
        sectionsArray.append(SectionArray(sectionType: .justifyContent,rowArray: rowArray))
        rowArray.removeAll()
        
        rowArray.append(RowArray(optionType: .decreaseIndent, systemImageName: "decrease.indent"))
        rowArray.append(RowArray(optionType: .increaseIndent, systemImageName: "increase.indent"))
        sectionsArray.append(SectionArray(sectionType: .spaceIndentation, rowArray: rowArray))
        setupTextField()
        setupCollectionView()
        addKeyboardObservers()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeKeyboardObservers()
    }
}

// Extension for UICollectionViewDataSource and UICollectionViewDelegate methods
extension ViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sectionsArray[section].rowArray?.count ?? 0
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sectionsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let header = sectionsArray[indexPath.section]
        guard let row = header.rowArray?[indexPath.row] else { return UICollectionViewCell() }
        //        guard let imageCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCollectionViewCell", for: indexPath) as? CustomCollectionViewCell else {
        //            return UICollectionViewCell()
        //        }
        //        imageCell.backgroundColor = .systemGray6
        //        imageCell.systemImageDamru.image = UIImage(systemName: row.systemImageName ?? "")
        //        imageCell.systemImageDamru.tintColor = .label
        //        return imageCell
        
        // Check sectionType and optionType to determine which cell to dequeue
        switch (header.sectionType, row.optionType) {
        case (.textStyle, .normalText):
            guard let textCell = collectionView.dequeueReusableCell(withReuseIdentifier: "TextStyleCollectionViewCell", for: indexPath) as? TextStyleCollectionViewCell else {
                return UICollectionViewCell()
            }
            textCell.backgroundColor = .systemGray6
            textCell.textFontStyleLabel.text = currentTextStyle.rawValue
            return textCell
        default:
            guard let imageCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCollectionViewCell", for: indexPath) as? CustomCollectionViewCell else {
                return UICollectionViewCell()
            }
            imageCell.backgroundColor = .systemGray6
            imageCell.systemImageDamru.image = UIImage(systemName: row.systemImageName ?? "")
            imageCell.systemImageDamru.tintColor = .label
            return imageCell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let header = sectionsArray[indexPath.section]
        guard let row = header.rowArray?[indexPath.row] else { return .zero }
        
        switch (header.sectionType, row.optionType) {
        case (.textStyle, .normalText):
            return CGSize(width: 100, height: cellHeight)
        default:
            return CGSize(width: cellWidth, height: cellHeight)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let header = sectionsArray[indexPath.section]
        guard let row = header.rowArray?[indexPath.row] else { return }
        if header.sectionType == .textStyle, row.optionType == .normalText {
            switch currentTextStyle {
            case .normalText:
                currentTextStyle = .title
            case .title:
                currentTextStyle = .subtitle
            case .subtitle:
                currentTextStyle = .normalText
            }
            // Reload the cell to update the displayed text
            collectionView.reloadItems(at: [indexPath])
        }
        switch row.optionType {
        case .undo:
            print("Undo tapped")
        case .redo:
            print("Redo tapped")
        case .normalText:
            print("Normal Text tapped")
        case .title:
            print("Title tapped")
        case .subtitle:
            print("Subtitle tapped")
        case .color:
            selectColor()
        case .bold:
            print("Bold tapped")
        case .italic:
            print("Italic tapped")
        case .underline:
            print("Underline tapped")
        case .strikethrough:
            print("Strikethrough tapped")
        case .bulletList:
            print("Bullet List tapped")
        case .numberList:
            print("Number List tapped")
        case .insertLink:
            print("Insert Link tapped")
        case .attachment:
            presentAttachmentSheet()
        case .alignmentLeft:
            print("Alignment Left tapped")
        case .alignmentCenter:
            print("Alignment Center tapped")
        case .alignmentRight:
            print("Alignment Right tapped")
        case .justifyContent:
            print("Justify Content tapped")
        case .decreaseIndent:
            print("Decrease Indent tapped")
        case .increaseIndent:
            print("Increase Indent tapped")
        case .none:
            break
        }
    }
}

extension ViewController {
    func addKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func removeKeyboardObservers() {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        collectionView.isHidden = false
//        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        let keyboardFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as AnyObject).cgRectValue
//                let keyboardDuration = (notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as AnyObject).doubleValue
//                containerViewBottomAnchor?.constant = -keyboardFrame!.height
//        let collectionViewBottom = collectionView.frame.origin.y + collectionView.frame.height
//        let keyboardTop = keyboardFrame.origin.y
        
//        if collectionViewBottom > keyboardTop {
//            let offset = collectionViewBottom - keyboardTop
            collectionViewBottomConstraint?.constant = -keyboardFrame!.height
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
//        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        collectionView.isHidden = true
        collectionViewBottomConstraint?.constant = 0
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }

    private func setupTextField() {
//        view.addSubview(textField)
//        NSLayoutConstraint.activate([
//            textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
//            textField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
//            textField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20)
//        ])
        view.addSubview(textView)
        NSLayoutConstraint.activate([
            textView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            textView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            textView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20)
        ])
    }
    
    private func setupCollectionView() {
        view.addSubview(collectionView)
        collectionViewBottomConstraint =
        collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0)
        
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            collectionView.topAnchor.constraint(equalTo: textView.bottomAnchor, constant: 10),
            collectionView.heightAnchor.constraint(equalToConstant: 50),
            collectionViewBottomConstraint!
        ])
    }
    
    private func selectColor() {
        print(#function)
        let colorVC = UIColorPickerViewController()
        colorVC.delegate = self
        present(colorVC, animated: true)
    }
    
    private func presentAttachmentSheet() {
        print(#function)
        let attachmentAlert = UIAlertController()
        attachmentAlert.addAction(UIAlertAction(title: "Take photo", style: .default, handler: { action in
            print("Take Photo")
        }))
        attachmentAlert.addAction(UIAlertAction(title: "Choose from gallery", style: .default, handler: { action in
            print("Choose From Gallery")
        }))
        attachmentAlert.addAction(UIAlertAction(title: "Insert image link", style: .default, handler: { action in
            print("Insert image link")
            let insertImageLinkAlertVC = UIAlertController(title: "Insert image link", message: nil, preferredStyle: .alert)
            insertImageLinkAlertVC.addTextField { textField in
                textField.placeholder = "Paste image link"
                textField.delegate = self
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { action in
                print("Cancel")
            }
            let okAction = UIAlertAction(title: "Ok", style: .default) { action in
                if let textField = insertImageLinkAlertVC.textFields?.first {
                   if let enteredText = textField.text {
                        print("User eneterd Link: \(enteredText)")
                   }
                }
            }
            insertImageLinkAlertVC.addAction(cancelAction)
            insertImageLinkAlertVC.addAction(okAction)
            self.present(insertImageLinkAlertVC, animated: true, completion: nil)
        }))
        attachmentAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
            print("Cancel")
        }))
        self.present(attachmentAlert, animated: true, completion: nil)
    }
}

extension ViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        // Check if there is text in the text field
        if let text = textField.text, !text.isEmpty {
            textField.clearButtonMode = .whileEditing
        } else {
            textField.clearButtonMode = .never
        }
    }
}



extension ViewController: UIColorPickerViewControllerDelegate {
    func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
        selectedTextColor = viewController.selectedColor
        textView.textColor = selectedTextColor
    }
}

struct SectionArray {
    var sectionType: TextFormattingOption?
    var rowArray: [RowArray]?
}

struct RowArray {
    var optionType: OptionType?
    var systemImageName: String?
}


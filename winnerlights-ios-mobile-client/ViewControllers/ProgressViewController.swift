/*
* Copyright (c) 2019, Nordic Semiconductor
* All rights reserved.
*
* Redistribution and use in source and binary forms, with or without modification,
* are permitted provided that the following conditions are met:
*
* 1. Redistributions of source code must retain the above copyright notice, this
*    list of conditions and the following disclaimer.
*
* 2. Redistributions in binary form must reproduce the above copyright notice, this
*    list of conditions and the following disclaimer in the documentation and/or
*    other materials provided with the distribution.
*
* 3. Neither the name of the copyright holder nor the names of its contributors may
*    be used to endorse or promote products derived from this software without
*    specific prior written permission.
*
* THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
* ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
* WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
* IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
* INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
* NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
* PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
* WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
* ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
* POSSIBILITY OF SUCH DAMAGE.
*/

import UIKit
import nRFMeshProvision

class ProgressViewController: UIViewController {
    
    // MARK: - Properties
    
    private var alert: UIAlertController?
    private var messageHandle: MessageHandle?
    
    // MARK: - Implementation
    
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        super.dismiss(animated: flag, completion: completion)
        
        if #available(iOS 13.0, *) {
            if let presentationController = self.parent?.presentationController {
                presentationController.delegate?.presentationControllerDidDismiss?(presentationController)
            }
        }
    }
    
    /// Displays the progress alert with specified status message
    /// and calls the completion callback.
    ///
    /// - parameter message: Message to be displayed to the user.
    /// - parameter completion: A completion handler.
    func start(_ message: String, completion: @escaping (() -> Void)) {
        DispatchQueue.main.async {
            if self.alert == nil {
                self.alert = UIAlertController(title: "Status", message: message, preferredStyle: .alert)
                self.alert!.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {
                    _ in self.alert = nil
                }))
                self.present(self.alert!, animated: true)
            } else {
                self.alert?.message = message
            }
            
            completion()
        }
    }
    
    /// Displays the progress alert with specified status message
    /// and calls the completion callback.
    ///
    /// - parameter message: Message to be displayed to the user.
    /// - parameter completion: A completion handler.
    func start(_ message: String, completion: @escaping (() throws -> MessageHandle?)) {
        DispatchQueue.main.async {
            do {
                self.messageHandle = try completion()
                print("self.messageHandle", self.messageHandle)
                guard let _ = self.messageHandle else {
                    self.done()
                    return
                }

                if self.alert == nil {
                    self.alert = UIAlertController(title: "Status", message: message, preferredStyle: .alert)
                    self.alert!.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
                        self.messageHandle?.cancel()
                        self.alert = nil
                    }))
                    self.present(self.alert!, animated: true)
                } else {
                    self.alert?.message = message
                }
            } catch {
                print("catch!!!")
                let completition: () -> Void = {
                    self.alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                    self.alert!.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { _ in
                        self.alert = nil
                    }))
                }
                if self.alert != nil {
                    self.alert?.dismiss(animated: true, completion: completition)
                } else {
                    completition()
                }
            }
        }
    }
    
    /// This method dismisses the progress alert dialog.
    ///
    /// - parameter completion: An optional completion handler.
    func done(completion: (() -> Void)? = nil) {
        print("done called")
        if let alert = alert {
            DispatchQueue.main.async {
                alert.dismiss(animated: true, completion: completion)
            }
        } else {
            DispatchQueue.main.async {
                completion?()
            }
        }
        alert = nil
    }
    
}

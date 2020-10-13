//
//  SlideInPresentationManager.swift
//  TeachUs
//
//  Created by iOS on 14/10/20.
//  Copyright © 2020 TeachUs. All rights reserved.
//

import UIKit

enum PresentationDirection {
  case left
  case top
  case right
  case bottom
}

final class SlideInPresentationManager: NSObject {
  // MARK: - Properties
  var direction: PresentationDirection = .left
  var disableCompactHeight = false
}

// MARK: - UIViewControllerTransitioningDelegate
extension SlideInPresentationManager: UIViewControllerTransitioningDelegate {
  func presentationController(
    forPresented presented: UIViewController,
    presenting: UIViewController?,
    source: UIViewController
  ) -> UIPresentationController? {
    let presentationController = SlideInPresentationController(
      presentedViewController: presented,
      presenting: presenting,
      direction: direction
    )
    presentationController.delegate = self
    return presentationController
  }

  func animationController(
    forPresented presented: UIViewController,
    presenting: UIViewController,
    source: UIViewController
  ) -> UIViewControllerAnimatedTransitioning? {
    return SlideInPresentationAnimator(direction: direction, isPresentation: true)
  }

  func animationController(
    forDismissed dismissed: UIViewController
  ) -> UIViewControllerAnimatedTransitioning? {
    return SlideInPresentationAnimator(direction: direction, isPresentation: false)
  }
}

// MARK: - UIAdaptivePresentationControllerDelegate
extension SlideInPresentationManager: UIAdaptivePresentationControllerDelegate {
  func adaptivePresentationStyle(
    for controller: UIPresentationController,
    traitCollection: UITraitCollection
  ) -> UIModalPresentationStyle {
    if traitCollection.verticalSizeClass == .compact && disableCompactHeight {
      return .overFullScreen
    } else {
      return .none
    }
  }
}

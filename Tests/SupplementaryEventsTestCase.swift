//
//  SupplementaryEventsTestCase.swift
//  DTCollectionViewManager
//
//  Created by Denys Telezhkin on 31.10.15.
//  Copyright © 2015 Denys Telezhkin. All rights reserved.
//

import XCTest
import DTModelStorage
import Nimble
import DTCollectionViewManager

class ReactingSupplementaryCollectionController: DTSupplementaryTestCollectionController
{
    var indexPath : NSIndexPath?
    var model: Int?
    var text : String?
    
    func headerConfiguration(header: ReactingHeaderFooterView, model: String, sectionIndex: Int) {
        header.model = "Foo"
        header.sectionIndex = sectionIndex
    }
    
    func footerConfiguration(footer: ReactingHeaderFooterView, model: String, sectionIndex: Int) {
        footer.model = "Bar"
        footer.sectionIndex = sectionIndex
    }
    
    func supplementaryConfiguration(supplementary: ReactingHeaderFooterView, model: String, sectionIndex: Int) {
        supplementary.model = "FooBar"
        supplementary.sectionIndex = sectionIndex
    }
}

class SupplementaryEventsTestCase: XCTestCase {
    
    var controller: ReactingSupplementaryCollectionController!
    
    override func setUp() {
        super.setUp()
        controller = ReactingSupplementaryCollectionController()
        let _ = controller.view
        controller.manager.startManagingWithDelegate(controller)
        controller.manager.viewBundle = NSBundle(forClass: self.dynamicType)
        controller.manager.memoryStorage.configureForCollectionViewFlowLayoutUsage()
    }
    
    func testHeaderMappingFromHeaderFooterView()
    {
        controller.manager.registerHeaderClass(ReactingHeaderFooterView)
        (controller.collectionView?.collectionViewLayout as? UICollectionViewFlowLayout)?.headerReferenceSize = CGSize(width: 320, height: 50)
        controller.manager.configureHeader(ReactingHeaderFooterView.self) { header, model, index in
            header.model = "FooBar"
        }
        controller.manager.memoryStorage.setSectionHeaderModels(["1"])

        controller.collectionView?.performBatchUpdates(nil, completion: nil)
        
        let view = controller.manager.collectionView(controller.collectionView!, viewForSupplementaryElementOfKind: UICollectionElementKindSectionHeader, atIndexPath:  indexPath(0, 0))
        
        expect((view as? ReactingHeaderFooterView)?.model) == "FooBar"
    }
    
    func testFooterMappingFromHeaderFooterView()
    {
        controller.manager.registerFooterClass(ReactingHeaderFooterView)
        (controller.collectionView?.collectionViewLayout as? UICollectionViewFlowLayout)?.footerReferenceSize = CGSize(width: 320, height: 50)
        controller.manager.configureFooter(ReactingHeaderFooterView.self) { footer, model, index in
            footer.model = "FooBar"
        }
        controller.manager.memoryStorage.setSectionFooterModels(["1"])
        
        controller.collectionView?.performBatchUpdates(nil, completion: nil)
        
        let view = controller.manager.collectionView(controller.collectionView!, viewForSupplementaryElementOfKind: UICollectionElementKindSectionFooter, atIndexPath:  indexPath(0, 0))
        
        expect((view as? ReactingHeaderFooterView)?.model) == "FooBar"
    }
    
    func testHeaderConfigurationMethodPointer()
    {
        controller.manager.registerHeaderClass(ReactingHeaderFooterView)
        (controller.collectionView?.collectionViewLayout as? UICollectionViewFlowLayout)?.headerReferenceSize = CGSize(width: 320, height: 50)
        controller.manager.headerConfiguration(ReactingSupplementaryCollectionController.self.headerConfiguration)
        controller.manager.memoryStorage.setSectionHeaderModels(["1"])
        
        controller.collectionView?.performBatchUpdates(nil, completion: nil)
        
        let view = controller.manager.collectionView(controller.collectionView!, viewForSupplementaryElementOfKind: UICollectionElementKindSectionHeader, atIndexPath:  indexPath(0, 0))
        
        expect((view as? ReactingHeaderFooterView)?.model) == "Foo"
    }
    
    func testFooterConfigurationMethodPointer()
    {
        controller.manager.registerFooterClass(ReactingHeaderFooterView)
        (controller.collectionView?.collectionViewLayout as? UICollectionViewFlowLayout)?.footerReferenceSize = CGSize(width: 320, height: 50)
        controller.manager.footerConfiguration(ReactingSupplementaryCollectionController.self.footerConfiguration)
        controller.manager.memoryStorage.setSectionFooterModels(["1"])
        
        controller.collectionView?.performBatchUpdates(nil, completion: nil)
        
        let view = controller.manager.collectionView(controller.collectionView!, viewForSupplementaryElementOfKind: UICollectionElementKindSectionFooter, atIndexPath:  indexPath(0, 0))
        
        expect((view as? ReactingHeaderFooterView)?.model) == "Bar"
    }
}

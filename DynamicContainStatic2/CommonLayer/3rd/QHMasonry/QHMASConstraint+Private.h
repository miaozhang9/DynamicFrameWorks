//
//  QHMASConstraint+Private.h
//  Masonry
//
//  Created by Nick Tymchenko on 29/04/14.
//  Copyright (c) 2014 cloudling. All rights reserved.
//

#import "QHMASConstraint.h"

@protocol QHMASConstraintDelegate;


@interface QHMASConstraint ()

/**
 *  Whether or not to check for an existing constraint instead of adding constraint
 */
@property (nonatomic, assign) BOOL updateExisting;

/**
 *	Usually QHMASConstraintMaker but could be a parent QHMASConstraint
 */
@property (nonatomic, weak) id<QHMASConstraintDelegate> delegate;

/**
 *  Based on a provided value type, is equal to calling:
 *  NSNumber - setOffset:
 *  NSValue with CGPoint - setPointOffset:
 *  NSValue with CGSize - setSizeOffset:
 *  NSValue with QHMASEdgeInsets - setInsets:
 */
- (void)setLayoutConstantWithValue:(NSValue *)value;

@end


@interface QHMASConstraint (Abstract)

/**
 *	Sets the constraint relation to given NSLayoutRelation
 *  returns a block which accepts one of the following:
 *    QHMASViewAttribute, UIView, NSValue, NSArray
 *  see readme for more details.
 */
- (QHMASConstraint * (^)(id, NSLayoutRelation))equalToWithRelation;

/**
 *	Override to set a custom chaining behaviour
 */
- (QHMASConstraint *)addConstraintWithLayoutAttribute:(NSLayoutAttribute)layoutAttribute;

@end


@protocol QHMASConstraintDelegate <NSObject>

/**
 *	Notifies the delegate when the constraint needs to be replaced with another constraint. For example
 *  A QHMASViewConstraint may turn into a QHMASCompositeConstraint when an array is passed to one of the equality blocks
 */
- (void)constraint:(QHMASConstraint *)constraint shouldBeReplacedWithConstraint:(QHMASConstraint *)replacementConstraint;

- (QHMASConstraint *)constraint:(QHMASConstraint *)constraint addConstraintWithLayoutAttribute:(NSLayoutAttribute)layoutAttribute;

@end

//
//  UIKeyboardView.m
//
//
//  Created by  YFengchen on 13-1-4.
//  Copyright 2013 __zhongyan__. All rights reserved.
//

#import "UIKeyboardView.h"


@implementation UIKeyboardView

@synthesize delegate = _delegate;

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
		keyboardToolbar = [[UIToolbar alloc] initWithFrame:frame];
		
        keyboardToolbar.barStyle = UIBarStyleDefault;
		//keyboardToolbar.barStyle = UIBarStyleBlackTranslucent;
        //[keyboardToolbar setTintColor:[ModelManager colorFromHexString:@"A4E6EF"]];
        
		UIBarButtonItem *previousBarItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"  <  ", @"")
																			style:UIBarButtonItemStylePlain
																		   target:self
																		   action:@selector(toolbarButtonTap:)];
       // A4E6EF
        
        //[previousBarItem setTintColor:[ModelManager colorFromHexString:@"A4E6EF"]];
		previousBarItem.tag=1;
		
		UIBarButtonItem *nextBarItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"  >  ", @"")
																		style:UIBarButtonItemStylePlain
																	   target:self
																	   action:@selector(toolbarButtonTap:)];
        
       // [nextBarItem setTintColor:[ModelManager colorFromHexString:@"A4E6EF"]];
		nextBarItem.tag=2;
		
		UIBarButtonItem *spaceBarItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
																					  target:nil
																					  action:nil];
		
		UIBarButtonItem *doneBarItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Done", @"")
																		style:UIBarButtonItemStylePlain
																	   target:self
																	   action:@selector(toolbarButtonTap:)];
        //[doneBarItem setTintColor:[ModelManager colorFromHexString:@"A4E6EF"]];
		doneBarItem.tag=3;
		
		[keyboardToolbar setItems:[NSArray arrayWithObjects:previousBarItem, nextBarItem, spaceBarItem, doneBarItem, nil]];
       // [keyboardToolbar setItems:[NSArray arrayWithObjects: spaceBarItem, doneBarItem, nil]];
		//[previousBarItem release];
		//[nextBarItem release];
		//[spaceBarItem release];
		//[doneBarItem release];
		[self addSubview:keyboardToolbar];
		//[keyboardToolbar release];
    }
    return self;
}

- (void)toolbarButtonTap:(UIButton *)button {
	if ([self.delegate respondsToSelector:@selector(toolbarButtonTap:)]) {
		[self.delegate toolbarButtonTap:button];
	}
}

@end

@implementation UIKeyboardView (UIKeyboardViewAction)

//根据index找出对应的UIBarButtonItem
- (UIBarButtonItem *)itemForIndex:(NSInteger)itemIndex {
	if (itemIndex < [[keyboardToolbar items] count]) {
		return [[keyboardToolbar items] objectAtIndex:itemIndex];
	}
	return nil;
}

@end

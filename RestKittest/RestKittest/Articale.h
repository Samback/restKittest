//
//  Articale.h
//  RestKittest
//
//  Created by Max on 14.02.13.
//  Copyright (c) 2013 Max Tymchii. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Author.h"

@interface Articale : NSObject
@property (nonatomic, copy) NSString* title;
@property (nonatomic, copy) NSString* body;
@property (nonatomic, strong) Author* author;
@property (nonatomic, strong) NSDate* publicationDate;
@end

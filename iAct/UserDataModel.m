//
//  UserDataModel.m
//  iAct
//
//  Created by Giovanni Paolo Coia on 02/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UserDataModel.h"

@interface UserDataModel ()

@property (strong, nonatomic) NSMutableArray *thoughtArray;

@end

@implementation UserDataModel




@synthesize thoughtArray = _thoughtArray;


//custom getter for program stack. this is to prevent nils and does some lazyinstantiation
- (NSMutableArray *)thoughtArray
{
    if (_thoughtArray == nil) _thoughtArray = [[NSMutableArray alloc] init]; //lazy instantiation
    return _thoughtArray;
}

#pragma mark add/remove/count thoughts in model

//add thought to array
- (void)addThought:(ThoughtInstance *)thought {
    [self.thoughtArray addObject:thought];
}

//get total number of thoughts
- (int)getThoughtCount {
    return self.thoughtArray.count;
}

- (ThoughtInstance *)getThought:(int)thoughtIndex {
    return [self.thoughtArray objectAtIndex:thoughtIndex];
}

#pragma mark Save/Load/Delete model to disk

- (void)saveModelToDisk {
    
    NSString *thoughtFile = [self getFileName];
    
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:_thoughtArray forKey:@"Data"];
    [archiver finishEncoding];
    
    //need different file names for different users, in case two users use the same phone
    [data writeToFile:thoughtFile atomically:YES];
}
- (void)loadModelFromDisk {
    
    NSString *thoughtFile = [self getFileName];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:thoughtFile]) {
        NSData *data = [[NSMutableData alloc]initWithContentsOfFile:thoughtFile];
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc]initForReadingWithData:data];
        _thoughtArray = [unarchiver decodeObjectForKey:@"Data"];
        [unarchiver finishDecoding];
    }
}

- (void)deleteModelFromDisk {
    
    NSString *thoughtFile=[self getFileName];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:thoughtFile]) {
        [[NSFileManager defaultManager] removeItemAtPath:thoughtFile error:nil];
    }
}


//need different file names for different users, in case two users use the same phone
//therefore I am appending user email to start of save files.
- (NSString *) getFileName {
    NSString *docDir=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *username = [userDefaults objectForKey:@"username"];
    NSString *filename = [username stringByAppendingString:@"thoughtfile.archive"];
    NSString *thoughtFile=[docDir stringByAppendingPathComponent:filename];
    return thoughtFile;
}

#pragma mark NSCoding methods
- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_thoughtArray forKey:@"thoughtArray"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if(self = [super init]) {
        _thoughtArray = [aDecoder decodeObjectForKey:@"thoughtArray"];
    }
    return self;
}


@end

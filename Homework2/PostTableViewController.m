//
//  PostTableViewController.m
//  Homework2
//
//  Created by Frazier Moore on 2/13/14.
//  Copyright (c) 2014 Frazier Moore. All rights reserved.
//

#import "PostTableViewController.h"
#import "Post.h"
#import "PostTableViewCell.h"
#import "PostDetailViewController.h"
#import "NewPostViewController.h"
#import "UIColor+RandomColor.h"

@interface PostTableViewController ()



@end

@implementation PostTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString *filePath = [[self documentsDirectory] stringByAppendingPathComponent:@"saveFile.plist"];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"saveFile" ofType:@"plist"];
        [[NSFileManager defaultManager] copyItemAtPath:bundlePath toPath:filePath error:nil];

    }
    self.posts = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSInteger numberOfPosts = [defaults integerForKey:@"NumberOfPosts"];
    [defaults setInteger:numberOfPosts+1 forKey:@"Number of Posts"];
    [defaults synchronize];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.posts.count;
}

- (PostTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    PostTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor generateRandomColor];
    
    Post *post = [self.posts objectAtIndex:indexPath.row];
    
    cell.postItem = post;
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showDetailSegue"]) {
        PostDetailViewController *detail = segue.destinationViewController;
        NSInteger selectedRow = [self.tableView indexPathForSelectedRow].row;
        Post *post = [self.posts objectAtIndex:selectedRow];
        detail.post = post;
    }
    else if ([segue.identifier isEqualToString:@"addNewPost"]) {
        NewPostViewController *detail = segue.destinationViewController;
        Post *newPost = [Post new];
        newPost.userName = @"";
        newPost.title = @"";
        newPost.content = @"";
        [self.posts addObject:newPost];
        detail.post = newPost;
        NSLog(@"Pre new post: %d", self.posts.count);
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    for (int i = 0; i<self.posts.count; i++) {
        Post *currPost = self.posts[i];
        if ([currPost.userName isEqualToString:@""] && [currPost.title isEqualToString:@""] && [currPost.content isEqualToString:@""])
        {
            [self.posts removeObjectAtIndex:i];
        }
    }
    [self savePostsToDisk];
    [self.tableView reloadData];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSLog(@"I have %d posts", self.posts.count);
}

- (void) savePostsToDisk
{
    NSString *filePath = [[self documentsDirectory] stringByAppendingPathComponent:@"saveFile.plist"];
    [NSKeyedArchiver archiveRootObject:self.posts toFile:filePath];
}



- (NSString *) documentsDirectory
{
    //return sandbox directory
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *results = [fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
    NSURL *documentsURL = [results lastObject];
    return documentsURL.path;
}

@end

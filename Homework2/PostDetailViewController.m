//
//  PostDetailViewController.m
//  Homework2
//
//  Created by Frazier Moore on 2/13/14.
//  Copyright (c) 2014 Frazier Moore. All rights reserved.
//

#import "PostDetailViewController.h"

@interface PostDetailViewController ()

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentTextView;
@property (weak, nonatomic) IBOutlet UILabel *titleField;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation PostDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void) setPost:(Post *)post
{
    _post = post;
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // set up UI with the post
    self.userNameLabel.text = _post.userName;
    self.contentTextView.text = _post.content;
    self.navigationItem.title = _post.title;
    self.dateLabel.text = [_post.timeStamp description];
    self.titleField.text = _post.title;
    if (_post.postImage) {
        self.imageView.image = _post.postImage;
        self.imageView.layer.cornerRadius = (self.imageView.frame.size.width)/4;
    }
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"editPost"]) {
        PostDetailViewController *detail = segue.destinationViewController;
        Post *post = self.post;
        detail.post = post;
    }
}

- (IBAction) deletePost:(id)sender
{
    self.contentTextView.text = @"";
    self.userNameLabel.text = @"";
    self.titleField.text = @"";
    
    _post.content = self.contentTextView.text;
    _post.userName = self.userNameLabel.text;
    _post.title = self.titleField.text;
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) viewWillDisappear:(BOOL)animated
{
    _post.content = self.contentTextView.text;
    _post.userName = self.userNameLabel.text;
    _post.title = self.titleField.text;
    
    [super viewWillDisappear:animated];
}








@end

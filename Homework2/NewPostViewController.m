//
//  NewPostViewController.m
//  Homework2
//
//  Created by Frazier Moore on 2/18/14.
//  Copyright (c) 2014 Frazier Moore. All rights reserved.
//

#import "NewPostViewController.h"

@interface NewPostViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate>

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UITextField *userNameLabel;
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;
@property (weak, nonatomic) IBOutlet UITextField *titleField;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation NewPostViewController

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

- (void)showPickerWithSourceType:(UIImagePickerControllerSourceType) sourceType
{
    UIImagePickerController *picker = [UIImagePickerController new];
    
    picker.sourceType = sourceType;
    
    picker.delegate = self;
    picker.allowsEditing = YES;
    [self presentViewController:picker animated:YES completion:nil];
}

- (IBAction)takePicture:(id)sender
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Choose source type, homes"
                                                                 delegate:self
                                                        cancelButtonTitle:@"Cancel"
                                                   destructiveButtonTitle:nil
                                                        otherButtonTitles:@"Photo Library",@"Camera", nil];
        [actionSheet showFromBarButtonItem:sender animated:YES];
    }
    else
    {
        [self showPickerWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    }

}

- (void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    if ([buttonTitle isEqualToString:@"Camera"]) {
        [self showPickerWithSourceType:UIImagePickerControllerSourceTypeCamera];
    }
    else if ([buttonTitle isEqualToString:@"Photo Library"])
    {
        [self showPickerWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    }
    
}

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSLog(@"%@", info);
    [self dismissViewControllerAnimated:YES completion:^{
        self.imageView.image = [info objectForKey:UIImagePickerControllerEditedImage];
        self.imageView.layer.cornerRadius = (self.imageView.frame.size.width); //diamond
//        self.imageView.layer.cornerRadius = (self.imageView.frame.size.width/2); //circle
//        self.imageView.layer.cornerRadius = (self.imageView.frame.size.width/4); //rounded corners
        self.imageView.clipsToBounds = YES;
    }];
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
}

- (IBAction)saveThePost:(id)sender
{
    _post.content = self.contentTextView.text;
    _post.userName = self.userNameLabel.text;
    _post.title = self.titleField.text;
    _post.postImage = self.imageView.image;
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UIControl *control in self.view.subviews) {
        if ([control isKindOfClass:[UITextField class]]) {
            [control endEditing:YES];
        }
    }
}

@end

//
//  BlurWithCoreImageVC.m
//  BlurImageDemo
//
//  Created by 云菲 on 16/8/12.
//  Copyright © 2016年 云菲. All rights reserved.
//

#import "BlurWithCoreImageVC.h"

@interface BlurWithCoreImageVC () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource>

@property (strong, nonatomic) NSArray *filterCategories;
@property (strong, nonatomic) NSArray *filterNames;

@property (weak, nonatomic) IBOutlet UIImageView *myImageView;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *filterPickerViewHeightConstrain;

@property (strong, nonatomic) UIImage *originalImage;

@end

@implementation BlurWithCoreImageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    
    self.filterCategories = [NSArray arrayWithObjects:
                             @"无",
                             kCICategoryDistortionEffect,
                             kCICategoryGeometryAdjustment,
                             kCICategoryCompositeOperation,
                             kCICategoryHalftoneEffect,
                             kCICategoryColorAdjustment,
                             kCICategoryColorEffect,
                             kCICategoryTransition,
                             kCICategoryTileEffect,
                             kCICategoryGenerator,
                             kCICategoryReduction,
                             kCICategoryGradient,
                             kCICategoryStylize,
                             kCICategorySharpen,
                             kCICategoryBlur,
                             kCICategoryVideo,
                             kCICategoryStillImage,
                             kCICategoryInterlaced,
                             kCICategoryNonSquarePixels,
                             kCICategoryHighDynamicRange,
                             kCICategoryBuiltIn,
                             kCICategoryFilterGenerator,
                             nil];
}

#pragma mark - custom methods
- (void)addFilterToViewWithAttribute:(NSString *)attribute{
    CIImage *inputImage = [CIImage imageWithCGImage:_originalImage.CGImage];
    
    
    CIFilter *filter = [CIFilter filterWithName:attribute];
    [filter setValue:inputImage forKey:kCIInputImageKey];
        
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef resultImage = [context createCGImage:filter.outputImage fromRect:filter.outputImage.extent];
    _myImageView.image = [UIImage imageWithCGImage:resultImage];
    
}

#pragma mark - events
- (IBAction)selectImage:(UIButton *)sender {
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePicker.delegate = self;
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
}

- (IBAction)addFilterCategory:(UIButton *)sender {
    
    [UIView animateWithDuration:0.25 animations:^{
        _filterPickerViewHeightConstrain.constant = 400;
        [self.view layoutIfNeeded];
    }];
}

- (IBAction)saveImage:(UIButton *)sender {
    
}

#pragma mark - UIPickerView DataSource
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 2;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (component == 0) {
        return self.filterCategories.count;
    }else{
        return self.filterNames.count;
    }
    
}

#pragma mark - UIPickerView Delegate
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (component == 0) {
        return self.filterCategories[row];
    }else{
        return self.filterNames[row];
    }
    
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    if (component == 0 && row > 0) {
        self.filterNames = [CIFilter filterNamesInCategory:self.filterCategories[row]];
        NSLog(@"%@", _filterNames);
        [pickerView reloadComponent:1];
    }else{
        [UIView animateWithDuration:0.25 animations:^{
            _filterPickerViewHeightConstrain.constant = 0;
            [self.view layoutIfNeeded];
        }];
        
        if(component == 1){
            [self addFilterToViewWithAttribute:self.filterNames[row]];
        }
    }
    
    
}

#pragma mark - UIImagePickController Delegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    if (image) {
        _myImageView.image = image;
        _originalImage = image;
    }

    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

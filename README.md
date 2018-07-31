# ZJSNodeSlider

ZJSNodeSlider *slider = [[ZJSNodeSlider alloc] init];
slider.frame = CGRectMake(10, 60, CGRectGetWidth(self.view.frame) - 20, 50);
slider.minValue = 0;
slider.maxValue = 3;
slider.step = YES;
slider.value = 1;
slider.nodeCount = 4;
slider.nodeDiameter = 12;
slider.thumbImage = [UIImage imageNamed:@"icon_device_setting_slider_thumb"];
slider.backgroundColor = [UIColor yellowColor];
[slider addTarget:self action:@selector(sliderValueChangedAction:) forControlEvents:UIControlEventValueChanged];
[self.view addSubview:slider];
# ZJSNodeSlider

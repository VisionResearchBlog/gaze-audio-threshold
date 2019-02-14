# gaze-audio-threshold
Experimental Gaze-contingent software for estimating auditory detection and discrimination thresholds

This is part of research funded by EU's Marie Curie Initiative LanPercept
https://www.ntnu.edu/lanpercept

*REQUIREMENTS* 
Matlab is required Earlier versions may or may not 
work - the current software was developed with Matlab 2016/2017
https://www.mathworks.com/products/matlab.html

And the Psychophysics toolbox version 3
http://psychtoolbox.org/

Note this code was originally developed for TobiiSDK 3.0.83
Tobii has subsequently completed revised their SDK. We have included
the old SDK in the repository 'tobii-analytics-sdk-3.0.83.zip'

In the future we hope the code base will be updated to reflect the new SDK
https://www.tobiipro.com/product-listing/tobii-pro-sdk/

*—* 


Please consult ReadMe.txt for use instructions. 
StartConditioningExps.m is used to run the experiment, and along with
LoadContants.m, SetCalibParams.m they form the 3 main files to edit for various 
parameters, paths, and setting up conditions.

The code contained here is available for research purposes only and is described in more detail via
(Sullivan,Wilson, and Saldana, submitted 2017)

Copyright Wilson & Sullivan 2016, (Seville, Spain / Stockholm, Sweden)

Gaze Audio Threshold is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

Gaze Audio Threshold is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with Gaze Audio Threshold.  If not, see <http://www.gnu.org/licenses/>.

# chorylab-HyDE
This is the official repo for HyDE (Hypocotyl Determining Engine), a matlab-based program that measures hypocotyl growth in time-series images. Developed by Benjamin J. Cole, 2011. Documentation organized here by Russell Tran, 2021.  

Includes some ImageJ plugin scripts to preprocess images for input into HyDE, such as appropriate cropping.

## 2011 documentation

- [*Rapid and dynamic growth of Arabidopsis seedlings in response to changes in light
quality: A live imaging study*](https://escholarship.org/content/qt8j3081vb/qt8j3081vb_noSplash_5ff25572facd6a6b99431395aba48c39.pdf?t=n701fs)
- [*Automated analysis of hypocotyl growth dynamics during shade avoidance in Arabidopsis*](https://doi.org/10.1111/j.1365-313X.2010.04476.x)
- `doc/hyde_userguide.pdf` in this repo. Excerpted from the Appendix of Benjamin's above thesis.

# Releases

* **2011 Release**, or all available files from 2011
	* `2011_HyDEv1_0_win32.zip`: contains distrib of HyDE v1.0, which is the most stable version of HyDE and the published version used in the paper
	* `2011_Col-0_ctrl.zip`: Example image data set ready for input into HyDE. Arabidopsis Col-0 grown as control.
	* `2011_Col-0_shade.zip`: Example image data set ready for input into HyDe. Arabidopsis Col-0 grown in shade.
	* `2011_jekell_files.zip`: Contains
		* `jekell_preprocess.java`: source for FIJI Plugin to preprocess camera images before input to HyDE
		* `Interop.Galil.0.5.dll`: useful for interfacing with the carousel
		* `jekell_3.exe`: a binary used to run the carousel (the source no longer exists). Both `jekell_3.exe` and the carousel are a prototype.
		* `jekell_preprocess.class`: a binary used in for preprocessing
	* `2011_HyDE_versions.zip`: Contains 
		* Source of HyDE v1.0 
		* A binary for the work-in-progress HyDE v2.0 
		* The source for the work-in-progress HyDE v4.0. 
		* There is no HyDE v3.0. Presumably HyDE v2.0 and 4.0 have some work to incorporate leaf angle, and different methods to compute Shoot Apical Meristem (SAM), per Benjamin's memory. Consider this zip bundle only for exploratory purposes.

# Development
The source included in this repo is based on the 2011 published HyDE v1.0, and the preprocessing FIJI plugin (referred to as Jekell). For exploration of other old work, look at the 2011 Release.

# Russell's guide
The pipeline is as follows:

Images acquired as "stacks" from camera -> preprocessing manually or using ImageJ script -> input into HyDE using GUI -> automated measurements


## Hardware
- Camera requires 6-pin Firewire cable. Firewire ports were phased out of most computers around 2010. You can daisy chain to USB-C using a 6-pin to 9-pin cable and a 9-pin to USB-C adapter. Example:
	- [Pasow FireWire 800 to 400 9 to 6 pin Cable (9pin 6pin) 6FT, IEEE 1394 Firewire 800 9-pin/6-pin Cable 6 Feet(9 pin to 6 pin)](https://www.amazon.com/gp/product/B00X65XHZG/ref=ppx_yo_dt_b_asin_title_o01_s00?ie=UTF8&psc=1)
	- [Apple Thunderbolt to FireWire Adapter](https://www.amazon.com/gp/product/B00SQ2CJUS/ref=ppx_yo_dt_b_asin_title_o01_s01?ie=UTF8&psc=1)

## Hardware installation steps

## Software

## Software installation steps

## Blog (For Chory Lab use)

### 25 March 2021

### 24 March 2021
Was able to find the rail stage + carousel + small backlight, the Marlin camera, a 6-pin Firewire cable, 1 big backlight, 1 plate holder, 2 7-pin power transformers for the backlights. Could not get either of the backlights to turn on, so either they or both the transformers are dead. Noticeably missing were the guppy camera and other plate holders. Desktop computer which used to run the apparatus was dead/could not boot, so sent to IT. Bought Firewire adapters from Amazon to attempt daisy chain to camera:

- [Pasow FireWire 800 to 400 9 to 6 pin Cable (9pin 6pin) 6FT, IEEE 1394 Firewire 800 9-pin/6-pin Cable 6 Feet(9 pin to 6 pin)](https://www.amazon.com/gp/product/B00X65XHZG/ref=ppx_yo_dt_b_asin_title_o01_s00?ie=UTF8&psc=1)
- [Apple Thunderbolt to FireWire Adapter](https://www.amazon.com/gp/product/B00SQ2CJUS/ref=ppx_yo_dt_b_asin_title_o01_s01?ie=UTF8&psc=1)

### January 2021
Cactus server (dead and whose hard drives were in RAID setup so order needs to be reconstructed to access) used to host official source and distribution for HyDE, so some files or documentation may be there.

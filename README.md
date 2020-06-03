# Protest Sign-Maker
A tool for making enlarged printable versions of protest signs from pre-existing images or screenshots. 

The user provides a jpeg or png, designates the size of their sign surface (cardboard etc) and it outputs a new set of split images that can be printed out and re-assembled on the sign.

Built for Mac and Linux systems using the ffmpeg tool and basic shell script.


Download the tool here --> [download](tombetthauser.com/dev/assets/protest_signmaker.zip)


## Works but still needs work...

This was originally built as a personal studio tool for up-scaling sketches into transfers larger work

As such the code and interface gloriously un-optimized. Anyone is encouraged to copy and improbe on the code, the idea or make pull requests to this repo.

If anyone wants to adapt this to a web-based project with a friendly UI please please please do it.

***

<img src="https://raw.githubusercontent.com/tombetthauser/protest_signmaker/master/project_files/demo.gif">

Processing an existing protest sign image to a set of printable images for a new 33x24 inch sign.

Original image from June 1st protest in Amherst, MA 2020.

***

# How to use the tool on MacOS...
1) Download the zip file version of the project here --> [download](tombetthauser.com/dev/assets/protest_signmaker.zip)
2) Double click the zip file to unzip it.
3) Open your Terminal application...
```
command + space --> then type "Terminal" and hit enter
```
4) Make sure you left the unzipped project folder in your Downloads folder.
5) Now choose an Jpeg or Png image file you want to turn into a poster.
6) Drag this file into the project folder.
7) To simplify things make sure the title of the image is short and has no spaces.
8) Now run the following command in your Terminal window and hit enter...
```
bash ~/Downloads/protest_signmaker/sign_maker.sh
```
9) Follow the prompts given to you in the Terminal window and you should be good to go!
10) If it gives you an error or seems to crash just run it again and check all input spelling etc.
11) If it works a new folder should appear in the project folder with a bunch of printable images in it!
***
# If you want to improve the project... 

### Some ideas for where I was planning to take the project.

1) Maybe create a Python + TkInter desktop GUI and make the script a clickable '.command' file.
2) Maybe transition the whole project to Python and build a web-interface for it with Django.
3) Definitely want to tweak the math so that all output images are 8.5x11 with smaller remainder images in extra row and column on the bottom and right sides.
4) Definitely need to make a horizontal / vertical option.
5) Maybe create an outline image mode if possible in ffmpeg for paint-by-numbers style prints.

### If you know how to use GitHub / Git feel free to fork the project and make pull requests!

If you want to make a completely new / improved version of the project please appropriate any code freely, I'd love to use a more friendly / clean version of this myself and wish I had time to build it!

```
If you end up using the tool I'd love to see what you make! Happy printing 🎉
Twitter / Instagram --> @tombetthauser
```

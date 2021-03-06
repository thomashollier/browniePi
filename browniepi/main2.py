import spidev as SPI
import ST7789
import RPi.GPIO as GPIO
import time
import subprocess
import sys

from PIL import Image,ImageDraw,ImageFont


print("Initializing")

#GPIO define
RST_PIN        = 25
CS_PIN         = 8
DC_PIN         = 24

KEY_UP_PIN     = 6 
KEY_DOWN_PIN   = 19
KEY_LEFT_PIN   = 5
KEY_RIGHT_PIN  = 26
KEY_PRESS_PIN  = 13

KEY1_PIN       = 21
KEY2_PIN       = 20
KEY3_PIN       = 16

# Raspberry Pi pin configuration:
RST = 27
DC = 25
BL = 24
bus = 0 
device = 0 

# 240x240 display with hardware SPI:
disp = ST7789.ST7789(SPI.SpiDev(bus, device),RST, DC, BL)

# Initialize library.
disp.Init()

# Clear display.
disp.clear()

#init GPIO
# for P4:
# sudo vi /boot/config.txt
# gpio=6,19,5,26,13,21,20,16=pu
GPIO.setmode(GPIO.BCM) 
GPIO.setup(KEY_UP_PIN,      GPIO.IN, pull_up_down=GPIO.PUD_UP) # Input with pull-up
GPIO.setup(KEY_DOWN_PIN,    GPIO.IN, pull_up_down=GPIO.PUD_UP) # Input with pull-up
GPIO.setup(KEY_LEFT_PIN,    GPIO.IN, pull_up_down=GPIO.PUD_UP) # Input with pull-up
GPIO.setup(KEY_RIGHT_PIN,   GPIO.IN, pull_up_down=GPIO.PUD_UP) # Input with pull-up
GPIO.setup(KEY_PRESS_PIN,   GPIO.IN, pull_up_down=GPIO.PUD_UP) # Input with pull-up
GPIO.setup(KEY1_PIN,        GPIO.IN, pull_up_down=GPIO.PUD_UP) # Input with pull-up
GPIO.setup(KEY2_PIN,        GPIO.IN, pull_up_down=GPIO.PUD_UP) # Input with pull-up
GPIO.setup(KEY3_PIN,        GPIO.IN, pull_up_down=GPIO.PUD_UP) # Input with pull-up

imageGreen = Image.new("RGB", (disp.width, disp.height), "GREEN")
imageBlack = Image.new("RGB", (disp.width, disp.height), "BLACK")
draw = ImageDraw.Draw(imageGreen)
disp.ShowImage(imageGreen,0,0)
pixDir="%s/pix/" % "/".join(sys.argv[0].split("/")[:-1])

try:
    pixnum = int(sorted([x for x in subprocess.run(["ls", "-1", pixDir], check=True, stdout=subprocess.PIPE, universal_newlines=True)
        .stdout.split('\n') if x.find("jpg")>0])[-1:][0]
        .split('.')[1])+1
except:
    pixnum=1


print("--- ready")
while 1:
    # Create blank image for drawing.
    #font = ImageFont.truetype('/usr/share/fonts/truetype/freefont/FreeMonoBold.ttf', 16)
    if not GPIO.input(KEY_PRESS_PIN): # button is released
        thisPic = "%s/pic.%04d.jpg" % (pixDir, pixnum)
        print("taking picture %s" % thisPic)
        subprocess.call(["raspistill", "-o", thisPic])
        pixnum = pixnum + 1
        size = 240, 240
        print("displaying %s" % thisPic)
        image = Image.open(thisPic)
        mypoo = image.resize(size, Image.ANTIALIAS)
        disp.ShowImage(mypoo,0,0)
        print("--- ready")
        
    if not GPIO.input(KEY2_PIN): # button is released
        disp.ShowImage(imageGreen,0,0)
        print("clearing screen")

    if not GPIO.input(KEY3_PIN): # button is released
        disp.ShowImage(imageBlack,0,0)
        print("bye-bye")
        exit(0)


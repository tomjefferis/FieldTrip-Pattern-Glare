# script to put figures in a powerpoint presentation
import os
from pptx import Presentation
from pptx.util import Inches


typeExperiment = 'frequency' # frequency or time
imageDir = 'W:\\PhD\\PatternGlareData\\Results\\'+ typeExperiment + '\\figures'

# get the list of images
imageList = os.listdir(imageDir)

# split list into two based on if the image dir contains "0.5-3s"
imageList_0_5_3s = []
imageList_other = []
for image in imageList:
    if "0.5-3s" in image:
        imageList_0_5_3s.append(image)
    else:
        imageList_other.append(image)

# sort the lists alphabetically
imageList_0_5_3s.sort()
imageList_other.sort()


# create a new presentation
prs = Presentation()
# creat title slide
title_slide_layout = prs.slide_layouts[0]
slide = prs.slides.add_slide(title_slide_layout)
title = slide.shapes.title
subtitle = slide.placeholders[1]
title.text = "Pattern Glare"
subtitle.text = "Results: " + typeExperiment

# creat title slide
title_slide_layout = prs.slide_layouts[0]
slide = prs.slides.add_slide(title_slide_layout)
title = slide.shapes.title
title.text = "DC Shift"

# add the images to center of the slide but keep aspect ratio and fit to slide
for image in imageList_0_5_3s:
    blank_slide_layout = prs.slide_layouts[6]
    slide = prs.slides.add_slide(blank_slide_layout)
    left = top = Inches(0)
    pic = slide.shapes.add_picture(imageDir + '\\' + image, left, top)
    pic.width = Inches(6.5)
    pic.height = Inches(7.5)
    pic.left = int((prs.slide_width - pic.width)/2)



# creat title slide
title_slide_layout = prs.slide_layouts[0]
slide = prs.slides.add_slide(title_slide_layout)
title = slide.shapes.title
title.text = "Offset Period"

# add the images to center of the slide but keep aspect ratio and fit to slide
for image in imageList_other:
    blank_slide_layout = prs.slide_layouts[6]
    slide = prs.slides.add_slide(blank_slide_layout)
    left = top = Inches(0)
    pic = slide.shapes.add_picture(imageDir + '\\' + image, left, top)
    pic.width = Inches(6.5)
    pic.height = Inches(7.5)
    pic.left = int((prs.slide_width - pic.width)/2)


# save the presentation
prs.save('W:\\PhD\\PatternGlareData\\Results\\'+ typeExperiment + '\\figures\\figures.pptx')


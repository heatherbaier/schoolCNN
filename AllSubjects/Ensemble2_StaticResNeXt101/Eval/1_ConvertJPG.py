from PIL import Image
import os

directory = "../data/imagery/"

# For a reason I have yet to understand, PNG's work when training the model but not evaluating it, so I convert the images to JPS's here
for filename in os.listdir(directory):
    school_id = filename[0:6]
    im = Image.open(directory + filename).convert('RGB')
    new_name = "./jpg/" + school_id + '.jpg'
    im.save(new_name)

window.Q = Quintus(development: true, imagePath: "./assets/images/", audioPath: './assets/audio/', dataPath: './assets/images/')
  .include("Sprites, Anim, Math, Scenes, Input, 2D, Touch, UI, Audio")
  .setup(maximize: true, scaleToFit: true)     # Add a canvas element onto the page
  .touch()     # Add in touch support (for the UI)
  .enableSound()

# Q.debug = true
$(document).ready -> Game.start()
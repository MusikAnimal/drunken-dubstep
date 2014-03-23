# add listeners when DOM is ready
document.addEventListener "DOMContentLoaded", (event)->

  # skip to the action
  vid.addEventListener 'loadedmetadata', ()->
    this.currentTime = 50
  , false

  # make it melt
  vid.addEventListener 'canplay', ()->
    this.className = "melt"
    this.play()
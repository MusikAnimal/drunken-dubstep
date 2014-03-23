// add listeners when DOM is ready
document.addEventListener("DOMContentLoaded", function(event) {
  // skip to the action
  document.getElementById('vid').addEventListener('loadedmetadata', function() {
    this.currentTime = 50;
  }, false);
  // make it melt
  document.getElementById('vid').addEventListener('canplay', function() {
    this.className = "melt";
    this.play();
  });
});
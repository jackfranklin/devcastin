$(function() {
  var $container = $(".video-player");
  var myPlayer = videojs('my_video_1');

  var width = $container.width();
  var height =  width / 1.6;

  myPlayer.width(width);
  myPlayer.height(height);

});

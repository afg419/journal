// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require_tree .
//= require bootstrap-sprockets

//= require highcharts/highcharts
//= require highcharts/highcharts-more

$(document).ready(function(){
  extractEntry();
  $('.entry-form').delay(000).fadeTo('slow', 1);
  $('#add-emotion').on('click',function(){
    revealHideNewEmotion();
  })

  $('#create-emotion').on('click',function(){
    createNewEmotion();
  })
  listenForRemove();
})

String.prototype.capitalize = function() {
    return this.charAt(0).toUpperCase() + this.slice(1);
}

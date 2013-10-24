// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery.min
//= require jquery_ujs
//= require foundation
//= require modernizr
//= require_tree .

$(document).ready(function() {  
  $(document).foundation();
  var jPM = $.jPanelMenu();
  jPM.on();
  $("#loading").hide();  
  if ($('.alert-box.notice').length) {
    $('.alert-box.notice').fadeIn().delay(3000).fadeOut();
  }
});
$(document).foundation();

$(document).live('ajax:beforeSend', function(event, xhr, settings) {    
  $("#ajax_bar").fadeIn("slow");
});

$(document).live('ajax:complete', function(event, xhr, settings) {  
  $("#ajax_bar").fadeOut("slow");  
});

$(document).on('page:load', ready)

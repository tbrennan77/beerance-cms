# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
jQuery ->
  $('#contact').live 'click', ->
    if $('.login').is(":visible")
      $('.login').slideToggle('fast')
    $('.contact').slideToggle('fast')

  $('#login').live 'click', ->
    if $('.contact').is(":visible")
      $('.contact').slideToggle('fast')
    $('.login').slideToggle('fast')
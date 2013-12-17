# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
jQuery ->
  $(document).on 'click', '#contact', ->
    $('.alert-box.notice').hide()
    if $('.login').is(":visible")
      $('.login').slideToggle('fast')
    $('.contact').slideToggle('fast')

  $(document).on 'click', '#login', ->
    $('.alert-box.notice').hide()
    if $('.contact').is(":visible")
      $('.contact').slideToggle('fast')
    $('.login').slideToggle('fast')
    $('#header_user_email').focus()

  $("#user_remember_me").focusout ->
    $(this).parent().removeClass('remember_me_focused')
  $("#user_remember_me").focus ->
    $(this).parent().addClass('remember_me_focused')

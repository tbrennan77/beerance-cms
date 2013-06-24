# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
jQuery ->
  Stripe.setPublishableKey($('meta[name="stripe-key"]').attr('content'))
  subscription.setupForm()

  original_input_value = ""

  $('.edit_bar_specials label').live 'click', ->
    $(this).hide()
    $(this).next('.hide').show()
    $(this).next('.hide').focus();
    original_input_value = $(this).next('.hide').val()

  $('.edit_bar_specials .hide').live 'blur', ->
    if $(this).val() != original_input_value
      $('.ajax-container').fadeOut('fast')
      $(this).parent().parent().parent().submit()
    else
      $(this).hide()
      $(this).prev('label').show()  

  $('.cancel-new-bar').live 'click', ->
    $('#new_bar_entity').parent().fadeOut().delay(1000).remove()

  $('input[type="radio"]').live 'change', ->
    $('label').removeClass('active')
    $(this).parent().addClass('active')

subscription =
  setupForm: ->
    $('#new_user').submit ->
      $('input[type="submit"]').attr('disabled', true)
      if $('#card_number').length
        subscription.processCard()
        false
      else
        true

  processCard: ->
    card =
      name: $('#card_name').val()
      address_line1: $('#address_line1').val()
      address_line2: $('#address_line2').val()
      address_city: $('#address_city').val()
      address_state: $('#address_state').val()
      address_zip: $('#address_zip').val()
      number: $('#card_number').val()
      cvc: $('#card_code').val()
      expMonth: $('#card_month').val()
      expYear: $('#card_year').val()
    Stripe.createToken(card, subscription.handleStripeResponse)

  handleStripeResponse: (status, response) ->
    if status == 200
      $('#stripe_error').text('')
      $('#user_stripe_card_token').val(response.id)
      $('#new_user')[0].submit()
    else
      $('#stripe_error').text(response.error.message.replace("The card object must have a value for 'number'", 'Please enter a credit card number'))      
      $('input[type="submit"]').attr('disabled', false)

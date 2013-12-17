# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
jQuery ->
  Stripe.setPublishableKey($('meta[name="stripe-key"]').attr('content'))
  subscription.setupForm()

  $(document).ready ->
    all_selects = $('.hour-label').find('select')    
    all_selects.each ->
      selects = $(this).parent().parent().find('select')
      if $(this).val() == 'Closed'
        selects.first().val('Closed')
        selects.last().val('Closed')
        selects.first().parent().removeClass('large-6').addClass('large-12').focus()
        selects.last().hide()

subscription =
  setupForm: ->
    $('#new_bar').submit ->
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
      $('#bar_stripe_card_token').val(response.id)
      $('#new_bar')[0].submit()
    else
      $('#stripe_error').text(response.error.message.replace("The card object must have a value for 'number'", 'Please enter a credit card number'))      
      $('input[type="submit"]').attr('disabled', false)

$(document).on 'change', '.hour-label select', ->
  selects = $(this).parent().parent().find('select')

  if $(this).val() == 'Closed'
    selects.first().val('Closed')
    selects.last().val('Closed')
    selects.first().parent().removeClass('large-6').addClass('large-12').focus()
    selects.last().hide()
  else
    selects.first().parent().removeClass('large-12').addClass('large-6')
    selects.last().parent().removeClass('large-12').addClass('large-6')    
    selects.last().show()

$(document).on 'change', 'input[type="radio"]', ->
  $('label').removeClass('active')  
  $(this).parent().parent().parent().find('label.amount').addClass('active')

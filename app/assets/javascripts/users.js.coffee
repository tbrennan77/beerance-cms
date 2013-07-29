jQuery ->
  $('a.new-special').live 'click', ->
    $('#new_bar_specials').fadeToggle()

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
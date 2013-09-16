jQuery ->
  $('a.new-special').live 'click', ->
    $('#new_bar_special').fadeToggle()

  original_input_value = ""

  $('.edit_bar_special label').live 'click', ->
    $(this).hide()
    $(this).next('.hide').show()
    $(this).next('.hide').focus();
    original_input_value = $(this).next('.hide').val()

  $('.edit_bar_special .hide').live 'blur', ->
    if $(this).val() != original_input_value      
      $(this).parent().parent().parent().submit()
    else
      $(this).hide()
      $(this).prev('label').show()

  window.onpopstate = (e) ->
   if e.state
     console.log('title: '+e.state.html)
     document.title = e.state.pageTitle
     $('.ajax-container').html(e.state.html)

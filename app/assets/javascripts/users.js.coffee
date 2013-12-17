jQuery ->
  $(document).on 'click', 'a.new-special', ->
    $('#new_bar_special').fadeToggle()

  original_input_value = ""

  $(document).on 'click', '.edit_bar_special label', ->
    $(this).hide()
    $(this).next('.hide').show()
    $(this).next('.hide').focus();
    original_input_value = $(this).next('.hide').val()

  $(document).on 'blur', '.edit_bar_special .hide', ->
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

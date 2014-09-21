# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
index = 0
$(document).ready ->
  setupSelect2()
  checkInputs($('input'))
  
  unless $('#buyout_currency_hidden').val() == ''
    id = $('#buyout_currency_hidden').val()
    selected = $('#buyout-currency ul.dropdown-menu li[data-value="'+id+'"] a')
    $('#buyout-currency button').html($(selected).html() + ' <span class="caret"></span>')
  
  $('#add_mod_button').click ->
    template = $('#mod_template').children().clone(true, true)
    index += 1
    template.find('input, select').each ->
      $(this).attr('name', $(this).attr('name').replace('_INDEX_', index))
    template.find('input, select').each ->
      $(this).attr('id', $(this).attr('id').replace('_INDEX_', index))
    template.find('.remove_mod_button').click ->
      template.remove()
    template.appendTo('#mod_selector')
    setupSelect2()
    
  $('button.remove_mod_button').click ->
    $(this).closest('.row').remove()
  
  $('#buyout-currency ul.dropdown-menu li a').click (e) ->
    e.preventDefault()
    $('#buyout_currency_hidden').val($(this).parent().data('value'))
    $('#buyout-currency button').html($(this).html() + ' <span class="caret"></span>')
    
  $('#league-select').on('change', ->
    $.cookie('preferred_league', $(this).val())
  )
  
  if $.cookie('preferred_league') != undefined and ! $('#league-select').hasClass('league_set')
    $('#league-select').select2().select2('val', $.cookie('preferred_league'))
  
  $('#search-form').on("ajax:before", ->
    $('#submit-button').html('<i class="fa fa-cog fa-spin"></i>').attr('disabled', 'disabled')
    $('.ajax-loader, #page-ajax-loader').show()
  ).on("ajax:success", (e, data, status, xhr) ->
    $('#results').html xhr.responseText
    setupPagination()
    setupOrdering()
    setupVerification()
    history.pushState({slug:$('#slug').html()}, "", '/search/'+$('#slug').html())
    $.scrollTo('#submit-button', 800)
  ).on("ajax:error", (e, xhr, status, error) ->
    $('#results').html "<div class=\"alert alert-danger\">An error has occurred. The administrator has been notified.<br/>" + error + "</div>"
  ).on("ajax:complete", ->
    $('#submit-button').html('<i class="fa fa-search"></i> Search').removeAttr('disabled')
    $('.ajax-loader, #page-ajax-loader').hide()
  )
  
  $('#item-name').autocomplete({
    source: '/items/similar_names',
    minLength: 3,
    delay: 500,
    autoFocus: true
  })
  
  $('#switch-simple').on('click', (e) ->
    e.preventDefault()
    $(this).parent().addClass('active')
    $('#switch-advanced').parent().removeClass('active')
    $('.advanced').hide()
    $('.advanced input').prop("disabled", true)
    $('.simple').show()
    $('.simple input').prop("disabled", false)
    $.cookie('preferred_search', 'simple')
  )
  
  $('#switch-advanced').on('click', (e) ->
    e.preventDefault()
    $(this).parent().addClass('active')
    $('#switch-simple').parent().removeClass('active')
    $('.advanced').show()
    $('.advanced input').prop("disabled", false)
    $('.simple').hide()
    $('.simple input').prop("disabled", true)
    $.cookie('preferred_search', 'advanced')
  )
  
  unless $.cookie('preferred_search') == undefined
    if $.cookie('preferred_search') == 'advanced'
      $('#switch-advanced').click()
    else
      $('#switch-simple').click()
  else
    $('#switch-simple').click()
    
  $('#item_type').on('change', (e) ->
    $.getJSON('/items/base_types', { item_type_id: $(this).val() }, (results) ->
      options = ''
      $(results).each (index, item) ->
        options += '<option value="'+item.id+'">'+item.name+'</option>'
      $('#base').html(options).val('')
      $('#s2id_base').select2("val", "")
    )
  )
  
  $('input').on('change', ->
    checkInput($(this))
  )
  
  $('#submit-button').on("click", ->
    $('#order').val('')
    $('#set-page').val('1')
  )
  
  if $('#set-page').val() != ''
    setTimeout "$('#search-form').submit()", 1000
  
  window.windowWidth = $(window).width();
  $(window).bind('resize', ->
    window.windowWidth = $(window).width();
    setupBackToTopButton()
  )
  setupBackToTopButton()

setupBackToTopButton = ->
  offset = 1300
  if 992 < window.windowWidth < 1199
    offset = 1500
  if 768 < window.windowWidth < 991
    offset = 1600
  if window.windowWidth < 768
    offset = 2200

  duration = 500
  $(window).unbind('scroll').scroll ->
    if $(this).scrollTop() > offset
      $('.back-to-top').fadeIn(duration)
    else
      $('.back-to-top').fadeOut(duration)
    
$(window).bind("popstate", (e) ->  
  state = e.originalEvent.state

  if state and state.slug
    $('.ajax-loader, #page-ajax-loader').show()
    $.get('/results/'+state.slug, (result) ->
      $('#results').html(result)
      setupPagination()
      setupOrdering()
      setupVerification()
      $('.ajax-loader, #page-ajax-loader').hide()
      $.scrollTo('#submit-button', 800)
    )
)

formatSelect2 = (option) ->
  originalOption = option.element
  option.text.replace('(total)', $(originalOption).data('label'))

setupSelect2 = ->
  $("#search-form select").select2
    formatResult: formatSelect2
    formatSelection: formatSelect2
    escapeMarkup: (m) ->
      m

 
checkInput = (input) ->
  $('input[type="text"]').each ->
    if $(this).val() != ''
      $(this).closest('div').addClass('has-success')
    else
      $(this).closest('div').removeClass('has-success')
      
  siblings = $(input).closest('.input-group').children('input')
  siblings_empty = true
  siblings.each( (index, sibling) ->
    siblings_empty = false unless $(sibling).val() == ''
  )
  unless siblings_empty
    $(input).closest('.input-group').addClass('has-success')
  else
    $(input).closest('.input-group').removeClass('has-success')
    
checkInputs = (inputs) ->
  inputs.each (index, input) ->
    checkInput(input)
    
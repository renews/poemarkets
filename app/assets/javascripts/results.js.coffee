setupPagination = ->
  $('.ajax-loader').hide()
  $('a.back-to-top').on('click', (e) ->
    e.preventDefault()
    $.scrollTo('#submit-button', 800)
  )
  setupLoadMore()

window.setupPagination = setupPagination

setupLoadMore = ->
  window.noMoreItems = false
  window.inAjax = false
  window.tooRecent = false
  $('a.load-more').on('click', (e) ->
    e.preventDefault()
    page = $(this).data('page')
    $(this).parent().remove()
    nextPage(page)
  )
  $(window).scroll ->
    return if window.noMoreItems or window.inAjax or window.tooRecent
    if $(window).scrollTop() + $(window).height() > $(document).height() - 1500
      window.tooRecent = true
      $('a.load-more').click()
      setTimeout("window.tooRecent = false", 2000)


window.setupLoadMore = setupLoadMore

nextPage = (page, pageSequence, scrollDirection) ->
  window.inAjax = true
  $('#page-ajax-loader').fadeIn()
  $('#set-page').val(page)
  $.ajax({
    url: '/results',
    type: 'GET',
    cache: false,
    data: $('#search-form').serialize(), 
    success: (response) ->
      appendItems(response, page)
    complete: ->
      $('#page-ajax-loader').fadeOut()
      window.inAjax = false
  })
  
appendItems = (html, page) ->
  $('#results').append(html) unless window.noMoreItems
  window.noMoreItems = true if $('#results').find('#no-more-items').length > 0
  unless window.noMoreItems
    window.setupOrdering()
    window.setupVerification()
    window.setupLoadMore()

setupOrdering = ->
  $('a.sort, button.sort').off('click').on('click', (e) ->
    e.preventDefault()
    $(this).off('click').on('click', (e) ->
      e.preventDefault()
    )
    $(this).effect('highlight', 500).find('span').append(' <i class="fa fa-gear fa-spin"></i>')
    $('#order').val($(this).data('sort'))
    $('#set-page').val(1)
    $('#search-form').submit()
  )

window.setupOrdering = setupOrdering

setupVerification = ->
  $('a.verify-button').unbind().each (index, item) ->
    window.verifyItem(item)
  $('.contact-button').unbind().on("click", ->
    $(this).closest('.item').find('.verify-button').click()
  )

verifyItem = (item) ->
  $(item).on("ajax:before", ->
    $(item).html('<i class="fa fa-cog fa-spin"></i>')
  )
  $(item).on("ajax:success", (e, data, status, xhr) ->
    result = $.parseJSON(xhr.responseText)
    $(item).html('<span class="fa fa-check"></span> Verified').removeClass('btn-primary').addClass('btn-success') if result.request and result.verified
    $(item).html('<span class="fa fa-warning"></span> Sold').removeClass('btn-primary').addClass('btn-danger') if result.request and !result.verified
    $(item).html('Error: Maybe forums are down').removeClass('btn-primary').addClass('btn-danger') if !result.request
  )
  $(item).on("ajax:error", (e, xhr, status, error) ->
    $(item).html('Error:' + error).removeClass('btn-primary').addClass('btn-danger')
  )
  $(item).on("ajax:complete", ->
    $(item).removeAttr('href').removeAttr('data-remote').unbind().on('click', (e) ->
      e.preventDefault()
    )
    $(item).parent().find('h6 span.item-checked').html('Just now')
  )

window.verifyItem = verifyItem  
window.setupVerification = setupVerification
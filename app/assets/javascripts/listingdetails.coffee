# listing_details#manage
$ ->
  helpScrollManage = ->
    $('.request-block #tour-guidefee-help').offset(top: $('#tour-guidefee-height').offset().top)
    $('.request-block #tour-optionfee-help').offset(top: $('#tour-optionfee-height').offset().top)
    $('.request-block #tour-guests_cost-help').offset(top: $('#tour-guests_cost-height').offset().top)

  if $('body').hasClass('listings edit') ||  $('body').hasClass('listings new') || $('body').hasClass('listings create')
    $elementReference = document.getElementById( "listing_notes" )
    $placeholder = 'We will walk on mountain paths, so dress comfortably.' + "\n" + 'There is meat included as part of the standard tour, so please let me know if there are any vegetarians in your group.'
    $elementReference.placeholder = $placeholder

    $('.listing-manager-area-container').text('')
    areas = []
    $('#listing_area [name="listing[pickup_ids][]"]:checked').each ->
      areas.push $(this).parent().text()
    if areas.length > 0
      $('.listing-manager-area-container').text('')
      $.each areas, (index, elem) ->
        $('.listing-manager-area-container').append('<span class="listing-area-item">' + elem + '</span>')


    #---------------------------------------------------------------------
    # open listing_area
    #---------------------------------------------------------------------
    $('.listing-manager-area').on 'click', (e) ->
      $('#listing_area').modal()
      e.preventDefault()
      e.stopPropagation()
      return false

    $('.listing-manager-area-submit').on 'click', (e) ->
      $('.listing-manager-area-container').text('')
      areas = []
      $('#listing_area [name="listing[pickup_ids][]"]:checked').each ->
        areas.push $(this).parent().text()
      if areas.length > 0
        $('.listing-manager-area-container').text('')
        $.each areas, (index, elem) ->
          $('.listing-manager-area-container').append('<span class="listing-area-item">' + elem + '</span>')
      $('#listing_area').modal('hide')

  if $('body').hasClass('listing_details manage') || $('body').hasClass('listing_details update')

    helpScrollManage()

    #---------------------------------------------------------------------
    # open include_what
    #---------------------------------------------------------------------
    $('a.include_what_trigger_ja').on 'click', (e) ->
      $('#include_what_ja').modal()
      e.preventDefault()
      e.stopPropagation()
      return false

    #---------------------------------------------------------------------
    # open about_transportation_fee
    #---------------------------------------------------------------------
    $('.js-modal-about_transportation_fee-trigger').on 'click', (e) ->
      $('#about_transportation_fee').modal('show')
      e.preventDefault()

    #---------------------------------------------------------------------
    # open about_system_fee
    #---------------------------------------------------------------------
    $('.js-modal-about_system_fee-trigger').on 'click', (e) ->
      $('#about_system_fee').modal('show')
      e.preventDefault()


  $('.calendar-description').on 'click', (e) ->
    if $(this).parents('.collapse-panel').hasClass('active')
      $(this).parents('.collapse-heading').next().collapse('hide')
      $(this).parents('.collapse-panel').removeClass('active')
      $(this).find('i.fa-caret-up').addClass('fa-caret-down')
      $(this).find('i.fa-caret-up').removeClass('fa-caret-up')
    else
      $(this).parents('.collapse-heading').next().collapse('show')
      $(this).parents('.collapse-panel').addClass('active')
      $(this).find('i.fa-caret-down').addClass('fa-caret-up')
      $(this).find('i.fa-caret-down').removeClass('fa-caret-down')

#calc price
$ ->
  # price = Number($('#listing_detail_price').val())
  # price_other = Number($('#listing_detail_price_other').val())
  # price_calced = $('#price_calced')
  # price_calced.text('¥' + (price + price_other))
  # $(document).on 'change', '#listing_detail_price', ->
  #   price = Number($('#listing_detail_price').val())
  #   price_calced.text('¥' + (price_other + price))

  # $(document).on 'change', '#listing_detail_price_other', ->
  #   price_other = Number($('#listing_detail_price_other').val())
  #   price_calced.text('¥' + (price + price_other))

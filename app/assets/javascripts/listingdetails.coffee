# listing_details#manage
$ ->
  helpScrollEdit = ->
    titleTop = $('#tour-title').offset().top
    overviewTop = $('#tour-overview').offset().top
    notesTop = $('#tour-notes').offset().top
    conditionTop = $('#tour-condition').offset().top
    titleHeight = $('#tour-title').outerHeight(true)
    overviewHeight = $('#tour-overview').outerHeight(true)
    notesHeight = $('#tour-notes').outerHeight(true)
    conditionHeight = $('#tour-condition').outerHeight(true)
    headerHeight = $('#header').outerHeight(true)
    subnavHeight = $('.subnav').outerHeight(true)

    titleHelp = $('.listing_help_block #tour-title-help')
    overviewHelp = $('.listing_help_block #tour-overview-help')
    notesHelp = $('.listing_help_block #tour-notes-help')
    conditionHelp = $('.listing_help_block #tour-condition-help')

    titleHelp.css('top', titleTop - headerHeight - subnavHeight - 50 + 'px')
    overviewHelp.css('top', overviewTop - headerHeight - subnavHeight + 50 + 'px')
    if $('#map-wrapper').hasClass('in')
      notesHelp.css('top', notesTop - headerHeight - subnavHeight + 'px')
      conditionHelp.css('top', conditionTop - headerHeight - subnavHeight + 'px')
    else
      notesHelp.css('top', (notesTop - headerHeight - subnavHeight) - 500 + 'px')
      conditionHelp.css('top', (conditionTop - headerHeight - subnavHeight) - 500 + 'px')

  helpScrollManage = ->
    previewHelp = $('.request-block #tour-preview-help')
    actionHelp = $('.request-block #tour-action-preview')
    peopleHelp = $('.request-block #tour-people-help')
    guidefeeHelp = $('.request-block #tour-guidefee-help')
    optionfeeHelp = $('.request-block #tour-optionfee-help')

    previewHeight = $('.request-block #tour-preview-help').outerHeight(true)
    actionHeight = $('.request-block #tour-action-preview').outerHeight(true)
    peopleHeight = $('.request-block #tour-people-help').outerHeight(true)
    guidefeeHeight = $('.request-block #tour-guidefee-help').outerHeight(true)

    previewHelp.css('top', '40px')
    actionHelp.css('top', previewHeight + 40 + 'px')
    peopleHelp.css('top', previewHeight + actionHeight + 120 + 'px')
    guidefeeHelp.css('top', previewHeight + actionHeight + peopleHeight + 120 + 'px')
    optionfeeHelp.css('top', previewHeight + actionHeight + peopleHeight + guidefeeHeight + 120 + 'px')

  if $('body').hasClass('listings edit') ||  $('body').hasClass('listings new') || $('body').hasClass('listings create')
    helpScrollEdit()
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
  price = Number($('#listing_detail_price').val())
  price_other = Number($('#listing_detail_price_other').val())
  price_calced = $('#price_calced')
  price_calced.text('¥' + (price + price_other))
  $(document).on 'change', '#listing_detail_price', ->
    price = Number($('#listing_detail_price').val())
    price_calced.text('¥' + (price_other + price))

  $(document).on 'change', '#listing_detail_price_other', ->
    price_other = Number($('#listing_detail_price_other').val())
    price_calced.text('¥' + (price + price_other))

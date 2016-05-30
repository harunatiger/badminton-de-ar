# features.coffee

# responsive js ==================================================
featureResponsive = ->

  # if window size under 768px(mobile)
  if $('.features-tile').css('float') != 'left'

    # collapse toggle
    $('.features-tile-link').on 'click', ->
      collapseComp = $(this).next()
      if collapseComp.hasClass('in')
        collapseComp.collapse('hide')
      else
        collapseComp.collapse('show')
      return false
    # collapse close
    $('.btn-feature-readmore-close--sp').on 'click', ->
      $(this).parent().collapse('hide')
      return false

    # component move
    ###
    $('.fore-text').each ->
      foreid = $(this).parents('.features-section').attr('id')
      foreid = foreid.replace('features-section', '')
      $(this).appendTo('#features-section' + foreid + '--sp .js-fore-text--sp')
      return
    $('.main-text').each ->
      mainid = $(this).parents('.features-section').attr('id')
      mainid = mainid.replace('features-section', '')
      $(this).appendTo('#features-section' + mainid + '--sp .js-main-text--sp')
      return
    $('a.section-photo01').each ->
      phid01 = $(this).parents('.features-section').attr('id')
      phid01 = phid01.replace('features-section', '')
      $(this).appendTo('#features-section' + phid01 + '--sp .js-section-photo01--sp')
      return
    $('a.section-photo02').each ->
      phid02 = $(this).parents('.features-section').attr('id')
      phid02 = phid02.replace('features-section', '')
      $(this).appendTo('#features-section' + phid02 + '--sp .js-section-photo02--sp')
      return
    $('.features-tourlist').each ->
      listid = $(this).parents('.features-section').attr('id')
      listid = listid.replace('features-section', '')
      $(this).appendTo('#features-section' + listid + '--sp .js-tourlist--sp')
      return
    ###

  # if window size over 768px(pc)
  else
    # readmore
    #$('a.btn-feature-readmore').on 'click', ->
    #  $.ajax(
    #    type: 'GET'
    #    url: '/features/content/content01'
    #    dataType: 'slim'
    #  ).done (data,status) ->
    #    if status == 'success'
    #      console.log data
    #      #$('#preview-show').html(data)
    #      #$('#preview-attached').modal()
    #      return false
    #    else
    #      return false
    #  return false

    # smooth-scroll
    $('.features-tile-link').on 'click', ->
      if location.pathname.replace(/^\//, '') == @pathname.replace(/^\//, '') and location.hostname == @hostname
        target = $(@hash)
        target = if target.length then target else $('[name=' + @hash.slice(1) + ']')
        if target.length
          $('html, body').animate { scrollTop: target.offset().top }, 'fast'
          return false
      return

    # features photo gallery
    $('.feature-photo-container').each ->
      $(this).magnificPopup
        delegate: 'a'
        type: 'image'
        image:
          verticalFit: true
        gallery:
          enabled: true
      return

    ###
    $('.fore-text').each ->
      foreidpc = $(this).parents('.features-section').attr('id')
      foreidpc = foreidpc.replace('features-section', '')
      $(this).appendTo('#features-section' + foreidpc + ' .js-fore-text--pc')
      return
    $('.main-text').each ->
      mainidpc = $(this).parents('.features-section').attr('id')
      mainidpc = mainidpc.replace('features-section', '')
      $(this).appendTo('#features-section' + mainidpc + ' .js-main-text--pc')
      return
    $('a.section-photo01').each ->
      phid01pc = $(this).parents('.features-section').attr('id')
      phid01pc = phid01pc.replace('features-section', '')
      $(this).appendTo('#features-section' + phid01pc + ' .js-section-photo01--pc')
      return
    $('a.section-photo02').each ->
      phid02pc = $(this).parents('.features-section').attr('id')
      phid02pc = phid02pc.replace('features-section', '')
      $(this).appendTo('#features-section' + phid02pc + ' .js-section-photo02--pc')
      return
    $('.features-tourlist').each ->
      listidpc = $(this).parents('.features-section').attr('id')
      listidpc = listidpc.replace('features-section', '')
      $(this).appendTo('#features-section' + listidpc + ' .js-tourlist--pc')
      return
    ###

# onload
$ ->
  # features#index
  if $('body').hasClass('features')

    setTimeout (->
      # Responsive
      featureResponsive()
    ), 100

    $('.img-bg, .tour-cover').lazyload
      effect: 'fadeIn'

    # window resize
    timer = false
    $(window).resize ->
      if timer != false
        clearTimeout timer
      timer = setTimeout((->
        console.log 'resized'
        featureResponsive()
        return
      ), 200)
      return

    # readmore close
    $('a.btn-feature-readmore-close').on 'click', ->
      href = $(this).attr('href')
      $(href).collapse('hide')
      $(this).parent().next().show()
      return false
    
    $('.btn-feature-readmore').on 'click', ->
      content_name = $(this).attr('content_name')
      $.ajax(
        type: 'GET'
        url: '/features/contents'
        data: {
          content_name: content_name,
          device: 'pc'
        }
      ).done (data) ->
        $('#' + content_name + '_pc').html(data)
      return false
    
    $('.features-tile-link').on 'click', ->
      content_name = $(this).attr('content_name')
      $.ajax(
        type: 'GET'
        url: '/features/contents'
        data: {
          content_name: content_name,
          device: 'sp'
        }
      ).done (data) ->
        $('#' + content_name).html(data)
      return false
      

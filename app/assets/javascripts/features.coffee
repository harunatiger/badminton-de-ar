# features.coffee

# onload
$ ->
  # features#index
  if $('body').hasClass('features')

    # readmore
    $(document).on 'click', '.btn-feature-readmore', (event) ->
      href = $(this).attr('href')
      $(href).collapse('show')
      $(this).hide()
      return false
    # readmore close
    $(document).on 'click', '.btn-feature-readmore-close', (event) ->
      href = $(this).attr('href')
      $(href).collapse('hide')
      $(this).parent().next().show()
      return false

    # responsive js ==================================================
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
      $('.btn-feature-readmore-close--sp').on 'click', ->
        $(this).parent().collapse('hide')
        return false

      # component move
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

    # if window size over 768px(pc)
    else
      $('.fore-text').each ->
        foreid = $(this).parents('.features-section').attr('id')
        foreid = foreid.replace('features-section', '')
        $(this).appendTo('#features-section' + foreid + ' .js-fore-text--pc')
        return
      $('.main-text').each ->
        mainid = $(this).parents('.features-section').attr('id')
        mainid = mainid.replace('features-section', '')
        $(this).appendTo('#features-section' + mainid + ' .js-main-text--pc')
        return
      $('a.section-photo01').each ->
        phid01 = $(this).parents('.features-section').attr('id')
        phid01 = phid01.replace('features-section', '')
        $(this).appendTo('#features-section' + phid01 + ' .js-section-photo01--pc')
        return
      $('a.section-photo02').each ->
        phid02 = $(this).parents('.features-section').attr('id')
        phid02 = phid02.replace('features-section', '')
        $(this).appendTo('#features-section' + phid02 + ' .js-section-photo02--pc')
        return
      $('.features-tourlist').each ->
        listid = $(this).parents('.features-section').attr('id')
        listid = listid.replace('features-section', '')
        $(this).appendTo('#features-section' + listid + ' .js-tourlist--pc')
        return

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

    # scroll to list
    ###
    $('.to-tour-list').on 'click', ->
      $('html, body').animate { scrollTop: $('#features-tour-list').offset().top }, 'fast'
      return false
    # scroll to target
    $('a.highlight-anchor').on 'click', ->
      if location.pathname.replace(/^\//, '') == @pathname.replace(/^\//, '') and location.hostname == @hostname
        target = $(@hash)
        target = if target.length then target else $('[name=' + @hash.slice(1) + ']')
        if target.length
          $('html, body').animate { scrollTop: target.offset().top }, 'fast'
          return false
      return
    ###

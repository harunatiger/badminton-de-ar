# features.coffee

# loader preset
$.fn.spin.presets.flower =
  lines: 7
  length: 0
  width: 4
  radius: 6

# responsive js ==================================================
featureResponsive = ->

  # if window size under 768px(mobile)
  if $('.features-tile').css('float') != 'left'

    # readmore close
    $(document).on 'click', 'a.btn-feature-readmore-close--sp', ->
      href = $(this).attr('href')
      $(href).collapse('hide')
      return false

  # if window size over 768px(pc)
  else
    # ajax pc
    $('.btn-feature-readmore').on 'click', ->
      href = $(this).attr('href')
      btnBase = $(this)
      btnText = $('span.text', this)
      spin_tag = '<div class="spinner"></div>'
      btnBase.append(spin_tag)
      spinner = $('.spinner', btnBase)
      btnText.hide()
      spinner.spin('flower', 'white')
      # first time?
      if $(href).hasClass('done')
        $(href).collapse('show')
        btnText.show()
        spinner.remove()
        btnBase.hide()
      # plentiful
      else
        content_name = $(this).attr('content_name')
        $.ajax(
          type: 'GET'
          url: '/features/contents'
          data: {
            content_name: content_name,
            device: 'pc'
          }
        ).done (data) ->
          $('#' + content_name + '_pc').html(data).addClass('done')
          setTimeout (->
            $('#' + content_name + '_pc').collapse()
            btnText.show()
            spinner.remove()
            btnBase.hide()
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
          ), 100
      return false

    # readmore close
    $(document).on 'click', 'a.btn-feature-readmore-close', ->
      href = $(this).attr('href')
      $(href).collapse('hide')
      $(this).parent().next().show()
      return false

# onload
$ ->
  # if features#index
  if $('body').hasClass('features')

    setTimeout (->
      # Responsive
      featureResponsive()
      # exception
      $('.features-tile-link').on 'click', ->
        if $('.features-tile').css('float') != 'left'
          # ajax sp
          content_name = $(this).attr('content_name')
          parentBox = $('#' + content_name + '_sp')
          linkBase = $(this)
          spin_tag = '<div class="spinner"></div>'
          linkBase.append(spin_tag)
          spinner = $('.spinner', linkBase)
          spinner.spin('flower', 'white')
          # first time?
          if parentBox.hasClass('done')
            if parentBox.hasClass('in')
              parentBox.collapse('hide')
              spinner.remove()
            else
              parentBox.collapse('show')
              spinner.remove()
          # plentiful
          else
            $.ajax(
              type: 'GET'
              url: '/features/contents'
              data: {
                content_name: content_name,
                device: 'sp'
              }
            ).done (data) ->
              $('#' + content_name + '_sp').html(data).addClass('done')
              setTimeout (->
                $('#' + content_name + '_sp').collapse()
                spinner.remove()
              ), 200
        else
          # smooth-scroll
          if location.pathname.replace(/^\//, '') == @pathname.replace(/^\//, '') and location.hostname == @hostname
            target = $(@hash)
            target = if target.length then target else $('[name=' + @hash.slice(1) + ']')
            if target.length
              $('html, body').animate { scrollTop: target.offset().top }, 'fast'
              return false
          return
        return false
    ), 100

    # lazyload background-images
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

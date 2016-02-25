# help_topics
$ ->
  if $('body').hasClass('help_topics index')
    getScrollTarget = (href) ->
      hrefSplit = href.split(/#/)
      target = $('#' + hrefSplit[1])
      console.log target
      position = target.offset().top - 40
      $('body,html').animate(scrollTop:position)
      return false

    setNavScroll =(navi, main) ->
      navi_parent = $('#help-nav')
      #before = $(window).scrollTop()
      navi_parent.css
        position: 'relative'
        top: '0px'
      footerHeight = $('footer').height() + 100
      target_top = navi.offset().top - parseInt(navi.css('margin-top'), 10)
      sub_top = main.offset().top - parseInt(main.css('margin-top'), 10)
      #sub_scroll = main.offset().top + main.outerHeight(true) - navi.outerHeight(true) - parseInt(navi.css('margin-top'), 10)
      if navi.outerHeight(true) + target_top < main.outerHeight(true) + sub_top
        $(window).scroll ->
          ws = $(window).scrollTop()
          sub_scroll = main.offset().top + main.outerHeight(true) - navi.outerHeight(true) - parseInt(navi.css('margin-top'), 10)
          if ws > sub_scroll
            navi_parent.css
              position: 'fixed'
              top: sub_scroll - (ws + footerHeight) + 'px'
          else if ws > target_top
            #if before > ws
            navi_parent.css
              position: 'fixed'
              top: '10px'
            #else
          else
            navi_parent.css
              position: 'relative'
              top: '0px'
          return
      return

    $('.help_guide_list').css('display','none')
    $('#help_guide_content').css('display','none')

    if $('#help-nav').css('display') == 'block'
      setNavScroll($('#help-nav .help_other_list'), $('#help_other_content'))

      $('a.help_guide_trigger').on 'click', (e) ->
        $('.help_other_list').css('display','none')
        $('.help_guide_list').css('display','block')
        $('#help_other_content').css('display','none')
        $('#help_guide_content').css('display','block')
        $('body,html').animate(scrollTop:0)
        setNavScroll($('#help-nav .help_guide_list'), $('#help_guide_content'))


      $('a.help_other_trigger').on 'click', (e) ->
        $('.help_other_list').css('display','block')
        $('.help_guide_list').css('display','none')
        $('#help_other_content').css('display','block')
        $('#help_guide_content').css('display','none')
        $('body,html').animate(scrollTop:0)
        setNavScroll($('#help-nav .help_other_list'), $('#help_other_content'))

      $('li.help-category-item.anchor-scroll a').each ->
        $(this).on 'click', (e) ->
          $('li.help-category-item a').removeClass('nav-active')
          $(this).addClass('nav-active')
          if !$(this).parent().hasClass('help-category-item-children')
            $('.collapse.in').collapse('hide')
          getScrollTarget($(this).attr('href'))

      $('li.help-category-item .parent-category a').each ->
        $(this).on 'click', (e) ->
          $('li.help-category-item a').removeClass('nav-active')
          $(this).addClass('nav-active')
          $('.collapse.in').collapse('hide')
          #child_first_elem = $(this).parent().next().find('li.help-category-item-children:first').children('a')
          #if child_first_elem.length != -1
            #child_first_elem.addClass('nav-active')

          if $(this).parent().next().hasClass('collapse in')
            $(this).parent().next().collapse('hide')
          else
            $(this).parent().next().collapse('show')
            $(this).parent().next().css('padding-left','30px')

          getScrollTarget($(this).attr('href'))

      $('li.help-category-item-children.anchor-scroll a').each ->
        $(this).on 'click', (e) ->
          $('li.help-category-item a').removeClass('nav-active')
          $(this).addClass('nav-active')
          getScrollTarget($(this).attr('href'))


    else if $('#help-nav-sp').css('display') == 'block'

      $('a.help_guide_trigger').on 'click', (e) ->
        $('.help_other_list').css('display','none')
        $('.help_guide_list').css('display','block')
        $('#help_other_content').css('display','none')
        $('#help_guide_content').css('display','block')
        $('body,html').animate(scrollTop:0)

      $('a.help_other_trigger').on 'click', (e) ->
        $('.help_other_list').css('display','block')
        $('.help_guide_list').css('display','none')
        $('#help_other_content').css('display','block')
        $('#help_guide_content').css('display','none')
        $('body,html').animate(scrollTop:0)

      $('li.help-category-item.anchor-scroll a').each ->
        $(this).on 'click', (e) ->
          $('li.help-category-item a').removeClass('nav-active')
          $(this).addClass('nav-active')
          if !$(this).parent().hasClass('help-category-item-children')
            $('.collapse.in').collapse('hide')
          getScrollTarget($(this).attr('href'))

      $('li.help-category-item .parent-category a').each ->
        $(this).on 'click', (e) ->
          $('li.help-category-item a').removeClass('nav-active')
          $(this).addClass('nav-active')
          $('.collapse.in').collapse('hide')
          #child_first_elem = $(this).parent().next().find('li.help-category-item-children:first').children('a')
          #if child_first_elem.length != -1
            #child_first_elem.addClass('nav-active')

          if $(this).parent().next().hasClass('collapse in')
            $(this).parent().next().collapse('hide')
          else
            $(this).parent().next().collapse('show')
            $(this).parent().next().css('padding-left','30px')

          getScrollTarget($(this).attr('href'))

      $('li.help-category-item-children.anchor-scroll a').each ->
        $(this).on 'click', (e) ->
          $('li.help-category-item a').removeClass('nav-active')
          $(this).addClass('nav-active')
          getScrollTarget($(this).attr('href'))

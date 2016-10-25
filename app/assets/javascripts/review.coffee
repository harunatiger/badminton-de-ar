$ ->
  if $('body').hasClass('reviews for_guide') || $('body').hasClass('reviews create_guide') ||  $('body').hasClass('reviews for_guest') || $('body').hasClass('reviews create_guest') || $('body').hasClass('unscheduled_tour') || $('body').hasClass('create_unscheduled_tour')
    $('input[type=file]').change ->
      file = $(this).prop('files')[0]
      if !file.type.match('image.*')
        $(this).val ''
        $('.tour-image-thumb').html ''
        return
      reader = new FileReader

      reader.onload = ->
        img_src = $('<img>').attr('src', reader.result)
        $('.tour-image-thumb').html img_src
        $('.tour-image-thumb').removeClass('hide')
        return

      reader.readAsDataURL file
      return
    return

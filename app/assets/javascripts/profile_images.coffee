$ ->
  if $('body').hasClass('profile_images manage')
    $('.image-draggable').draggable(revert: 'invalid', scroll: true, zIndex: 1)
    $('.image-droppable').droppable(activeClass: 'image-drag-active', hoverClass: 'image-drag-hover', tolerance: 'touch')

    image_from = ''
    $(document).on 'dragstart', '.image-draggable', ->
      image_from = $('.image-draggable').index(this)
      return
      
    $(document).on 'drop', '.image-droppable', ->
      image_to = $('.image-droppable').index(this)
      profile_id = $('#profile_id').val()
      $.ajax(
        type: 'PUT'
        url: '/profiles/' + profile_id + '/profile_images/change_order'
        data: {
          profile_id: profile_id ,
          image_from: image_from + 1,
          image_to: image_to + 1
        }
      ).done (data) ->
        $('#images_list').html(data)
        $('.image-draggable').draggable(revert: 'invalid', scroll: true, zIndex: 1)
        $('.image-droppable').droppable(activeClass: 'image-drag-active', hoverClass: 'image-drag-hover', tolerance: 'touch')
        
    #upload cover_image
    $(document).on 'change', '#profile_cover_image', ->
      $('#update_profile_cover_image').submit()
      return

    #upload image (new)
    $(document).on 'change', '#profile_thumb_image', ->
      $('#upload_image').submit()
      return

    #upload image (update)
    $(document).on 'change', '[id^=update_thumb_image]', ->
      id = $(this).attr("id")
      id_num = id.substr(id.length - 1)
      $('#update_image' + id_num).submit()
      return 
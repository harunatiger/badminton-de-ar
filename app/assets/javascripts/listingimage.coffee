$ ->
  if $('body').hasClass('listing_images manage')
    $('.image-draggable').draggable(revert: 'invalid', scroll: true, zIndex: 1)
    $('.image-droppable').droppable(activeClass: 'image-drag-active', hoverClass: 'image-drag-hover', tolerance: 'touch')

    image_from = ''
    $(document).on 'dragstart', '.image-draggable', ->
      image_from = $('.image-draggable').index(this)
      
    $(document).on 'drop', '.image-droppable', ->
      image_to = $('.image-droppable').index(this)
      listing_id = $('#listing_id').val()
      $.ajax(
        type: 'PUT'
        url: '/listings/' + listing_id + '/listing_images/change_order'
        data: {
          listing_id: listing_id ,
          image_from: image_from + 1,
          image_to: image_to + 1
        }
      ).done (data) ->
        $('#images_list').html(data)
        $('.image-draggable').draggable(revert: 'invalid', scroll: true, zIndex: 1)
        $('.image-droppable').droppable(activeClass: 'image-drag-active', hoverClass: 'image-drag-hover', tolerance: 'touch')
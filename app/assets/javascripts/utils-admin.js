
$('document').ready(function(){
  setupClickOfImageForUpload()
  // List with handle
  setupSortable("blocksOrderable", 'admin/simple_blocks/')
  setupSortable("menuOrderable", 'admin/menus/')
  setupWhenChangeImageRemoveCrop()
  setupIframe()
  setupOpenCloseTab()
  setupCssLive()

})


function setupCssLive(){
  $('#website_css').on('textchange', textCssJsChanged)
  $('#website_js').on('textchange', textCssJsChanged)
}

function textCssJsChanged(){
  $('#edit_website_6').submit();
}

function setupWhenChangeImageRemoveCrop(){
  $('#opera_image').change(function(){
    $('#col-cropbox').empty();
  })
}

function setupSortable(id, path){
  var element = document.getElementById(id)
  if (element !== null){ doSortable(element, path) }
}

function doSortable(element, path){
  Sortable.create(element, {
      handle: ".glyphicon-move",
      animation: 200,
      onEnd: function(evt){
        var id = $(evt.item).find('form').attr('id')
        if (id === undefined){ id = $(evt.item).attr('id') }
        var splitted = id.split("_")
        
        var id_of_block = splitted[splitted.length-1]
        $.ajax({
          type: "PUT",
          url: '/it/'+path+id_of_block+'/sort',
          data: {
            position: evt.newIndex
          }
        }).done(function(msg){
          refreshIframe()        
        });
      }
    });
}

function setupIframe(){
  $('iframe').css('height', $(window).height()+'px')
  $('#editor-container').css('height', $(window).height()+'px')
}


function setupOpenCloseTab(){
  $('.panel-body').hide()
  $('.panel-heading').css('cursor', 'pointer')
  $('.panel-heading').click(function(){
    $(this).next().slideToggle()
  })
  $('.panel-heading-open').next().toggle()
}

function refreshIframe(){
  var iframe = document.getElementById('iframe-preview');
  iframe.src = iframe.src;
}

function setupClickOfImageForUpload(){
  $('.btn-upload-img').css('cursor', 'pointer')
  $('.btn-upload-img').click(function(e){
    var $input = $(this).next().find('input')
    $input.trigger('click')
  })
}
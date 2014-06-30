$(document).ready( function() {

  $(document).on('click', '#hit input', function() {
//    $.ajax({
//      type: 'POST',
//      url: '/game/hit/player'
//    }).done(function(msg){
//      ('#game_template').replaceWith(msg);
//    });
    alert('test');
    return false;
  });

  $('#stay').click(function(){
    alert("test");
    return false;
  }

  $('.dropdown-toggle').dropdown();
});


$(document).ready( function() {

  $(document).on('click', '#hit input', function() {
    $.ajax({
      type: 'POST',
      url: '/game/hit/player'
    }).done(function(msg){
      $('#game_template').replaceWith(msg);
    });
    return false;
  });

  $(document).on('click', '#stay', function() {
    $.ajax({
      type: 'POST',
      url: '/game/stay/player'
    }).done(function(msg){
      $('#game_template').replaceWith(msg);
    });
    return false;
  });

  $(document).on('click', '#dealer_btn_form input', function() {
    $.ajax({
      type: 'POST',
      url: '/game/dealer_start'
    }).done(function(msg){
      $('#game_template').replaceWith(msg);
    });
    return false;
  });

  $(document).on('click', '#dealer_continue_form input', function() {
    $.ajax({
      type: 'POST',
      url: '/game/hit/dealer'
    }).done(function(msg){
      $('#game_template').replaceWith(msg);
    });
    return false;
  });

  $('.dropdown-toggle').dropdown();
});


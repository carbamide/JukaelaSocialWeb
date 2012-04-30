$("#micropost_content").live('keyup', function() {
  var maxChar = 140;
  var count = $(this).val().length;
  var remainingChar = maxChar - count;
  $("#counter").html(remainingChar);
  if(remainingChar > 0) {
    $("#counter").css('color', 'green');
  } else {
    $("#counter").css('color', 'red');
  }
});
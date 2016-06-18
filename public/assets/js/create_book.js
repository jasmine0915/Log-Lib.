$(function(){
  //***create_book***
  $("#url_add").click(function(){
    $("#contents").prepend("<label for='url'>URL :</label><br><input type='url' name='url[]'><br><label for='url_title'>URL TILTE :</label><br><input type='title' name='url_title[]'><br><br>");
  });
});
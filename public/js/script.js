$(document).ready(function(){
  $('#hint').on('click', function(event){
    event.preventDefault();

    $.get('/hint', function(data){
      var n = + $('.hint-counter').text();
      (n > 0) ? n -= 1 : n;
      $('.hint-counter').text(n);
      $('.show-hint').text(data);
    });
  });

  var url = window.location.href;
  $('ul.nav > li').removeClass('active');

  if (url.indexOf('/game') !== -1) {
    $('.play').addClass('active');
  } else if (url.indexOf('/about') !== -1) {
    $('.about').addClass('active');
  }


  var result = $('.result').text().split(''),
      html = '';
  result.forEach(function(el) {
    if (el == '+') {
      html += "<span class='badge badge-success'>" + el + "</span>";
    } else {
      html += "<span class='badge badge-warning'>" + el + "</span>";
    }
  })
  $('.result').text('');
  $('.result').append(html);
});

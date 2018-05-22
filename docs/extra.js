var quotes = [
  "This is a quote.",
  "And this is another quote.",
  "Here is a third quote."
];

var i = 0;

var quoteTimer = function() {
  if (i >= quotes.length) {
    i = 0;
  }
  $('#picard h4').fadeOut(1000, function(){
    $(this).text(quotes[i]);
  });
  $('#picard h4').fadeIn();
  i++;
}

$(document).ready(function() {
  $('#picard h4').text(quotes[i++]);
  setInterval(quoteTimer, 6000);
});

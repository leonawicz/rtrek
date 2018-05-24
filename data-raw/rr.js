var tngtweets;
$.getJSON('https://raw.githubusercontent.com/leonawicz/rtrek/master/data-raw/tweet-data/tngtweets_cleaned.json', function (json) {
  tngtweets = json;
  var tng_n = tngtweets.length
  var i = 0;
  var display_name = "";
  var sname = "";
  var prev_sname = "";
  var imgsrc = "https://pbs.twimg.com/profile_images/416337864809402368/iSHIA4Zt_400x400.jpeg";
  var tweetbg = "rgba(223, 0, 0, 0.3)";

  var updateinfo = function(value) {
  switch(value) {
    case "PicardTips":
      display_name = "Captain Picard";
		  imgsrc = "https://pbs.twimg.com/profile_images/416337864809402368/iSHIA4Zt_400x400.jpeg";
		  tweetbg = "rgba(223, 0, 0, 0.3)";
      break;
    case "WorfEmail":
      display_name = "Lieutenant Commander Worf";
		  imgsrc = "https://pbs.twimg.com/profile_images/654554221606404096/36B4emY6_400x400.jpg";
		  tweetbg = "rgba(242, 195, 0, 0.3)";
      break;
    case "RikerGoogling":
      display_name = "Commander Riker";
		  imgsrc = "https://pbs.twimg.com/profile_images/499021253953347585/COG26p9r_400x400.jpeg";
		  tweetbg = "rgba(223, 0, 0, 0.3)";
      break;
	  case "LocutusTips":
      display_name = "Locutus of Borg";
		  imgsrc = "https://pbs.twimg.com/profile_images/378800000473928974/d3f927c7cd0d521c8f4307604bb1bda9_400x400.jpeg";
		  tweetbg = "rgba(45, 45, 45, 0.3)";
      break;
    case "GuinanTips":
      display_name = "Guinan";
		  imgsrc = "https://pbs.twimg.com/profile_images/3553205536/6a8ce69c672ce39e681caa616f983878_400x400.jpeg";
		  tweetbg = "rgba(139, 0, 139, 0.3)";
      break;
    case "WesleyTips":
      display_name = "Wesley Crusher";
		  imgsrc = "https://pbs.twimg.com/profile_images/3553180409/2a474c59e4db1c16e193d2416fc977c4_400x400.jpeg";
		  tweetbg = "rgba(0, 153, 246, 0.3)";
      break;
	  case "Data_Tips":
      display_name = "Lieutenant Commander Data";
		  imgsrc = "https://pbs.twimg.com/profile_images/3553185056/656cef4bb850e315dadb0a948c094a67_400x400.jpeg";
		  tweetbg = "rgba(242, 195, 0, 0.3)";
      break;
    case "RikerTips":
      display_name = "Commander Riker";
		  imgsrc = "https://pbs.twimg.com/profile_images/3546366672/67f52907c151d056272be6becae6f2d8_400x400.jpeg";
		  tweetbg = "rgba(223, 0, 0, 0.3)";
      break;
    case "WorfTips":
      display_name = "Lieutenant Commander Worf";
		  imgsrc = "https://pbs.twimg.com/profile_images/3546394849/e6648db23a1e015e451fdbb17e0a6014_400x400.jpeg";
		  tweetbg = "rgba(242, 195, 0, 0.3)";
      break;
	  case "LaForgeTips":
      display_name = "Lieutenant Commander La Forge";
		  imgsrc = "https://pbs.twimg.com/profile_images/3553189667/1198df5fe022ff7700567fcba40d2721_400x400.jpeg";
		  tweetbg = "rgba(242, 195, 0, 0.3)";
      break;
    default:
      display_name = "Patron #" + i;
	}
  }

  var tweetTimer = function() {
  //if(prev_sname !== sname){
    $('.st-tweets h2').fadeOut(1000, function(){
      $(this).text(display_name);
    });
	  $('.st-tweets a').fadeOut(1000, function(){
      $(this).attr('href', "https://twitter.com/" + sname);
		  $(this).text("@" + sname);
	  });
	  $('.st-tweets img').fadeOut(1000, function(){
      $(this).attr('src', imgsrc);
		  $('.st-tweets').css("background-color", tweetbg);
    });
	//};
    $('.st-tweets h4').fadeOut(1000, function(){
      $(this).text(tngtweets[i].text);
    });

	//if(prev_sname !== sname){
	  $('.st-tweets h2').fadeIn();
	  $('.st-tweets a').fadeIn();
    $('.st-tweets a').fadeIn();
	  $('.st-tweets img').fadeIn();
	//};
    $('.st-tweets h4').fadeIn();

	  prev_sname = sname;
    i = Math.floor(Math.random()*tng_n);
	  sname = tngtweets[i].screen_name;
	  if(sname !== prev_sname) updateinfo(sname);
  }

  $(document).ready(function() {
    $('.st-tweets a').css('color', '#ffffff');
    prev_sname = sname;
	  sname = tngtweets[i].screen_name;
    updateinfo(sname);
  	$('.st-tweets h2').text(display_name);
    $('.st-tweets h4').text(tngtweets[i].text);
  	$('.st-tweets a').attr('href', "https://twitter.com/" + sname);
  	$('.st-tweets a').text("@" + sname);
  	$('.st-tweets img').attr('src', imgsrc);
  	$('.st-tweets').css("background-color", tweetbg);
    setInterval(tweetTimer, 7500);
  });

});

var ds9tweets;
$.getJSON('https://raw.githubusercontent.com/leonawicz/rtrek/master/data-raw/tweet-data/ds9tweets_cleaned.json', function (json) {
  ds9tweets = json;
  var ds9_n = ds9tweets.length
  var i = 0;
  var display_name = "";
  var sname = "";
  var prev_sname = "";
  var imgsrc = "https://pbs.twimg.com/profile_images/928121687853342720/uJoZ0bfU_400x400.jpg";
  var tweetbg = "rgba(223, 0, 0, 0.3)";

  var updateinfo = function(value) {
  switch(value) {
    case "AnnoyedOBrien":
      display_name = "Chief O'Brien";
		  imgsrc = "https://pbs.twimg.com/profile_images/928121687853342720/uJoZ0bfU_400x400.jpg";
		  tweetbg = "rgba(242, 195, 0, 0.3)";
      break;
    case "ColNerys":
      display_name = "Col. Kira Nerys";
      imgsrc = "https://pbs.twimg.com/profile_images/955154912316452865/E5ev1QCv_400x400.jpg";
      tweetbg = "rgba(223, 0, 0, 0.3)";
      break;
    case "RealElimGarak":
      display_name = "Elim Garek";
		  imgsrc = "https://pbs.twimg.com/profile_images/831623685652021248/Ba_KKb-L_400x400.jpg";
		  tweetbg = "rgba(69, 139, 0, 0.3)";
      break;
    case "realRealDukat":
      display_name = "Gul Dukat";
		  imgsrc = "https://pbs.twimg.com/profile_images/819467910825418752/vGiM7-H1_400x400.jpg";
		  tweetbg = "rgba(45, 45, 45, 0.3)";
      break;
    case "realGulDukat":
      display_name = "Gul Dukat's personal Twitter";
		  imgsrc = "https://pbs.twimg.com/profile_images/825456314855804928/sITu31PR_400x400.jpg";
		  tweetbg = "rgba(255, 127, 36, 0.3)";
      break;
    case "itsvicfontaine":
      display_name = "Vic Fontaine";
		  imgsrc = "https://pbs.twimg.com/profile_images/929951687606804480/Apc1bkfy_400x400.jpg";
		  tweetbg = "rgba(0, 153, 246, 0.3)";
      break;
    default:
      display_name = "Patron #" + i;
	}
  }

  var tweetTimer = function() {
  //if(prev_sname !== sname){
    $('.st-tweets2 h2').fadeOut(1000, function(){
      $(this).text(display_name);
    });
	  $('.st-tweets2 a').fadeOut(1000, function(){
      $(this).attr('href', "https://twitter.com/" + sname);
		  $(this).text("@" + sname);
	  });
	  $('.st-tweets2 img').fadeOut(1000, function(){
      $(this).attr('src', imgsrc);
		  $('.st-tweets2').css("background-color", tweetbg);
    });
	//};
    $('.st-tweets2 h4').fadeOut(1000, function(){
      $(this).text(ds9tweets[i].text);
    });

	//if(prev_sname !== sname){
	  $('.st-tweets2 h2').fadeIn();
	  $('.st-tweets2 a').fadeIn();
    $('.st-tweets2 a').fadeIn();
	  $('.st-tweets2 img').fadeIn();
	//};
    $('.st-tweets2 h4').fadeIn();

	  prev_sname = sname;
    i = Math.floor(Math.random()*ds9_n);
	  sname = ds9tweets[i].screen_name;
	  if(sname !== prev_sname) updateinfo(sname);
  }

  $(document).ready(function() {
    $('.st-tweets2 a').css('color', '#ffffff');
    prev_sname = sname;
	  sname = ds9tweets[i].screen_name;
    updateinfo(sname);
  	$('.st-tweets2 h2').text(display_name);
    $('.st-tweets2 h4').text(ds9tweets[i].text);
  	$('.st-tweets2 a').attr('href', "https://twitter.com/" + sname);
  	$('.st-tweets2 a').text("@" + sname);
  	$('.st-tweets2 img').attr('src', imgsrc);
  	$('.st-tweets2').css("background-color", tweetbg);
    setInterval(tweetTimer, 8500);
  });

});

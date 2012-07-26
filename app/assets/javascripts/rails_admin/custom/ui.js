$(document).ready(function() {
  /* Pull a higher resolution avatar for retina displays. */
  var $avatar = $(".navbar ul.pull-right > li:last > img");
  $avatar
    .attr("src", $avatar.attr("src").replace("?s=30", "?s=90"))
    .attr("width", "30")
    .attr("height", "30");

  $(".show_in_app_member_link > a").attr("target", "_blank");

  /*$(".links > ul > li.toggle_active_member_link").click(function() {
    alert("Are you sure?");
    $.ajax();
    return false;
  });*/
});
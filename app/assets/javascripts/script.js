$(document).ready(function() {
  $('#micropost_content').keyup(function() {
    var msg_length = $(this).val().length;
    var avail = 140 - msg_length;
    var msg = $("#length_message");
    msg.html(avail);
    if (avail < 0) {
      msg.removeClass("remaining-close").addClass("remaining-over");
    } else if (avail >= 0 && avail <= 10) {
      msg.removeClass("remaining-ok").removeClass("remaining-over").addClass("remaining-close");
    } else {
      msg.removeClass("remaining-close").addClass("remaining-ok");
    }
  });
});
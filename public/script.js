$(document).ready(function() {

  $(".edit_post_btn").on("click", function(e) {
    $(e.target).next('.update_post_form').show();
  })

  $("#cancel_post_edit").on("click", function(e) {
    $(e.target).next('.update_post_form').hide();
  })


}); // END DOC READY
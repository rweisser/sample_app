# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->

  # Remaining character counter for the micropost content textarea.

  $("#micropost_content").keyup ->
    max = 140
    len = $(this).val().length
    if len > max
      # Can't use .text on textarea, have to use .val.
      $(this).val $(this).val().substring(0, max)
      len = max
    remaining = max - len
    plural = if remaining == 1 then "" else "s"
    $('#mc_remaining').text "#{remaining} character#{plural} remaining"

# I originally wrote this in javascript.  This version does not
# prevent the user from entering more characters than the max allowd.
# 
# $(function() {
# 
#     $("#micropost_content").keyup(function() {
#         var remaining = 140 - $(this).val().length;
#         var plural = remaining == 1 ? "" : "s";
#         $('#mc_remaining').text(remaining +
#             ' character' + plural + ' remaining');
#     });
# 
# });

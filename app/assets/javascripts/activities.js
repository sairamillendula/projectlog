$(function(){
  $(".new_activity .hide_activity_form a").live("click", function(){
    $("form.new_activity").slideUp(function(){
       $(this).remove();
       $('.new_activity_link').show();
    });
    return false;
  });
});
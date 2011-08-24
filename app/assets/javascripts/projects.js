$(function(){
  $("form.edit_project").submit(function(){
    // Remove duplicate fields that are hidden so they don't get submitted inadvertently to the server
    $('input[name=\'project[total_unit]\']:hidden').remove();    
    $('input[name=\'project[default_rate]\']:hidden').remove();
    return true;
  });
  
});

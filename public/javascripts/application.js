$(function() {
  $("#activities th a, #activities .pagination a").live("click", function() {
    $.getScript(this.href);
    return false;
  });
  
  $("#activities_search input").live("keyup", function() {
    console.log($("#activities_search"));
    $.get($("#activities_search").attr("action"), $("#activities_search").serialize(), null, "script");
    return false;
  });  
});
$(function(){
  $("#toggle_search_form").click(function(e){
    $("#quick_search").toggle("fast");
    $("#advanced_search").toggle("fast");
    e.preventDefault();
  });
  
  console.log(window.location); 
  if (document.URL.indexOf("form=advanced") >= 0) {
       // Toggle to advanced form right away.
       $("#toggle_search_form").click();
  }
});

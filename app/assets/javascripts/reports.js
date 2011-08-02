$(function(){
  $("#toggle_search_form").click(function(e){
    $("#quick_search").toggle("fast");
    $("#advanced_search").toggle("fast");
    e.preventDefault();
  });
  
  if (document.URL.indexOf("form=advanced") >= 0) {
       // Toggle to advanced form right away.
       $("#toggle_search_form").click();
  }
  
  $("#quick_search_start_date").change(function(){
    var start_date = new Date(Date.parse($(this).val()));
    var end_date = new Date(start_date.getFullYear(), start_date.getMonth() + 1, 1); // First day of the next month
    end_date = new Date(end_date - 1); // Last second of the current month
    $("#quick_search_end_date").val(end_date.getFullYear() + "-" + (end_date.getMonth() + 1) + "-" + end_date.getDate()); // Convert the date to 'YYYY-MM-DD' format
    return false;
  });
  
  // Show loading indicator while creating report
  $("#new_quick_report, #new_advanced_report").submit(function(){
    $("img.loading").slideDown();
    return true;
  });
});

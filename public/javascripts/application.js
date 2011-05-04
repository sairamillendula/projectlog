// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

// Make .occurence clickable and go to action Show
<script type="text/javascript" charset="utf-8">
$(document).ready(function(){
	$(".occurence").click(function(){
	  window.location=$(this).find("a").attr("href"); return false;
	});
});
</script>
@Projects = {}
@Projects.Form =
  init: (ajax=false) ->
    if ajax
      $(document).bind 'DOMNodeInserted', (event) ->
        if $(event.target).prop("id") == "new_project_dialog"
          Projects.Form.setup()
    else
      Projects.Form.setup()
  	
  setup: ->
    $("#internal").change ->
    	$("#billing").toggle()
    	$("#internal-notice").toggle()
    	
    $("#project_billing_code_id").bind 'change', Projects.Form.handleNewSelection

    # Run the event handler once now to ensure everything is as it should be
    Projects.Form.handleNewSelection.apply($("#project_billing_code_id"))
    	
  hideBillingScenario: ->
    $("#hourly, #per_diem, #fixed").hide()
      
  handleNewSelection: ->
    Projects.Form.hideBillingScenario()
    
    switch $(this).find('option:selected').val()
      when "1"
        $("#hourly").show()
        $('#hourly').find("input[type=text]").attr("disabled", false)
        $('#per_diem').find("input[type=text]").attr("disabled", true)
        $('#fixed').find("input[type=text]").attr("disabled", true)
      when "2" 
        $("#per_diem").show()
        $('#hourly').find("input[type=text]").attr("disabled", true)
        $('#per_diem').find("input[type=text]").attr("disabled", false)
        $('#fixed').find("input[type=text]").attr("disabled", true)
      when "3" 
        $("#fixed").show()
        $('#hourly').find("input[type=text]").attr("disabled", true)
        $('#per_diem').find("input[type=text]").attr("disabled", true)
        $('#fixed').find("input[type=text]").attr("disabled", false)
